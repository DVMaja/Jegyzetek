--oktat�s �rarendi hi�nyok lek�rd

--create view orarendiHiany as
create view le�temezve
as
select oszt�ly, tant, count(*) as leutemezett
from �rarend
group by oszt�ly, tant

union

select oszt�ly, tant, 0
from tan�t T
	where oszt�ly + tant not in(select oszt�ly + tant from �rarend)

go
create view hi�nyA
as
select l.*,heti_�rasz�m-leutemezett as hi�ny
from le�temezve l
	inner join tant�rgy t on l.tant=l.tant
where heti_�rasz�m > leutemezett
 


--vagy1 l�p�sben 
select *
from
	(select oszt�ly, tant, count(*) as leutemezve
	from �rarend
	group by oszt�ly, tant
	union
	select oszt�ly, tant, 0
	from tan�t T
		where oszt�ly + tant not in(select oszt�ly + tant from �rarend)
)le
inner join tant�rgy gy on le.tant=gy.tant



go 
create view hi�nyB as
select le.*, heti_�rasz�m-leutemezett as hi�nyA
from
	(select oszt�ly, tant, count(*) as leutemezett
	from �rarend
	group by oszt�ly, tant
	union
	select oszt�ly, tant, 0
	from tan�t t
		where not exists (select 1 from �rarend where oszt�ly=t.oszt�ly and tant=t.tant)
	)le 
	inner join tant�rgy gy on le.tant=gy.tant
where heti_�rasz�m > leutemezett

go 
create view hi�nyC
as
select le.*, heti_�rasz�m-leutemezett as hi�nyA
from
	(select oszt�ly, tant, count(*) as leutemezett
	from �rarend
	group by oszt�ly, tant
	union
	(
	select oszt�ly, tant, 0 from tan�t
	except
	select oszt�ly, tant, 0 from �rarend
	))le 
	inner join tant�rgy gy on le.tant=gy.tant
where heti_�rasz�m > leutemezett

--select oszt�ly, tant from tan�t
--exept
--select oszt�ly, tant from �rarend


go 
create view hi�nyD
as
select le.*, heti_�rasz�m-leutemezett as hi�nyA
from
	(select oszt�ly, tant, count(*) as leutemezett
	from �rarend
	group by oszt�ly, tant
	union
	(
	select t.oszt�ly, t.tant, 0
	from tan�t t
	left outer join �rarend o on t.oszt�ly=o.oszt�ly and t. tant=o.tant
	where o.oszt�ly is Null
	))le 
	inner join tant�rgy gy on le.tant=gy.tant
where heti_�rasz�m > leutemezett


select t.oszt�ly, t.tant, count(o.oszt�ly) --count(*) hamis lenne
from tan�t t
	left outer join �rarend o on t.oszt�ly=o.oszt�ly and t. tant=o.tant
group by t.oszt�ly, t.tant --o.oszt�y, o.tant t�ved�s lenne

go
create view hi�nyok
as
select le.*, heti_�rasz�m-leutemezett as hi�nyA
from
	(	
	select t.oszt�ly, t.tant, count(o.oszt�ly) as leutemezett --count(*) hamis lenne
		from tan�t t
		left outer join �rarend o on t.oszt�ly=o.oszt�ly and t. tant=o.tant
		group by t.oszt�ly, t.tant --o.oszt�y, o.tant t�ved�s lenne
	)le 
	inner join tant�rgy gy on le.tant=gy.tant
where heti_�rasz�m > leutemezett
--t�bb �sszekapcsol�s halmazm�veletek
--param�teres lek�rdez�s plusz