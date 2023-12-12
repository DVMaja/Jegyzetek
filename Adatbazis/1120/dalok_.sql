----create database DALOK
--go

use dalok



--MÛFAJ(m_id, elnevezés)



create table mufaj
(
id int identity(10,1),
elnevezes nvarchar(30) not null,
primary key (id),
unique (elnevezes)
)
----DAL (azon, címe, keletkezése, mûfaja, eredetije)

create table dal
(
azon int identity(1000,1),
cim nvarchar(30) not null,
keletkezes date,
mufaj int not null,
eredeti int,
primary key (azon),
foreign key (mufaj) references mufaj(id),
foreign key (eredeti) references dal(azon)
)


--insert into mufaj
--values ('pop-rock')
--select * from mufaj
--select * from dal

--insert into dal
--values ('Radio GaGa', '20230120', 10, 1001)

go
create function eredeti
(
@azon int
)
returns bit

begin
	declare @ret bit=0
	-- set @ret=0
	if (select eredeti from dal where azon=@azon) is null
		set @ret=1
	return @ret

end
-- select *, dbo.eredeti(azon) from dal

alter table dal
add check (dbo.eredeti(eredeti)=1)

----SZEM_EGY (kód, név, kezd_év, vége_év, jelzés)
--	(a kezdés/alakulás, befejezés/feloszlás évei)
create table szem_egy
(
	kod int identity(100,1),
	nev nvarchar(30) not null,
	kezd_ev smallint not null,
	vege_ev smallint,
	jelzes char(1) not null,
	primary key(kod),
	check(jelzes='S' or jelzes='E'),
	check(kezd_ev<=vege_ev or vege_ev is null)
)
--TAGJA (együttes, személy, dátumtól, dátumig)

create table tagja
(
	egyuttes int,
	szemely int,
	datumtol date,
	datumig date,
	primary key(egyuttes, szemely, datumtol),
	check(datumtol<=datumig or datumig is null)
)

alter table tagja
add foreign key(egyuttes) references szem_egy(kod)

alter table tagja
add foreign key(szemely) references szem_egy(kod)

--insert into szem_egy
--values ('Queen', 1970, null, 'E')


--insert into szem_egy
--values ('Freddie Mercury', 1969, 1991, 'S')


--insert into szem_egy
--values ('Brian May', 1966, null, 'S')

--select * from szem_egy
go

create function jelzese
(
@kod int
)
returns char(1)
begin
	return (select jelzes from szem_egy where kod=@kod)
end

-- select *, dbo.jelzese(kod) from szem_egy

alter table tagja
add check (dbo.jelzese(egyuttes)='E')

alter table tagja
add check (dbo.jelzese(szemely)='S')


-- insert into tagja values (100, 101, '19700203', null)
--select * from tagja


--ALKOTJA (személy, dal, szerep)
-- SZEREP (sz_id, megnevezés, jogdíjas)

create table szerep
(
	id int identity(50,1)
	,megnevezes nvarchar(30) not null
	,jogdijas bit not null
	,primary key(id)
	,unique (megnevezes)
)

--insert into szerep
--values ('zeneszerzõ', 1)
--		,('hangszerelõ', 0)

--select * from szerep

--ALKOTJA (alk_id, személy, dal, szerep)

create table alkotja
(
	alk_id int identity(500,1)
	,szemely int not null
	,dal int not null
	,szerep int not null
	,primary key(alk_id)
	,unique (szemely, dal, szerep)
	,foreign key (szemely) references szem_egy (kod)
	,foreign key (dal) references dal(azon)
	,foreign key (szerep) references szerep (id)
)
go
create function jogdijas
(
@szerep int
)
returns bit
begin
	return(select jogdijas  from szerep where id = @szerep)
end

go
--select dbo.jogdijas(51)

alter table alkotja 
add check(dbo.jelzese(szemely) = 'S')
-- a megszor. felt.: ha jogdíjas a szerep, akkor eredeti a dal
-- a felt. standard log. mûveletekkel: nem jogdíjas vagy eredetei
alter table alkotja 
add check(dbo.jogdijas(szerep) = 0 or dbo.eredeti(dal) = 1)


--select * from szem_egy
--select * from dal
--select * from szerep

--insert into alkotja
--values (101, 1000, 50)

--select * from alkotja

-- az alkotás tényeinek megvált. naplózva lesz:
--create table valt
(
alkotja int,
meddig date,
r_szemely int,
r_dal int,
r_szerep int
-- PK felesleges, FK is az
-- trigger fogja felvinni, ha az ALKOTJA táblában módosítunk, és csak akkor...
)
-- így fogjuk létrehozni

go

create table eloadja
(
	szem_egy int,
	dal int,
	primary key (szem_egy, dal),
	foreign key (szem_egy) references szem_egy(kod),
	foreign key (dal) references dal(azon)
)

--PLATFORM (platform)


create table platform
(
	platform char(16),
	primary key (platform)
)

--insert into platform values ('CD'), ('bakelit'), ('streaming')

--select * from platform

--MEGJELENT (dal, dátum, platform, beszerzés) 
	--vagy K=(dal, sorszám)

create table megjelent
(
	dal int,
	datum date,
	platform char(16),
	beszerzes date,
	--primary key lehetne (dal, datum, platform)
	foreign key (dal) references dal(azon),
	foreign key (platform) references platform(platform)
)

go

-- Hunor fgv-e:
create function alkothatta
(
@szerzo int,
@dal int
)
returns bit
begin
	declare @ret bit = 0
	declare @keletkezes date = (select keletkezes from dal where id = @dal)
	if (select kezd_ev from szem_egy where id = @szerzo) <= year(@keletkezes)
		and isnull((select vege_ev from szem_egy where id = @szerzo), year(GETDATE())) >= year(@keletkezes)
			set @ret = 1
return @ret
end

-- ami még beépítendõ:
alter table alkotja
add check (dbo.alkothatta(szemely, dal)=1)