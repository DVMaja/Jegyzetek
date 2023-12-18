

--create database oktatas
use oktatas


create table evfolyam
(
evf tinyint,
primary key (evf)
)


create table tantargy
(
tant char(5),
megnev varchar(20) not null,
heti_oraszam tinyint not null,
primary key (tant)
)


create table tanterv 
(
evf tinyint,
tant char(5),
primary key (evf, tant),
foreign key (evf) references evfolyam (evf),
foreign key (tant) references tantargy (tant)
)

create table osztaly
(
evf tinyint,
betu char(1),
--ofonok,
primary key (evf, betu),
foreign key (evf) references evfolyam (evf)
)


create table tanit
(
evf tinyint,
betu char(1),
tant char(5),
tanar smallint
-- , KK lesz neki, de a K felesleges, ha aut. töltjük fel
)




-- tanít sorainak elõállítása:
--INSERT INTO TANIT
select o.evf, o.betu, v.tant, null
from tanterv v	
	inner join osztaly o on v.evf=o.evf
--order by 3,4

go

CREATE PROCEDURE tt_generalas 
-- ennek most nincs bemeenõ paramétere
AS
BEGIN
	
	if 0=(select count(*) from tanit)

		insert into tanit
		select o.evf, o.betu, v.tant, null
		from tanterv v	
		inner join osztaly o on v.evf=o.evf
	else 
		print 'már megtörtént...'

END
GO


--exec tt_generalas 

--select * from tanit

create table tanar
(
kod int identity(1,1),
nev varchar(30) not null,
belepes date not null,
aktiv bit not null,
primary key (kod)
)

create table kepes
(
tanar int,
tant char(5),
primary key (tanar, tant),
foreign key (tanar) references tanar(kod),
foreign key (tant) references tantargy(tant)
)
---

alter table tanit
--alter column tanar int
add foreign key (tanar, tant) references kepes (tanar, tant)
------------------------------------------------------------

create table diak
(
azon int identity(100,1),
nev varchar(30) not null,
evf tinyint not null,
betu char(1) not null,
primary key (azon),
foreign key (evf, betu) references osztaly (evf, betu)
)

create table jegy
(
diak int not null,
mikor datetime not null,
tant char(5) not null,
jegy tinyint not null,
-- jegytipus not null,
foreign key (diak) references diak(azon)
-- a tantárgyra nem kellene hivatk. mert ellenõrzés kell
)

-- pl.  ez hibás lenne: insert into jegy values (101, getdate(), 'MAT3', 4)
-- delete from jegy

select * from jegy

-- hiányzik az órarend és hiányzás tábla
-- ld. EK diagram
-- és akkor kell 1 eljárás a hiányzás felvitelére is...
