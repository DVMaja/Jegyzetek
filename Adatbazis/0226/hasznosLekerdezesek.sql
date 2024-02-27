use kerteszwebaruhaz

--1. Adott felhasználó mely termékeket vásárolta meg eddig. (Mikor mit mennyit mennyiért)  


--2. Egy adott termékbõl mely színek voltak a legkelendõek az elmúlt évben? 

--3. Egy adott termékbõl mely kiszerelések voltak a legkelendõbbek az elmúlt évben? 

--4. Adott termék mely hónapban volt a legkelendõbb az elmúlt évben 
Select *
from eladas e
	inner join eladas_tetel et on et.eladas_szam=e.eladas_szam
where year(e.vas_datum)=year(getdate()) and et.termek=1000



--***HASZNOS***
--5. A top 3 legkelendõbb termék az elmúlt hónapban. 
Select TOP 3 with ties et.termek, SUM(et.darabszam)
from eladas_tetel et
	inner join eladas e on e.eladas_szam=et.eladas_szam
where MONTH(e.vas_datum)=MONTH(GETDATE())-1
group by et.termek
order by 2 desc


--6. A legkelendõbb termék a mai nap folyamán. 

--7. A hét legjobban fogyó terméke. 


--***HASZNOS***
--8. Mely termékbõl nem fogyott az elmúlt hónapban.
go
create view multhonapi_eladasok
as
select termek, vas_datum
from eladas_tetel et
	inner join eladas e on e.eladas_szam=et.eladas_szam
where MONTH(e.vas_datum)=MONTH(GETDATE())-1
go

Select t.termek_kod
from termek t
	left outer join multhonapi_eladasok m on t.termek_kod=m.termek 
where m.vas_datum is NULL


--***HASZNOS***
--9. Mely termékekbõl fogyott kevesebb mint az elõzõ hónapban a legutolsó árváltozás óta? 



--10. Adott regisztrált felhasználónak mely növénykategóriák reklámozhatók az eddigi rendelései alapján?

--11. Adott regisztrált felhasználó mely növénykategóriákból nem rendelt még soha? 

--12. Aktuális átlagár kiszámítása a beszerzési ár alapján, termékekre lebontva,
	--tartalmazza a beszerzési árat, a jelenlegi eladási árat 


--***HASZNOS***
--13. A(z) ___ évi kiadások összege hónapra lebontva.
--Ide is hasonló, csak függvénnyel
go
CREATE function melyik_evi_kiadas
(	
	@ev int
)
returns table
as
return
(
	select MONTH(besz_datum) as hónap, SUM(besz_ar * darabszam)
	from beszerzes
	where year(besz_datum)=@ev
	group by MONTH(besz_datum)
)
go

--14. Az idei kiadások összege havi bontásban 
Select MONTH(besz_datum) as hónap, SUM(besz_ar * darabszam)
from  beszerzes 
where year(besz_datum)=year(getdate())
group by MONTH(besz_datum)


--15. Átlagosan hány százalékkal változtak meg a termékárak az elõzõ évhez képest? 


