--oktatás órarendi hiányok lekérd

--create view orarendiHiany as
create view leütemezve
as
select osztály, tant, count(*) as leutemezett
from órarend
group by osztály, tant

union

select osztály, tant, 0
from tanít T
	where osztály + tant not in(select osztály + tant from órarend)

go
create view hiányA
as
select l.*,heti_óraszám-leutemezett as hiány
from leütemezve l
	inner join tantárgy t on l.tant=l.tant
where heti_óraszám > leutemezett
 


--vagy1 lépésben 
select *
from
	(select osztály, tant, count(*) as leutemezve
	from órarend
	group by osztály, tant
	union
	select osztály, tant, 0
	from tanít T
		where osztály + tant not in(select osztály + tant from órarend)
)le
inner join tantárgy gy on le.tant=gy.tant



go 
create view hiányB as
select le.*, heti_óraszám-leutemezett as hiányA
from
	(select osztály, tant, count(*) as leutemezett
	from órarend
	group by osztály, tant
	union
	select osztály, tant, 0
	from tanít t
		where not exists (select 1 from órarend where osztály=t.osztály and tant=t.tant)
	)le 
	inner join tantárgy gy on le.tant=gy.tant
where heti_óraszám > leutemezett

go 
create view hiányC
as
select le.*, heti_óraszám-leutemezett as hiányA
from
	(select osztály, tant, count(*) as leutemezett
	from órarend
	group by osztály, tant
	union
	(
	select osztály, tant, 0 from tanít
	except
	select osztály, tant, 0 from órarend
	))le 
	inner join tantárgy gy on le.tant=gy.tant
where heti_óraszám > leutemezett

--select osztály, tant from tanít
--exept
--select osztály, tant from órarend


go 
create view hiányD
as
select le.*, heti_óraszám-leutemezett as hiányA
from
	(select osztály, tant, count(*) as leutemezett
	from órarend
	group by osztály, tant
	union
	(
	select t.osztály, t.tant, 0
	from tanít t
	left outer join órarend o on t.osztály=o.osztály and t. tant=o.tant
	where o.osztály is Null
	))le 
	inner join tantárgy gy on le.tant=gy.tant
where heti_óraszám > leutemezett


select t.osztály, t.tant, count(o.osztály) --count(*) hamis lenne
from tanít t
	left outer join órarend o on t.osztály=o.osztály and t. tant=o.tant
group by t.osztály, t.tant --o.osztáy, o.tant tévedés lenne

go
create view hiányok
as
select le.*, heti_óraszám-leutemezett as hiányA
from
	(	
	select t.osztály, t.tant, count(o.osztály) as leutemezett --count(*) hamis lenne
		from tanít t
		left outer join órarend o on t.osztály=o.osztály and t. tant=o.tant
		group by t.osztály, t.tant --o.osztáy, o.tant tévedés lenne
	)le 
	inner join tantárgy gy on le.tant=gy.tant
where heti_óraszám > leutemezett
--több összekapcsolás halmazmûveletek
--paraméteres lekérdezés plusz