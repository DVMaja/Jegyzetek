
-- rendel�sek teljes�t�se C verzi�ban:
-- a rendel�s b�rmely t�tel�nek a mennyis�ge is megbonthat� �s kisz�ll�that� egy csomagban, amikor abb�l kevesebb van a k�szleten
-- teh�t max. annyi csomagot kaphat a megrendel�, ah�ny a t�telei mennyis�g�nek az �sszege volt
-- a csomag t�telei k�l�n t�bl�ban vannak, mint t�nyadatok
-- persze t�bb rendel�s�nek a t�teleit is megkaphatja a vev� 1 csomagban
-- a cikkekb�l n dobozzal lehet rendelni a vev�knek (itt nincs m�rt�kegys�g)

create database csomagkuldoC
go

use csomagkuldoC

-- adatt�bl�k �s kapcsolataik a mez�kre vonatk. egyszer� korl�toz�sokkal (check felt�tel)

create table cikk
(
cikksz�m char(10),
elnev varchar(30) not null,
akt_k�szlet smallint check (akt_k�szlet>=0), 
egys_�r money check (egys_�r>0),
primary key (cikksz�m)
)

-- a vev� t�rzst�bl�t most kihagyjuk
--CREATE TABLE vev�
--(
--vk�d int,
--n�v varchar(20) not null,
--c�m varchar(40) not null,
--tel int
--PRIMARY KEY (vk�d)
--)

create table rendel�s
(
rend_sz�m char(12),
kelt date not null, 
vk�d int not null, 
primary key (rend_sz�m)
)

create table rend_t�tel
(
rend_sz�m char(12),
cikksz�m char(10),
menny smallint not null check (menny>0),
primary key (rend_sz�m, cikksz�m)
)

create table csomag
(
csomag char(12),
feladva date,
primary key (csomag)
)

create table csom_t�tel 
-- egy csomag t�telei aut. sorsz�mozhat�k a fel�leten (itt felesleges lenne r� triggert �rni)
(
csomag char(12),
sorsz�m tinyint, 
rend_sz�m char(12) not null,
cikksz�m char(10) not null,
menny smallint not null check (menny>0)
primary key (csomag, sorsz�m)
)

--alter table rendel�s
--add foreign key (vk�d) references Vev� (vk�d)

alter table rend_t�tel
add foreign key (rend_sz�m) references Rendel�s (rend_sz�m)

alter table rend_t�tel
add foreign key (cikksz�m) references Cikk (cikksz�m)

alter table csom_t�tel
add foreign key (csomag) references Csomag (csomag)

alter table csom_t�tel
add foreign key (rend_sz�m, cikksz�m) references Rend_t�tel (rend_sz�m, cikksz�m)


--- tesztadatok

insert into cikk values 
('222', 'p�rol�', 7, 5000),
('333', 's�t�t�l', 4, 6000),
('c11', 's�rol�', 118, 780),
('c12', 'polc', 0, 300),
('c13', 'nyug�gy', 9, 5500),
('c44', 'naperny�', 8, 2000)


--insert into vev� values 
--(1, '�', 'P�cs...', null),
--(5, 'M�s', 'Budapest...', null)


insert into rendel�s values 
('2008/123', '20080412', 55),
('2008/129', '20080414', 55),
('2008/321', '20080514', 5),
('2008/333', '20080810', 556),
('2008/456', '20080514', 55)


insert into rend_t�tel values 
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

insert into csom_t�tel values
('k1', 1, '2008/333', 'c13', 10),
('k1', 2, '2008/333', 'c44', 2),
('k2', 1, '2008/333', 'c44', 2)

--select * from cikk
--select * from rendel�s
--select * from rend_t�tel
--select * from csomag
--select * from csom_t�tel


-- Melyik teljes�tetlen rendel�st�tel csomagolhat� be az akt. k�szletek alapj�n?
-- b�rmely rend.t�tel, amib�l  m�g nincs az �sszes megrendelt mennyis�g becsomagolva, �s akt. van bel�le el�g:

-- 1.l�p�sben mely rend.t�telb�l mennyi ment ki:

