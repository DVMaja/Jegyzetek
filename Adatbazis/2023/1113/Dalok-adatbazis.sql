--create database Dalok
go
use dalok

--MÛFAJ(m_id, elnevezés)

--create table mufaj
--(
--	id int identity(10,1),
--	elnevezes nvarchar(30) not null,
--	primary key (id),
--	unique (elnevezes)
--)
----DAL (azon, címe, keletkezése, mûfaja, eredetije)
--create table dal 
--(
--	azon int identity(1000,1),
--	cim nvarchar(30) not null,
--	keletkezes date,
--	mufaj int not null,--kötelezõ kitölterni
--	eredeti int,
--	primary key (azon),
--	foreign key (mufaj) references mufaj (id),
--	foreign key (eredeti) references dal (azon)
--)

insert into mufaj
values('pop-rock')

select * from mufaj
Select * from dal

insert into dal
values('Radio GaGa', '19841122', 10, null)

insert into dal
values('Radio GaGa', '20221010', 10, 1000)
----etz nem fogja felvenni nmert az 1001 nem eredeti
--insert into dal
--values('Radio GaGa', '20230512', 10, 1001)

go
create function eredeti
(
@azon int
)
returns bit

begin
	declare @ret bit=0
	--set @ret=0
	if (Select eredeti from dal where azon=@azon) is null
		set @ret = 1
	return @ret
end

--select *, dbo.eredeti(azon) from dal
--lehet neki nevet adni, nem nem minden motor egységes
--nem adunk neki nevet adni
alter table dal
add check (dbo.eredeti(eredeti)=1)

--SZEM_EGY (kód, név, kezd_év, vége_év, jelzés)
--	(a kezdés/alakulás, befejezés/feloszlás évei)

create table szem_egy
(
	kod int identity(100,1)
	,nev nvarchar(30) not null
	,kezd_ev smallint not null
	,vege_ev smallint
	,jelzes char(1) not null

	,primary key(kod)
	,check(jelzes='S' or jelzes='E')-- személy, vagy együttes
	,check(kezd_ev<=vege_ev or vege_ev is null)---vagy a vége üres
)
alter table szem_egy 
add check(jelzes='S' or jelzes='E')

alter table szem_egy 
add check(kezd_ev<=vege_ev or vege_ev is null)


--TAGJA (együttes, személy, dátumtól, dátumig)
--melyik együttes melyik személy mettõl meddig tag az ig nem kötelezõ

create table tagja
(
	egyuttes int
	,szemely int
	,datumtol date
	,datumig date
	,primary key (egyuttes, szemely, datumtol)
	,check(datumtol<=datumig or datumig is null)
	,foreign key (egyuttes) references szem_egy (kod)
	,foreign key (szemely) references szem_egy (kod)
)

insert into szem_egy
values('Queen', 1970, null, 'E')

insert into szem_egy
values('Freddie Mercury', 1969, 1991, 'S')

insert into szem_egy
values('Adam Lambert', 2010,null, 'S')

select * from szem_egy

create function jelzese
(
	@kod int
)
returns char(1)
begin

	return(Select jelzes from szem_egy where kod=@kod)
end

Select *, dbo.jelzese(kod) from szem_egy

alter table tagja 
add check ( dbo.jelzese(egyuttes)='E')

alter table tagja 
add check ( dbo.jelzese(szemely)='S')

--insert into tagja values(101, 100, 19701111, null)

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

insert into szerep
values ('zeneszerzõ', 1)
,('hangszerelõ', 0)

select * from szerep

--ALKOTJA (alk_id, személy, dal, szerep)
--ha akkor --ekvivalens 
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
	return(Select jogdijas from szerep where id=@szerep)
end
--select * from dbo.jogdijas(51)

alter table alkotja
add check(dbo.jelzese(szemely) = 'S')
--a megszorítás feltétele :
--ha jogdíjas a szerep akkor eredeti a dal
--a felt standard logikai mûveletekkel:
-- nem jogdíjas, vagy eredeti

alter table alkotja
---aktuális sorából, és ne lehessen eggyüttes
add check(dbo.jogdijas(szerep) = 0 or dbo.eredeti(dal)=1)

select * from szem_egy
select * from dal
select * from szerep

insert into alkotja
values(101,1000, 50)

--create table valt
----az alkotás tényének megváltozása, naplózva:
--(
--	--id int identity()
--	alkotja int
--	,meddig date
--	,r_szemely int
--	,r_dal int
--	,r_szerep int
--	--prmary key és foreighn key is flesleges
--	--mert trigger fogja felvinni ha az alkotja táblában modosítunk, és csak akkor..	
--)
----így fogjuk létrehozni

--ELÕADJA (ea_id, szem_egy, dal)

create table eloadja 
(
	dal int
	,szem_egy int
	primary key(szem_egy, dal)
	,foreign key (szem_egy) references szem_egy(kod)
	,foreign key (dal) references dal(azon)	
)

--MEGJELENT (mj_dal_id, dal, dátum, platform, beszerzés) 

create table platform
(
	platform char(16)
	,primary key (platform)
)
insert into platform values('CD'), ('DVD'), ('bakelit'), ('steaming'), ('Pirate Bay'), ('laptapír.hu')

create table megjelent 
(
	dal int
	,datum date
	,platform char(16)
	,beszerzes date
	--primary key lehetne a (dal, datum, platform)
	foreign key(dal) references dal (azon),
	foreign key(platform) references platform(platform)
)

--alkotja az kulön külön eg yszemély
--ha a vége nincs kitöltve, akkor a mai napit
--jazz
--minden ember kezdési ée és a vége is essen bele a dal klkezési éve

go
create function alkothatta
(
	--@
	--két bemenõ ki és mit
	--alkotjába megy a megszorítás
)
returns bit

begin
	Select * from alkotja
	where
end