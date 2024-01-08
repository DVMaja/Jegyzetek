-- adott szálloda típusba sorolt szobáit lehet min. 1 éjszakára lefoglalni
-- a lefoglalt szobákat a beköltözésig ki is kell fizetni a megrendelõ ügyfélnek (a szoba teljes ára 1 éjszakára értendõ) 
-- a lefoglalt szobába korlátozott számban beköltözõ vendégek is ügyfelek 
-- megj. ebben a verzióban nincs lemondás

create database szálloda
go

use szálloda

create table szobatipus
(
sztip char(1),
ár money not null,
ágy tinyint not null,
primary key (sztip)
)
insert into szobatipus values ('A', 12500, 2)
insert into szobatipus values ('B', 8000, 2)
insert into szobatipus values ('C', 12000, 3)

create table szoba
(
szszám smallint,
sztip char(1) not null,
primary key (szszám),
foreign key (sztip) references szobatipus (sztip)
)
insert into szoba values (101, 'A')
insert into szoba values (201, 'A')
insert into szoba values (105, 'B')


create table ügyfél
-- megrendelõk és vendégek törzsadatai
(
azon int identity (101,1),
név varchar(20),
cím varchar(40),
-- bankszla 
-- ig_szám
primary key (azon),
)
insert into ügyfél (név, cím) values ('walaki', 'valahol')


create table foglalt
(
szszám smallint,
mettõl date,
meddig date not null,
megrendelõ int not null,
fogl_dátuma datetime not null,
kifiz_dátuma datetime, 
primary key (szszám, mettõl),
foreign key (szszám) references szoba (szszám),
foreign key (megrendelõ) references ügyfél (azon)
)

-- megj.
-- a foglalt természetes kulcsa helyett lehetne egyszerû, egy aut. generált fogl_szám a kulcs
-- ekkor a lakik a foglalás_számmal hivatkozna a foglalt-ra...

create table lakik
(
szszám smallint,
mettõl date,
vendég int,
-- érkezés datetime not null,
-- távozás datetime,
primary key (szszám, mettõl, vendég),
foreign key (szszám, mettõl) references foglalt (szszám, mettõl),
foreign key (vendég) references ügyfél (azon)
)



-- az evidens (kulcsok, külsõ kulcsok, kötelezõ leíró) megszorításokon túli megszorítások nincsenek még beépítve
-- ellenõrzõ lekérdezésekkel MEGJELENÍTJÜK a HIBÁSan rögzített adatokat
-- persze tesztadatok felvitele javasolt a be nem épített megszorítások ellenõrzéséhez  


-- ahol az ágyak száma vagy a szobaár adatok helytelenek
select * from szobatipus
where ágy<=0 or ár<0

-- ahol a foglalás intervalluma rossz
SELECT *
FROM foglalt
WHERE not mettõl<meddig;

-- ahol a foglalás idõpontja késõi
SELECT *
FROM foglalt
WHERE not fogl_dátuma<mettõl;

-- ahol a kifizetés késik 
SELECT *
FROM foglalt
WHERE mettõl<getdate() and kifiz_dátuma is null

-- ahol a beköltözõ tartózkodása nem esik a lefoglalt intervallumba (a 2 mezõ még nincs a lakik-táblában)
select * 
from lakik l inner join foglalt f on l.szszám=f.szszám and l.mettõl=f.mettõl
where not érkezés between f.mettõl and meddig or not távozás between f.mettõl and meddig and távozás is not null

-- ahol többen laknak a lefoglalt szobában, mint ahány ágyas a szoba
SELECT l.szszám, mettõl, count(vendég) AS hány_vendég, MAX(ágy) AS hány_ágyas
FROM lakik l, szoba sz, szobatipus t
WHERE l.szszám=sz.szszám and sz.sztip=t.sztip
GROUP BY l.szszám, mettõl
HAVING NOT count(vendég)<=MAX(ágy);


-- Mely szobafoglalások ütköznek egymással?
-- szálloda esetén a [mettõl, meddig) intervallumoknak nem lehet metszetük egy szobára vonatk. 
-- ui. adott napon délig kijelentkezhetnek, du. bejelentkezhetnek ugyanabba a szobába

SELECT e.szszám, e.fogl_dátuma, e.mettõl, e.meddig, m.szszám, m.fogl_dátuma, m.mettõl, m.meddig
FROM foglalt AS e, foglalt AS m  -- egyik és másik foglalt-sor
WHERE e.szszám=m.szszám and e.mettõl<m.mettõl -- uaz a szoba 2 különb. foglalása
and (e.mettõl between m.mettõl and dateadd(day, -1, m.meddig) OR m.mettõl between e.mettõl and dateadd(day, -1, e.meddig)) -- ütközési feltétel a)
-- and not (e.meddig<=m.mettõl or e.mettõl>=m.meddig) -- ütközési feltétel b)

-- mely foglaláshoz van azzal idõben ütközõ foglalás?
SELECT szszám, mettõl, meddig, 'a szobára ezidõn belül másik foglalás is van' as megj
from foglalt K
where (select count(*) from foglalt 
     where szszám=K.szszám and not (K.meddig<=mettõl or K.mettõl>=meddig)) > 1
-- order by 1,2

-- melyik foglaláshoz hány, azzal idõben ütközõ foglalás van?
 
SELECT szszám, mettõl, meddig, 
    (select count(*) from foglalt 
     where szszám=K.szszám and not (K.meddig<=mettõl or K.mettõl>=meddig)) as ennyi_fogl_van_rá
from foglalt K
where (select count(*) from foglalt 
     where szszám=K.szszám and not (K.meddig<=mettõl or K.mettõl>=meddig)) > 1
-- order by 1,2
	 

-- extra lekérd. a 101-es szoba hány északát volt foglalt 2020-ban?
SELECT sum(datediff(day, mettõl, meddig)) as hibásan_számolva, 
sum(datediff(day, case when '20200101'> mettõl then'20200101' else mettõl end, case when '20201231'< meddig then '20210101' else meddig end)) as ennyi_napon
FROM foglalt
WHERE 2020 between year(mettõl) and year(meddig) 
and szszám=101;


