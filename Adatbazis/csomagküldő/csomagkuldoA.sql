
-- rendelések teljesítése A verzióban:
-- a rendelés összes tételét egy csomagban küldik ki, ha mindenbõl van elég a készleten
-- a csomag tételei tehát a rendelés azon sorai, ahol a csomag ki van töltve 
-- (a konkrét becsomagolt cikkek a rend_tételben vannak, amelyeknek a rend.számához kitöltött csomag tart.)
-- persze több rendelésének a tételeit is megkaphatja a vevõ 1 csomagban
-- a cikkekbõl n dobozzal lehet rendelni a vevõknek (itt nincs mértékegység)
-- a fizetés a rendeléskor tört.
-- a fizetés a rendeléskor történik vagy történik az átadásnál

create database csomagkuldoA
go

use csomagkuldoA

-- adattáblák és kapcsolataik a mezõkre vonatk. egyszerû korlátozásokkal (check feltétel)

create table cikk
(
cikkszám char(10),
elnev varchar(30) not null,
akt_készlet smallint check (akt_készlet>=0), 
egys_ár money check (egys_ár>0),
primary key (cikkszám)
)

CREATE TABLE vevõ
(
vkód int,
név varchar(20) not null,
cím varchar(40) not null,
tel int
PRIMARY KEY (vkód)
)

create table csomag
(
csomag char(12),
feladva date,
primary key (csomag)
)

create table rendelés
(
rend_szám char(12),
kelt date not null, 
vkód int not null, 
csomag char(12),
primary key (rend_szám)
)

create table rend_tétel
(
rend_szám char(12),
cikkszám char(10),
menny smallint not null check (menny>0),
primary key (rend_szám, cikkszám)
)

alter table rendelés
add foreign key (vkód) references Vevõ (vkód)

alter table rendelés
add foreign key (csomag) references Csomag (csomag)

alter table rend_tétel
add foreign key (rend_szám) references Rendelés (rend_szám)

alter table rend_tétel
add foreign key (cikkszám) references Cikk (cikkszám)


--- tesztadatok

insert into cikk values 
('c0001', 'ásó', 17, 1000),
('c0002', 'locsoló', 196, 1200),
('c0003', 'szalmakalap', 0, 2000),
('c11', 'súroló', 118, 780),
('c12', 'konyhai polc', 0, 3000),
('c13', 'nyugágy', 1, 5500),
('c44', 'napernyõ', 8, 2000)

insert into vevõ values 
(1, 'Õ', 'Pécs...', null),
(5, 'Más', 'Budapest...', null),
(23, 'Valaki', 'Budapest...', null),
(55, 'Kovács...', 'Pécs...', null),
(56, 'Szabó...', 'Szeged...', null)

insert into csomag values 
('cs55', '20080522'),
('cs66', '20080522'),
('cs79', '20080528')

insert into rendelés values 
('2008/001', '20080423', 5, 'cs55'),
('2008/002', '20080423', 1, 'cs66'),
('2008/123', '20080412', 55, null),
('2008/129', '20080414', 55, null),
('2008/321', '20080514', 5, 'cs55'),
('2008/456', '20080514', 55, null),
('2008/457', '20080514', 56, null),
('2008/601', '20080311', 5, null),
('2008/777', '20080411', 55, 'cs79'),
('2008/779', '20080527', 55, 'cs79')


insert into rend_tétel values 
('2008/001', 'c0001', 2),
('2008/001', 'c0002', 3),
('2008/002', 'c0002', 1),
('2008/002', 'c0003', 5),
('2008/123', 'c11', 2),
('2008/123', 'c12', 1),
('2008/129', 'c13', 2),
('2008/321', 'c12', 1),
('2008/456', 'c44', 1),
('2008/457', 'c44', 1),
('2008/601', 'c0001', 1),
('2008/601', 'c11', 5),
('2008/777', 'c13', 2),
('2008/777', 'c44', 1),
('2008/779', 'c13', 2),
('2008/779', 'c44', 1)



select * from cikk
select * from vevõ
select * from csomag
select * from rendelés
select * from rend_tétel


-- Melyik teljesítetlen rendelés csomagolható az akt. készletek alapján?

-- melynek minden tételébõl van elég, azaz nincs azok között, amelynek elõfordul legalább egy, kevés készlettel rendelkezõ tétele:

SELECT *
FROM rendelés
WHERE csomag is null
and rend_szám NOT IN (
	SELECT rt.rend_szám 
	from rendelés r, rend_tétel rt, cikk c
	where csomag is null
	and r.rend_szám=rt.rend_szám and c.cikkszám=rt.cikkszám
	and menny>akt_készlet);

-- vagy
SELECT *
FROM rendelés
WHERE csomag is null
and rend_szám NOT IN (
	SELECT rt.rend_szám 
	from rendelés r 
		inner join rend_tétel rt on r.rend_szám=rt.rend_szám
		inner join cikk c on c.cikkszám=rt.cikkszám
	where csomag is null
	and menny>akt_készlet);

-- vagy
SELECT *
FROM rendelés K
WHERE csomag is null
and NOT EXISTS (
	SELECT rt.rend_szám 
	from rendelés r 
		inner join rend_tétel rt on r.rend_szám=rt.rend_szám
		inner join cikk c on c.cikkszám=rt.cikkszám
	where csomag is null
	and menny>akt_készlet
	and rt.rend_szám=K.rend_szám);

-- figyelem: ettõl még nem csökkentek az akt_készletek (ahhoz trigger kell, ill. egy szabályozott ügymenet)
-- ezen E-tábla kelt szerinti rendezése pl. segíti a teljesítés menetét (de ez nem dinamikus lista, vagyis minden csomagolás után újra futtatandó)

-- Ellenõrizzük, elõfordult-e olyan csomag, amely nem egyetlen vevõ rendelési tételeit tartalmazta!

select csomag, count(distinct vkód) as ennyi_vevõnek --, count(vkód) as valójában_ennyi_rendtételt
from rendelés
where csomag is not null
group by csomag
having count(distinct vkód)>1

-- Annak utólagos ellenõrzése, h a csomagolás pillanatában elegek voltak_e a készletek, nem egyszerû, 
-- de a nyitókészletek és a beszerzések külön táblában vezetett nyt. nélkül nem is lenne megoldható.



-- Mennyi napernyõt rendeltek eddig és mennyit szállítottak már ki?

select sum(menny), 'össz_rend' as megj
from rend_tétel rt inner join cikk c on rt.cikkszám=c.cikkszám
where elnev like '%napernyõ%'
UNION
select sum(menny), 'össz_száll'
from rend_tétel rt inner join cikk c on rt.cikkszám=c.cikkszám inner join rendelés r on rt.rend_szám=r.rend_szám
where elnev like '%napernyõ%' and csomag is not null

-- esetleg 

select sum(menny) as össz_rend
	, (select sum(menny) 
		from rend_tétel szt 
		inner join rendelés r on szt.rend_szám=r.rend_szám and csomag is not null
		inner join cikk on cikk.cikkszám=szt.cikkszám and elnev like '%napernyõ%' ) as össz_száll
from rend_tétel rt inner join cikk c on rt.cikkszám=c.cikkszám
where elnev like '%napernyõ%'


-- Hány nap alatt teljesítették az egyes rendeléseket? 

select r. rend_szám, datediff(day, kelt, feladva) as nap_múlva
-- select feladva-kelt
from rendelés r inner join csomag cs on r.csomag=cs.csomag
-- a csomag törzzsel való belsõ ökapcsoláskor eltûnnek az árva gyerek-sorok (itt rendelés-sorok)




