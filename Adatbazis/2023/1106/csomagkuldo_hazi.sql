--Házi feladat

use csomagkuldoC
--bontható 
--1 melyik rend_tételbõl mennyi nincs még kiszállítva?
-- rend szám, mennyi
	
Select rt.rend_szám,rt.cikkszám , rt.menny - (Select ISNULL(SUM(ct.menny), 0)
	from csom_tétel ct
	where ct.rend_szám = rt.rend_szám AND ct.cikkszám = rt.cikkszám) as nincs_kiszállítva
FROM rend_tétel rt
order by rt.rend_szám
--2 lépésben
--1. lépésmelyik rend tételbõl mennyyi van már kiszállítva
--állítmány szerint ki a fõtábla: csom_tétel
--szûrés a csomaghoz tartozó adatra
--összekapcsolás
--kérdõszavakra válaszolva: rend_szám cikkszám
--ezekszerint kell csoportosítani
--nézet vagy from-ba kiszállítva
go 
create view kiszállítva
as

Select ct.rend_szám, ct.cikkszám, SUM(ct.menny) as kiment
from csom_tétel ct
	inner join csomag cs on ct.csomag=cs.csomag
where cs.feladva is not NULL
Group by ct.rend_szám, ct.cikkszám

--2. lépés minden ren_tételre menny kiszállított megjelenítve
--fõ tábla rend_tétel
--szûrés -
--kérdõszavak: rend_szám és cikkszám
--ezért a kiszállítva tábblával külsõ összekapcs kapcsolni

Select rend_szám, cikkszám--, SUM(menny) as rendelve
from rend_tétel
Group by rend_szám, cikkszám

--Select * 
--from rend_tétel
--Select * 
--from kiszállítva

go
create view  szállítani
as
Select rt.rend_szám, rt.cikkszám, rt.menny - ISNULL(kiment, 0) as kiszállítandó
from rend_tétel rt --left mert ez van a bal oldalon
	left outer join kiszállítva k on k.rend_szám=rt.rend_szám and k.cikkszám=rt.cikkszám
where rt.menny > ISNULL(kiment, 0)
	
	

--2 melyik cikkbõl ki rendelt utoljára?
--neve, vevõ, kelt
SELECT rt.cikkszám, MAX(r.kelt) AS Utolsó_rendelés
FROM rend_tétel rt
 inner join rendelés r ON rt.rend_szám = r.rend_szám
 inner join cikk c on c.cikkszám=rt.cikkszám
GROUP BY rt.cikkszám
--melyik cikkbõl ki rendelt utoljára
--fõ tábla rend_tétel
--szûrés rendszámhoz tart kelt= (select legnagyobb kelt from rend_tétel ahol külsõ paraméteres a feltétel)
select * 
from rend_tétel 
select * 
from rendelés

create view  ki_mit_rendelt_utoljára
as
Select rt.cikkszám, r.vkód 
from rend_tétel rt
	inner join rendelés r on rt.rend_szám=r.rend_szám
where  kelt = 
	(Select MAX(rendelés.kelt) 
	from rend_tétel brt 
		inner join rendelés on rendelés.rend_szám=brt.rend_szám
		where brt.cikkszám=rt.cikkszám
	)

--3 melyik rendelésen melyik a legdrágább cikk?
--egységár rend_szám



--4 melyik vevõnek mikori a legértékesebb csomagja?
--vevõ neve, kelt, csomagszám 

--mikori a legértékesebb csomag
--melyik csomagnak mi az összértéke, kié és mikor adták fel
--csomag_tétel ennek mekkora az össz értéke
create view csomagok
as
Select ct.csomag, MAX(r.vkód) as vásárló, MAX(cs.feladva) as rendelés_dátuma, SUM(c.egys_ár) as csomag_értéke
from csom_tétel	ct
	inner join cikk c on ct.cikkszám=c.cikkszám
	inner join rendelés r on r.rend_szám=ct.rend_szám
	inner join csomag cs  on cs.csomag=ct.csomag		
Group by ct.csomag


Select vásárló, rendelés_dátuma
from csomagok K
where csomag_értéke=(Select max(csomag_értéke) from csomagok where csomagok.vásárló=K.vásárló

--5 melyik csomagban mi a legrégebbi rendelési tétel?

---------------------------------------------------------------------
use csomagkuldoB

--1 melyik rend_tételbõl mennyi nincs még kiszállítva?
-- rend szám, mennyi
Select rend_szám, menny as nincs_szállítva from rend_tétel
where csomag is NUll
UNION
Select rend_szám, menny from rend_tétel rt inner join csomag c on rt.csomag=c.csomag
where c.feladva is NUll 


--2 melyik cikkbõl ki rendelt utoljára?
--neve, vevõ, kelt
Select v.név, c.elnev, r.kelt from rend_tétel rt
	inner join cikk c on rt.cikkszám=c.cikkszám
	inner join rendelés r on rt.rend_szám=r.rend_szám
	inner join vevõ v on v.vkód=r.vkód
		where kelt = (Select MAX(br.kelt) from rendelés br	
						inner join rend_tétel brt on brt.rend_szám=br.rend_szám
						inner join cikk bc on bc.cikkszám=brt.cikkszám
						where c.cikkszám=bc.cikkszám
		)
	Group by v.név, c.elnev, r.kelt

--3 melyik rendelésen melyik a legdrágább cikk?
--egységár rend_szám
Select rend_szám, c.elnev, c.egys_ár from rend_tétel rt 
	inner join cikk c on rt.cikkszám=c.cikkszám
	--inner join rendelés r on r.rend_szám=rt.rend_szám
	where c.egys_ár = (Select MAX(bc.egys_ár) from cikk bc
						inner join rend_tétel brt on brt.cikkszám=bc.cikkszám
						where brt.rend_szám=rt.rend_szám
						)
	group by rend_szám, c.elnev, c.egys_ár


--4 melyik vevõnek mikori a legértékesebb csomagja?
--vevõ neve, kelt, csomagszám 
Select * from rend_tétel rt
	inner join csomag cs on rt.csomag=cs.csomag
	inner join cikk c on c.cikkszám=rt.cikkszám
	--where sum()
	--group by



--5 melyik csomagban mi a legrégebbi rendelési tétel?
Select cs.csomag, c.elnev, r.kelt from rend_tétel rt
	inner join rendelés r on rt.rend_szám=r.rend_szám
	inner join csomag cs on rt.csomag=cs.csomag
	inner join cikk c on c.cikkszám=rt.cikkszám
	where kelt= 
	(
		Select min(br.kelt) from rendelés br
		where cs.csomag = (Select * from csomag)
	)
	group by cs.csomag,  r.kelt, c.elnev

SELECT c.csomag, MIN(r.kelt) AS legrégebbi_rendelés_dátuma
FROM csom_tétel c
	INNER JOIN rend_tétel rt ON c.rend_szám = rt.rend_szám AND c.cikkszám = rt.cikkszám
	INNER JOIN rendelés r ON c.rend_szám = r.rend_szám
GROUP BY c.csomag
ORDER BY legrégebbi_rendelés_dátuma;