create view kiment as
SELECT rend_sz�m, cikksz�m, sum(menny) AS kiment
FROM csom_t�tel
GROUP BY rend_sz�m, cikksz�m
-- hozz�f�zz�k azokat a rend.t�teleket, amelyekb�l 0 ment ki:
UNION
select rend_sz�m, cikksz�m, 0
from rend_t�tel rt
where not exists (select 1 from csom_t�tel where rend_sz�m=rt.rend_sz�m and cikksz�m=rt.cikksz�m)

-- mentve kiment n�zetk�nt, majd a rend_t�telen haladva az �kapcsol�sukb�l megjelen�thet�k a h�tral�kok:

create view h�tral�k as
select rt.rend_sz�m, rt.cikksz�m, rt.menny-k.kiment as h�tral�k
from kiment k inner join rend_t�tel rt on k.rend_sz�m=rt.rend_sz�m and k.cikksz�m=rt.cikksz�m 
--where rt.menny<>k.kiment
-- ments�k el ak�r h�tral�k n�zetk�nt!
-- megj. egy negat�v h�tral�k azt jelenten�, h t�bb ment ki, mint amennyit rendeltek

-- 3.l�p�sben ki�rjuk azokat a val�di h�tral�kokat, amelyek a pill. k�szletb�l teljes�thet�k:
select * from rend_t�tel
SELECT h.*
FROM h�tral�k AS h, cikk AS c
WHERE h.cikksz�m=c.cikksz�m And h�tral�k<=akt_k�szlet and h�tral�k>0;

-- figyelem: ett�l m�g nem cs�kkent az akt_k�szlet (ahhoz trigger kell, ill. egy szab�lyozott �gymenet)
-- ezen E-t�bla pl. kelt szerinti rendez�se seg�ti a teljes�t�s menet�t (de ez nem dinamikus lista, vagyis minden csomagol�s ut�n �jra futtatand�)


-- Ellen�rizz�k, el�fordult-e olyan csomag, amely nem egyetlen vev� rendel�si t�teleit tartalmazta!

select csomag, count(distinct vk�d) as ennyi_vev�nek --, count(vk�d) as val�j�ban_ennyi_csomagt�telt
from csom_t�tel cst inner join rendel�s r on cst.rend_sz�m=r.rend_sz�m
group by csomag
having count(distinct vk�d)>1

-- Annak ut�lagos ellen�rz�se, h a csomagol�s pillanat�ban elegek voltak_e a k�szletek, nem egyszer�, 
-- de a nyit�k�szletek �s a beszerz�sek k�l�n t�bl�ban vezetett nyt. n�lk�l nem is lenne megoldhat�.


-- Mennyi naperny�t rendeltek eddig �s mennyit sz�ll�tottak m�r ki?

select sum(menny), '�ssz_rend' as megj
from rend_t�tel rt inner join cikk c on rt.cikksz�m=c.cikksz�m
where elnev like '%naperny�%'
UNION
select sum(menny), '�ssz_sz�ll'
from csom_t�tel cst inner join cikk c on cst.cikksz�m=c.cikksz�m 
where elnev like '%naperny�%' 

-- esetleg 

select sum(menny) as �ssz_rend
	, (select sum(menny) 
		from csom_t�tel cst 
			inner join cikk on cikk.cikksz�m=cst.cikksz�m where elnev like '%naperny�%') as �ssz_sz�ll
from rend_t�tel rt inner join cikk c on rt.cikksz�m=c.cikksz�m
where elnev like '%naperny�%'


-- H�ny nap alatt teljes�tett�k az egyes rendel�seket? 
-- ehhez a rendel�s �sszes t�tele legyen kisz�ll�tott, �s azok k�l�nb. id�beli kisz�ll�t�sainak a legnagyobbik�val sz�molva: 

select cst.rend_sz�m, max(datediff(day, kelt, feladva)) as nap_m�lva
-- select feladva-kelt is haszn�lhat� �jra a datediff() helyett
from rendel�s r inner join csom_t�tel cst on cst.rend_sz�m=r.rend_sz�m inner join csomag cs on cst.csomag=cs.csomag
where not exists (select 1 from h�tral�k where rend_sz�m=cst.rend_sz�m and h�tral�k>0)
group by cst.rend_sz�m

-- megj. a csomag feladva d�tuma jelezhetn� jelen egyszer� �gyvitelben, h kiment-e a csomag, ha nem tartunk r� egy st�tuszt 
-- (pl. 0-�res, 1-van benne t�tel, 2-lez�rt, 3-kik�ld�tt,...)


