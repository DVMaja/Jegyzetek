
-- rendelések teljesítése C verzióban:
-- a rendelés bármely tételének a mennyisége is megbontható és kiszállítható egy csomagban, amikor abból kevesebb van a készleten
-- tehát max. annyi csomagot kaphat a megrendelõ, ahány a tételei mennyiségének az összege volt
-- a csomag tételei külön táblában vannak, mint tényadatok
-- persze több rendelésének a tételeit is megkaphatja a vevõ 1 csomagban
-- a cikkekbõl n dobozzal lehet rendelni a vevõknek (itt nincs mértékegység)

create database csomagkuldoC
go

use csomagkuldoC

-- adattáblák és kapcsolataik a mezõkre vonatk. egyszerû korlátozásokkal (check feltétel)

create table cikk
(
cikkszám char(10),
elnev varchar(30) not null,
akt_készlet smallint check (akt_készlet>=0), 
egys_ár money check (egys_ár>0),
primary key (cikkszám)
)

-- a vevõ törzstáblát most kihagyjuk
--CREATE TABLE vevõ
--(
--vkód int,
--név varchar(20) not null,
--cím varchar(40) not null,
--tel int
--PRIMARY KEY (vkód)
--)

create table rendelés
(
rend_szám char(12),
kelt date not null, 
vkód int not null, 
primary key (rend_szám)
)

create table rend_tétel
(
rend_szám char(12),
cikkszám char(10),
menny smallint not null check (menny>0),
primary key (rend_szám, cikkszám)
)

create table csomag
(
csomag char(12),
feladva date,
primary key (csomag)
)

create table csom_tétel 
-- egy csomag tételei aut. sorszámozhatók a felületen (itt felesleges lenne rá triggert írni)
(
csomag char(12),
sorszám tinyint, 
rend_szám char(12) not null,
cikkszám char(10) not null,
menny smallint not null check (menny>0)
primary key (csomag, sorszám)
)

--alter table rendelés
--add foreign key (vkód) references Vevõ (vkód)

alter table rend_tétel
add foreign key (rend_szám) references Rendelés (rend_szám)

alter table rend_tétel
add foreign key (cikkszám) references Cikk (cikkszám)

alter table csom_tétel
add foreign key (csomag) references Csomag (csomag)

alter table csom_tétel
add foreign key (rend_szám, cikkszám) references Rend_tétel (rend_szám, cikkszám)


--- tesztadatok

insert into cikk values 
('222', 'pároló', 7, 5000),
('333', 'sütõtál', 4, 6000),
('c11', 'súroló', 118, 780),
('c12', 'polc', 0, 300),
('c13', 'nyugágy', 9, 5500),
('c44', 'napernyõ', 8, 2000)


--insert into vevõ values 
--(1, 'Õ', 'Pécs...', null),
--(5, 'Más', 'Budapest...', null)


insert into rendelés values 
('2008/123', '20080412', 55),
('2008/129', '20080414', 55),
('2008/321', '20080514', 5),
('2008/333', '20080810', 556),
('2008/456', '20080514', 55)


insert into rend_tétel values 
('2008/123', 'c11', 2),
('2008/123', 'c12', 1),
('2008/129', 'c13', 2),
('2008/321', 'c12', 1),
('2008/333', 'c13', 10),
('2008/333', 'c44', 5),
('2008/456', 'c44', 5)

insert into csomag values
('k1', '20080815'),
('k2', '20080829'),
('k3', null)

insert into csom_tétel values
('k1', 1, '2008/333', 'c13', 10),
('k1', 2, '2008/333', 'c44', 2),
('k2', 1, '2008/333', 'c44', 2)

--select * from cikk
--select * from rendelés
--select * from rend_tétel
--select * from csomag
--select * from csom_tétel


-- Melyik teljesítetlen rendeléstétel csomagolható be az akt. készletek alapján?
-- bármely rend.tétel, amibõl  még nincs az összes megrendelt mennyiség becsomagolva, és akt. van belõle elég:

-- 1.lépésben mely rend.tételbõl mennyi ment ki:

create view kiment as
SELECT rend_szám, cikkszám, sum(menny) AS kiment
FROM csom_tétel
GROUP BY rend_szám, cikkszám
-- hozzáfûzzük azokat a rend.tételeket, amelyekbõl 0 ment ki:
UNION
select rend_szám, cikkszám, 0
from rend_tétel rt
where not exists (select 1 from csom_tétel where rend_szám=rt.rend_szám and cikkszám=rt.cikkszám)

-- mentve kiment nézetként, majd a rend_tételen haladva az ökapcsolásukból megjeleníthetõk a hátralékok:

create view hátralék as
select rt.rend_szám, rt.cikkszám, rt.menny-k.kiment as hátralék
from kiment k inner join rend_tétel rt on k.rend_szám=rt.rend_szám and k.cikkszám=rt.cikkszám 
--where rt.menny<>k.kiment
-- mentsük el akár hátralék nézetként!
-- megj. egy negatív hátralék azt jelentené, h több ment ki, mint amennyit rendeltek

-- 3.lépésben kiírjuk azokat a valódi hátralékokat, amelyek a pill. készletbõl teljesíthetõk:
select * from rend_tétel
SELECT h.*
FROM hátralék AS h, cikk AS c
WHERE h.cikkszám=c.cikkszám And hátralék<=akt_készlet and hátralék>0;

-- figyelem: ettõl még nem csökkent az akt_készlet (ahhoz trigger kell, ill. egy szabályozott ügymenet)
-- ezen E-tábla pl. kelt szerinti rendezése segíti a teljesítés menetét (de ez nem dinamikus lista, vagyis minden csomagolás után újra futtatandó)


-- Ellenõrizzük, elõfordult-e olyan csomag, amely nem egyetlen vevõ rendelési tételeit tartalmazta!

select csomag, count(distinct vkód) as ennyi_vevõnek --, count(vkód) as valójában_ennyi_csomagtételt
from csom_tétel cst inner join rendelés r on cst.rend_szám=r.rend_szám
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
from csom_tétel cst inner join cikk c on cst.cikkszám=c.cikkszám 
where elnev like '%napernyõ%' 

-- esetleg 

select sum(menny) as össz_rend
	, (select sum(menny) 
		from csom_tétel cst 
			inner join cikk on cikk.cikkszám=cst.cikkszám where elnev like '%napernyõ%') as össz_száll
from rend_tétel rt inner join cikk c on rt.cikkszám=c.cikkszám
where elnev like '%napernyõ%'


-- Hány nap alatt teljesítették az egyes rendeléseket? 
-- ehhez a rendelés összes tétele legyen kiszállított, és azok különb. idõbeli kiszállításainak a legnagyobbikával számolva: 

select cst.rend_szám, max(datediff(day, kelt, feladva)) as nap_múlva
-- select feladva-kelt is használható újra a datediff() helyett
from rendelés r inner join csom_tétel cst on cst.rend_szám=r.rend_szám inner join csomag cs on cst.csomag=cs.csomag
where not exists (select 1 from hátralék where rend_szám=cst.rend_szám and hátralék>0)
group by cst.rend_szám

-- megj. a csomag feladva dátuma jelezhetné jelen egyszerû ügyvitelben, h kiment-e a csomag, ha nem tartunk rá egy státuszt 
-- (pl. 0-üres, 1-van benne tétel, 2-lezárt, 3-kiküldött,...)


