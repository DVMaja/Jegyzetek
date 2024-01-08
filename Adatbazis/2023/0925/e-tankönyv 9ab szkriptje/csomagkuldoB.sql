
-- rendel�sek teljes�t�se B verzi�ban:
-- a rendel�s b�rmely t�tel�t kik�ldhetik egy csomagban, amikor a t�bbib�l nincs el�g a k�szleten
-- teh�t max. annyi csomagot kaphat a megrendel�, ah�ny t�tele volt (de a t�telek mennyis�ge nem megbonthat�)
-- a csomag t�telei teh�t a rend_t�tel azon sorai, ahol a csomag ki van t�ltve 
-- persze t�bb rendel�s�nek a t�teleit is megkaphatja a vev� 1 csomagban
-- a cikkekb�l n dobozzal lehet rendelni a vev�knek (itt nincs m�rt�kegys�g)

create database csomagkuldoB
go

use csomagkuldoB

-- adatt�bl�k �s kapcsolataik a mez�kre vonatk. egyszer� korl�toz�sokkal (check felt�tel)

create table cikk
(
cikksz�m char(10),
elnev varchar(30) not null,
akt_k�szlet smallint check (akt_k�szlet>=0), 
egys_�r money check (egys_�r>0),
primary key (cikksz�m)
)

CREATE TABLE vev�
(
vk�d int,
n�v varchar(20) not null,
c�m varchar(40) not null,
tel int
PRIMARY KEY (vk�d)
)

create table csomag
(
csomag char(12),
feladva date,
primary key (csomag)
)

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
csomag char(12),
primary key (rend_sz�m, cikksz�m)
)

alter table rendel�s
add foreign key (vk�d) references Vev� (vk�d)

alter table rend_t�tel
add foreign key (rend_sz�m) references Rendel�s (rend_sz�m)

alter table rend_t�tel
add foreign key (cikksz�m) references Cikk (cikksz�m)

alter table rend_t�tel
add foreign key (csomag) references Csomag (csomag)


--- tesztadatok

insert into cikk values 
('c0001', '�s�', 17, 1000),
('c0002', '�s�', 194, 1200),
('c0003', 'szalmakalap', 0, 2000)

insert into vev� values 
(1, '�', 'P�cs...', null),
(5, 'M�s', 'Budapest...', null)

insert into csomag values 
('cs01', '20080423'),
('cs02', '20080423'),
('cs03', '20080423')


insert into rendel�s values 
('2008/001', '20080423', 5),
('2008/002', '20080423', 1),
('2008/601', '20080311', 5)


insert into rend_t�tel values 
('2008/001', 'c0001', 2, 'cs01'),
('2008/001', 'c0002', 3, 'cs02'),
('2008/002', 'c0002', 1, 'cs03'),
('2008/002', 'c0003', 5, null),
('2008/601', 'c0001', 1, 'cs01'),
('2008/601', 'c0002', 2, null)


--select * from cikk
--select * from vev�
--select * from csomag
--select * from rendel�s
--select * from rend_t�tel


-- Melyik teljes�tetlen rendel�st�tel csomagolhat� be az akt. k�szletek alapj�n?
-- b�rmely t�tel, ami m�g nincs becsomagolva, de van bel�le el�g:

SELECT rt.*
FROM rend_t�tel AS rt, cikk AS c
WHERE csomag is null 
and c.cikksz�m=rt.cikksz�m
and menny<=akt_k�szlet;

-- vagy
SELECT rt.*
from rend_t�tel rt inner join cikk c on c.cikksz�m=rt.cikksz�m
	where csomag is null
	and menny>akt_k�szlet;


-- figyelem: ett�l m�g nem cs�kkent az akt_k�szlet (ahhoz trigger kell, ill. egy szab�lyozott �gymenet)
-- ezen E-t�bla pl. kelt szerinti rendez�se seg�ti a teljes�t�s menet�t (de ez nem dinamikus lista, vagyis minden csomagol�s ut�n �jra futtatand�)
	SELECT rt.*, kelt
	from rend_t�tel rt 
			inner join cikk c on c.cikksz�m=rt.cikksz�m
			inner join rendel�s r on rt.rend_sz�m=r.rend_sz�m
	where csomag is null and menny>akt_k�szlet
	order by kelt;


-- Ellen�rizz�k, el�fordult-e olyan csomag, amely nem egyetlen vev� rendel�si t�teleit tartalmazta!

select csomag, count(distinct vk�d) as ennyi_vev�nek --, count(vk�d) as val�j�ban_ennyi_rendt�telt
from rend_t�tel rt inner join rendel�s r on rt.rend_sz�m=r.rend_sz�m
where csomag is not null
group by csomag
having count(distinct vk�d)>1

-- Annak ut�lagos ellen�rz�se, h a csomagol�s pillanat�ban elegek voltak_e a k�szletek, nem egyszer�, 
-- de a nyit�k�szletek �s a beszerz�sek k�l�n t�bl�ban vezetett nyt. n�lk�l nem is lenne megoldhat�.


-- Mennyi �s�t rendeltek eddig �s mennyit sz�ll�tottak m�r ki?

select sum(menny), '�ssz_rend' as megj
from rend_t�tel rt inner join cikk c on rt.cikksz�m=c.cikksz�m
where elnev like '%�s�%'
UNION
select sum(menny), '�ssz_sz�ll'
from rend_t�tel rt inner join cikk c on rt.cikksz�m=c.cikksz�m 
where elnev like '%�s�%' and csomag is not null

-- esetleg 

select sum(menny) as �ssz_rend
	, (select sum(menny) 
		from rend_t�tel szt 
			inner join cikk on cikk.cikksz�m=szt.cikksz�m where elnev like '%�s�%' and csomag is not null) as �ssz_sz�ll
from rend_t�tel rt inner join cikk c on rt.cikksz�m=c.cikksz�m
where elnev like '%�s�%'


-- H�ny nap alatt teljes�tett�k az egyes rendel�seket? 
-- ehhez a rendel�s �sszes t�tele legyen kisz�ll�tott, �s azok k�l�nb. id�beli kisz�ll�t�sainak a legnagyobbik�val sz�molva: 

select r.rend_sz�m, max(datediff(day, kelt, feladva)) as nap_m�lva
-- select feladva-kelt is haszn�lhat� �jra a datediff() helyett
from rendel�s r inner join rend_t�tel rt on rt.rend_sz�m=r.rend_sz�m inner join csomag cs on rt.csomag=cs.csomag
where not exists (select 1 from rend_t�tel where csomag is null and rend_sz�m=r.rend_sz�m)
group by r.rend_sz�m
-- a csomag t�rzzsel val� bels� �kapcsol�skor elt�nnek az �rva gyerek-sorok (itt rend_t�tel-sorok)






