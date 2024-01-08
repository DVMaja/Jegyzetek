use oktatas

-- kinek melyik t�rgyb�l h�ny % az eddigi hi�nyz�sa?
--(felt�ve, h szept.1-t�l tart a tan�v �s minden munkanapon volt tan�t�s)
--diak, hianyzas, �rarend

--kinek mely tant�rgyb�l h�ny �ra hi�nyz�sa van
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

 
 --kinek mely tant�rgyb�l h�ny �ra hi�nyz�sa van, sz�zal�kban
 --H�ZI feladat
 --melyik t�rgyb�l h�ny sz�zal�kot hi�nyzott a amai napig


-- jelenjenek meg a tant�rgyi �tlagok di�konk�nt!
go
create view atlagok 
as
Select diak, tant, SUM(j.jegytipus*szorzo)*1.0/ SUM(szorzo) as atlag from jegytipus as jt
	inner join jegy as j on jt.tip=j.jegytipus
group by diak, tant



-- melyik kurzusnak (oszt�ly+tant) h�ny �r�ja nincs m�g le�temezve az �rarendbe?
--tantargy heti �rasz�m

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
