use DALOK_jo
insert into dal
values()

select * from dal
select * from szem_egy
--insert into eloadja
--values()

-- dalok el�ad�inak szem�ly�re jelenjjen meg
Select * from dal
Select * from szem_egy
insert into eloadja values(103, 1002), (104, 1002), (105, 1002), (106, 1002)
insert into eloadja values(103, 1003), (104, 1003), (105, 1003), (106, 1003)
insert into eloadja values(103, 1004), (104, 1004), (105, 1004), (106, 1004)
insert into eloadja values(103, 1005), (104, 1005), (105, 1005), (106, 1005)

insert into tagja values(100, 104,'19700101', null)

insert into eloadja values (100, 1001), (102, 1001)
update tagja set
datumig='19901020'
where szemely= 101

create view szemelyesen as
Select dal, szemely --az el�ad� eggy�ttes tagjai
from eloadja
	inner join tagja on szem_egy=egyuttes
	inner join dal on dal=azon
where keletkezes between datumtol and isnull(datumig, getdate())
Union--All
Select dal, szem_egy 
from eloadja
	inner join szem_egy on szem_egy=kod
where jelzes='S'

select dal, szemely, count(*) as ennyiszer
from szemelyesen	
Group by dal, szemely
having count(*) >1


--adott dalt szem�lyesen kik adt�k el� a szinpadon

--melyik dal el�ad�i k�z�tt volt ott a dal eredeti zeneszerz�je
--Unionnal 
--melyik dlnak ki az eredeti zeneszerz�lye
go
create view zeneszerzok as
Select dal, szemely as zeneszerzoje 
from dal
	inner join alkotja on azon=dal
	inner join  szerep on id=szerep
where eredeti is NULL and megnevezes like 'zeneszerz%'-- anem tetszik neki az � bet�

Union
Select eredeti, szemely as zeneszerzoje
from alkotja
	inner join dal on azon=dal
	inner join  szerep on id=szerep
where eredeti IS NOT NULL and megnevezes like 'zeneszerz%'

--�rjunk ki minden dalt 
--melyik dalnak mi a c�me �s kelt �r �rjuk oda az eredeti keltez�s�t �s c�,�t
--ha nem eredetu akkor az eredeti c�m�t �
--create view 
Select *  
from dal 
	left outer join dal ori on ori.eredeti=dal.azon

--
Select * from alkotja
Select * from dal
Select * from eloadja
Select * from szem_egy

--melyik dal el�ad�i k�z�tt szerepelt annak a dalnak a zeneszerz�je

create function ottvolt
(
@dal int
)
returns table

begin
	returns
	((
	Select dal, szemely as zeneszerzoje 
	from alkotja
		inner join dal on azon=dal
		inner join  szerep on id=szerep
	where eredeti is NULL and megnevezes like 'zeneszerz%'-- anem tetszik neki az � bet�

	Union
	Select eredeti, szemely as zeneszerzoje
	from alkotja
		inner join dal on azon=dal
		inner join  szerep on id=szerep
	where eredeti IS NOT NULL and megnevezes like 'zeneszerz%'	
	)
	intersect --jobbra balra z�r�jel
	select szemely 
	from eloadja
		inner join
	)
end
select * from dbo.ottvolt(1001)