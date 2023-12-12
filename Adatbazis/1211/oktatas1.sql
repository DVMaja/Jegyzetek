----create database oktatas
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
--3 tantárgy  3.
--4 tantárgy 5
--------------------Tanít-------------------------
--17 sornak kell bekerülni egyenlõre NULL tanárral
--osztaly, tant, tanar
--Hogy lehet automaitkusan 
create table tanit
(
evf tinyint,
betu char(1),
tant char(5),
tanar int,--intnek kell lennie

--primary key() --nincs kulcsa ert nem a felhasználó viszi fel az adatokat
--foreign key() references tanar ()
)
--
--annziszor rakja be eljárás nélkül ahányszor lefuttassuk az insertete
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
--nem feltétlenûl kell, ha jól adtam meg a típusát
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
foreign key(evf, betu) references osztaly (evf, betu) --mert egy táblába vannak
)
--mibõl mikor 

create table jegy
(
diak int not null,
mikor datetime not null,
tant char(5) not null,
jegy tinyint,
--jegytípus not null
foreign key(diak) references diak (azon)
-- a tantárgyra nem kellene hivatkozni mert ellenörzés kell
)
select * from jegy
