use oktatas

-- kinek melyik tárgyból hány % az eddigi hiányzása?
--(feltéve, h szept.1-tõl tart a tanév és minden munkanapon volt tanítás)
--diak, hianyzas, órarend

--kinek mely tantárgyból hány óra hiányzása van
set datefirst 1

--dw day of weak
--select * from orarend
go
create view hianyzasok
as
Select *--diak, o.tant, COUNT(*) as hianyzott_orak
from hianyzas as h
	inner join diak as d on h.diak=d.azon	
		inner join orarend as o 
			on o.evf=d.evf and o.betu=d.betu
			and o.nap= DATEPART(DW, h.mikor) and o.ora=h.ora
group by diak, o.tant


select diak, tant, COUNT(*) as hiany_db
from hianyzas h
	inner join diak d  on d.azon = h.diak
	inner join orarend o 
		on o.evf = d.evf and o.betu = d.betu
		and o.nap = DATEPART(dw, h.mikor) and o.ora=h.ora
group by diak, tant

 
 --kinek mely tantárgyból hány óra hiányzása van, százalékban
 --HÁZI feladat
 --melyik tárgyból hány százalékot hiányzott a amai napig


-- jelenjenek meg a tantárgyi átlagok diákonként!
go
create view atlagok 
as
Select diak, tant, SUM(j.jegytipus*szorzo)*1.0/ SUM(szorzo) as atlag from jegytipus as jt
	inner join jegy as j on jt.tip=j.jegytipus
group by diak, tant



-- melyik kurzusnak (osztály+tant) hány órája nincs még leütemezve az órarendbe?
--tantargy heti óraszám

--select t.evf, t.betu,ta.tant, ta.heti_oraszam-count(o.ora) as meg_hatra
--from tantargy ta
--	left join tanit t on t.tant=ta.tant
--	left join orarend o 
--	on o.evf=t.evf and o.betu=t.betu and o.tant=ta.tant
--group by ta.tant, t.evf
go
create view hianyzo_orak
as
select t.evf, t.betu,t.tant, MAX(heti_oraszam)-count(o.ora) as meg_hatra
from tanit t
	inner join tantargy ta on t.tant=ta.tant
	left outer join orarend o 
	on o.evf=t.evf and o.betu=t.betu and o.tant=t.tant
group by t.evf, t.betu,t.tant
