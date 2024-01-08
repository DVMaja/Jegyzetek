
-- rendelések teljesítése B verzióban:
-- a rendelés bármely tételét kiküldhetik egy csomagban, amikor a többibõl nincs elég a készleten
-- tehát max. annyi csomagot kaphat a megrendelõ, ahány tétele volt (de a tételek mennyisége nem megbontható)
-- a csomag tételei tehát a rend_tétel azon sorai, ahol a csomag ki van töltve 
-- persze több rendelésének a tételeit is megkaphatja a vevõ 1 csomagban
-- a cikkekbõl n dobozzal lehet rendelni a vevõknek (itt nincs mértékegység)

create database csomagkuldoB
go

use csomagkuldoB

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
primary key (rend_szám)
)

create table rend_tétel
(
rend_szám char(12),
cikkszám char(10),
menny smallint not null check (menny>0),
csomag char(12),
primary key (rend_szám, cikkszám)
)

alter table rendelés
add foreign key (vkód) references Vevõ (vkód)

alter table rend_tétel
add foreign key (rend_szám) references Rendelés (rend_szám)

alter table rend_tétel
add foreign key (cikkszám) references Cikk (cikkszám)

alter table rend_tétel
add foreign key (csomag) references Csomag (csomag)


--- tesztadatok

insert into cikk values 
('c0001', 'ásó', 17, 1000),
('c0002', 'ásó', 194, 1200),
('c0003', 'szalmakalap', 0, 2000)

insert into vevõ values 
(1, 'Õ', 'Pécs...', null),
(5, 'Más', 'Budapest...', null)

insert into csomag values 
('cs01', '20080423'),
('cs02', '20080423'),
('cs03', '20080423')


insert into rendelés values 
('2008/001', '20080423', 5),
('2008/002', '20080423', 1),
('2008/601', '20080311', 5)


insert into rend_tétel values 
('2008/001', 'c0001', 2, 'cs01'),
('2008/001', 'c0002', 3, 'cs02'),
('2008/002', 'c0002', 1, 'cs03'),
('2008/002', 'c0003', 5, null),
('2008/601', 'c0001', 1, 'cs01'),
('2008/601', 'c0002', 2, null)


--select * from cikk
--select * from vevõ
--select * from csomag
--select * from rendelés
--select * from rend_tétel


-- Melyik teljesítetlen rendeléstétel csomagolható be az akt. készletek alapján?
-- bármely tétel, ami még nincs becsomagolva, de van belõle elég:

SELECT rt.*
FROM rend_tétel AS rt, cikk AS c
WHERE csomag is null 
and c.cikkszám=rt.cikkszám
and menny<=akt_készlet;

-- vagy
SELECT rt.*
from rend_tétel rt inner join cikk c on c.cikkszám=rt.cikkszám
	where csomag is null
	and menny>akt_készlet;


-- figyelem: ettõl még nem csökkent az akt_készlet (ahhoz trigger kell, ill. egy szabályozott ügymenet)
-- ezen E-tábla pl. kelt szerinti rendezése segíti a teljesítés menetét (de ez nem dinamikus lista, vagyis minden csomagolás után újra futtatandó)
	SELECT rt.*, kelt
	from rend_tétel rt 
			inner join cikk c on c.cikkszám=rt.cikkszám
			inner join rendelés r on rt.rend_szám=r.rend_szám
	where csomag is null and menny>akt_készlet
	order by kelt;


-- Ellenõrizzük, elõfordult-e olyan csomag, amely nem egyetlen vevõ rendelési tételeit tartalmazta!

select csomag, count(distinct vkód) as ennyi_vevõnek --, count(vkód) as valójában_ennyi_rendtételt
from rend_tétel rt inner join rendelés r on rt.rend_szám=r.rend_szám
where csomag is not null
group by csomag
having count(distinct vkód)>1

-- Annak utólagos ellenõrzése, h a csomagolás pillanatában elegek voltak_e a készletek, nem egyszerû, 
-- de a nyitókészletek és a beszerzések külön táblában vezetett nyt. nélkül nem is lenne megoldható.


-- Mennyi ásót rendeltek eddig és mennyit szállítottak már ki?

select sum(menny), 'össz_rend' as megj
from rend_tétel rt inner join cikk c on rt.cikkszám=c.cikkszám
where elnev like '%ásó%'
UNION
select sum(menny), 'össz_száll'
from rend_tétel rt inner join cikk c on rt.cikkszám=c.cikkszám 
where elnev like '%ásó%' and csomag is not null

-- esetleg 

select sum(menny) as össz_rend
	, (select sum(menny) 
		from rend_tétel szt 
			inner join cikk on cikk.cikkszám=szt.cikkszám where elnev like '%ásó%' and csomag is not null) as össz_száll
from rend_tétel rt inner join cikk c on rt.cikkszám=c.cikkszám
where elnev like '%ásó%'


-- Hány nap alatt teljesítették az egyes rendeléseket? 
-- ehhez a rendelés összes tétele legyen kiszállított, és azok különb. idõbeli kiszállításainak a legnagyobbikával számolva: 

select r.rend_szám, max(datediff(day, kelt, feladva)) as nap_múlva
-- select feladva-kelt is használható újra a datediff() helyett
from rendelés r inner join rend_tétel rt on rt.rend_szám=r.rend_szám inner join csomag cs on rt.csomag=cs.csomag
where not exists (select 1 from rend_tétel where csomag is null and rend_szám=r.rend_szám)
group by r.rend_szám
-- a csomag törzzsel való belsõ ökapcsoláskor eltûnnek az árva gyerek-sorok (itt rend_tétel-sorok)






