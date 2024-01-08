select * from termék
select * from ár0

go

drop view árlista0
go 
create view árlista0
as
select termék, dtól as tól, isnull(dig, getdate()) as ig, ár from ár0

go
select * from árlista0
-- pl. ebben már tud keresni:
select ár
from árlista0
where termék=101 and tól<='20221205' and ig>='20221205'

-- tárolásra alkalmas verzió:

select * from ár
drop view árlista1
go
create view árlista1 
as
select termék
	, dtól
	, isnull((select dateadd(day,-1, min(dtól)) from ár where termék=K.termék and dtól>k.dtól),getdate()) as dig
	, új_ár 
from ár K
--
select * from árlista1


select * from termék
select * from vált

go

create view [dbo].[árlista2]
as
-- a VÁLTból egy teljes árlista

select	termék, 
		(select isnull(dateadd(day, +1,MAX(dig)), '20200102') from vált where termék=K.termék and dig<K.dig ) as dtól,	
		dig,
		régi_ár as ár
from VÁLT K
UNION
select tkód, '20200102', cast(getdate() as date), akt_ár
from termék
where tkód NOT IN (select termék from vált)
UNION
select tkód, (select dateadd(day,+1,max(dig)) from vált where termék=tkód), cast(getdate() as date), akt_ár
from termék
where  tkód IN (select termék from vált)


go

select * from árlista2
go


create view változások
as
select termék, count(*) as ennyiszer --kell oszlopnevet adni minden kif-nek
from ár
group by termék

go


select * from változások -- egyedi nevû

-------------
use oktatás
--- oktatás ab. szkriptje futtatva
create table terem
(
	tszám int,
	hány_fõs tinyint,
	primary key (tszám)
)

alter table órarend
add terem tinyint
-- nem jó a típusa:

alter table órarend
alter column terem int

alter table órarend
add foreign key (terem) references Terem (tszám)

-- az osztály se ütközzön adott nap adott órájában (PK)
-- a terem+nap+óra legyen UK -- vajon lehet_e a terem null?
-- a tanár se ütközzön! ld. tavalyi lekérdezés az ellenõrzéshez
