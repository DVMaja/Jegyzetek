---create database oktatas
use oktatas


create table evfolyam
(
evf tinyint,
primary key(evf)
)

create table tantargy
(
tant char(5),
megnev varchar(20) not null,
heti_oraszam tinyint not null,
primary key(tant)
)

create table tanterv
(
evf tinyint,
tant char(5),
primary key(evf, tant),
foreign key(evf) references evfolyam (evf),
foreign key(tant) references tantargy (tant)
)

create table osztaly
(
evf tinyint,
betu char(1),
--ofonok
primary key(evf, betu),
foreign key(evf) references evfolyam (evf)
)
--3evf  A B C 
--5 evf A B
--3 tant�rgy  3.
--4 tant�rgy 5
--------------------Tan�t-------------------------
--17 sornak kell beker�lni egyenl�re NULL tan�rral
--osztaly, tant, tanar
--Hogy lehet automaitkusan 
create table tanit
(
evf tinyint,
betu char(1),
tant char(5),
tanar int,--intnek kell lennie

--primary key() --nincs kulcsa ert nem a felhaszn�l� viszi fel az adatokat
--foreign key() references tanar ()
)
--
--annziszor rakja be elj�r�s n�lk�l ah�nyszor lefuttassuk az insertete
--Insert into tanit

Select *--o.evf, o.betu, v.tant, null
from tanterv v
inner join osztaly o on v.evf=o.evf
--order by 3,4 --3,4, 1,2

--********************************************************
create table tanar
(
kod int identity (1, 1),
nev varchar(30) not null,
belepes date not null,
aktiv bit,
primary key(kod)
)

create table kepes
(
tanar int,
tant char(5),
primary key(tanar, tant),
foreign key(tanar) references tanar (kod),
foreign key(tant) references tantargy (tant)
)
--************************************************************************
--nem felt�tlen�l kell, ha j�l adtam meg a t�pus�t
alter table tanit
	alter column tanar int

alter table tanit
add foreign key (tanar, tant) references kepes (tanar, tant)

create table diak
(
azon int identity(100, 1),
nev varchar(30)not null,
evf tinyint not null,
betu char(1),
primary key(azon),
foreign key(evf, betu) references osztaly (evf, betu) --mert egy t�bl�ba vannak
)
--mib�l mikor 

create table jegy
(
diak int not null,
mikor datetime not null,
tant char(5) not null,
jegy tinyint,
--jegyt�pus not null
foreign key(diak) references diak (azon)
-- a tant�rgyra nem kellene hivatkozni mert ellen�rz�s kell
)
select * from jegy

select * from tanterv
select * from osztaly
select * from tanit

drop table orarend

create table orarend
(
evf tinyint,
betu char(1),
nap tinyint,
ora tinyint,
tant char(5),
terem smallint,
primary key (evf, betu, nap, ora),
unique (terem, nap, ora)
)

create table terem
(
tszam smallint,
ferohely smallint,
primary key (tszam)

)
alter table tanit
add primary key(evf, betu, tant)

alter table orarend
add foreign key (evf, betu, tant) references tanit (evf, betu, tant)

alter table orarend
add foreign key (terem) references terem(tszam)

-- a tan�r m�r fel legyen v�ve, 
-- csak annyi �ra legyen le�temezve amennyi 
select * from tanit
select * from tanar
select * from kepes

update tanit set
 tanar=3
 where evf=3 and betu='A' and tant='INFO'