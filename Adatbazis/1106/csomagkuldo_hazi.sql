--H�zi feladat

use csomagkuldoC
--bonthat� 
--1 melyik rend_t�telb�l mennyi nincs m�g kisz�ll�tva?
-- rend sz�m, mennyi
	
Select rt.rend_sz�m,rt.cikksz�m , rt.menny - (Select ISNULL(SUM(ct.menny), 0)
	from csom_t�tel ct
	where ct.rend_sz�m = rt.rend_sz�m AND ct.cikksz�m = rt.cikksz�m) as nincs_kisz�ll�tva
FROM rend_t�tel rt
order by rt.rend_sz�m
--2 l�p�sben
--1. l�p�smelyik rend t�telb�l mennyyi van m�r kisz�ll�tva
--�ll�tm�ny szerint ki a f�t�bla: csom_t�tel
--sz�r�s a csomaghoz tartoz� adatra
--�sszekapcsol�s
--k�rd�szavakra v�laszolva: rend_sz�m cikksz�m
--ezekszerint kell csoportos�tani
--n�zet vagy from-ba kisz�ll�tva
go 
create view kisz�ll�tva
as

Select ct.rend_sz�m, ct.cikksz�m, SUM(ct.menny) as kiment
from csom_t�tel ct
	inner join csomag cs on ct.csomag=cs.csomag
where cs.feladva is not NULL
Group by ct.rend_sz�m, ct.cikksz�m

--2. l�p�s minden ren_t�telre menny kisz�ll�tott megjelen�tve
--f� t�bla rend_t�tel
--sz�r�s -
--k�rd�szavak: rend_sz�m �s cikksz�m
--ez�rt a kisz�ll�tva t�bbl�val k�ls� �sszekapcs kapcsolni

Select rend_sz�m, cikksz�m--, SUM(menny) as rendelve
from rend_t�tel
Group by rend_sz�m, cikksz�m

--Select * 
--from rend_t�tel
--Select * 
--from kisz�ll�tva

go
create view  sz�ll�tani
as
Select rt.rend_sz�m, rt.cikksz�m, rt.menny - ISNULL(kiment, 0) as kisz�ll�tand�
from rend_t�tel rt --left mert ez van a bal oldalon
	left outer join kisz�ll�tva k on k.rend_sz�m=rt.rend_sz�m and k.cikksz�m=rt.cikksz�m
where rt.menny > ISNULL(kiment, 0)
	
	

--2 melyik cikkb�l ki rendelt utolj�ra?
--neve, vev�, kelt
SELECT rt.cikksz�m, MAX(r.kelt) AS Utols�_rendel�s
FROM rend_t�tel rt
 inner join rendel�s r ON rt.rend_sz�m = r.rend_sz�m
 inner join cikk c on c.cikksz�m=rt.cikksz�m
GROUP BY rt.cikksz�m
--melyik cikkb�l ki rendelt utolj�ra
--f� t�bla rend_t�tel
--sz�r�s rendsz�mhoz tart kelt= (select legnagyobb kelt from rend_t�tel ahol k�ls� param�teres a felt�tel)
select * 
from rend_t�tel 
select * 
from rendel�s

create view  ki_mit_rendelt_utolj�ra
as
Select rt.cikksz�m, r.vk�d 
from rend_t�tel rt
	inner join rendel�s r on rt.rend_sz�m=r.rend_sz�m
where  kelt = 
	(Select MAX(rendel�s.kelt) 
	from rend_t�tel brt 
		inner join rendel�s on rendel�s.rend_sz�m=brt.rend_sz�m
		where brt.cikksz�m=rt.cikksz�m
	)

--3 melyik rendel�sen melyik a legdr�g�bb cikk?
--egys�g�r rend_sz�m



--4 melyik vev�nek mikori a leg�rt�kesebb csomagja?
--vev� neve, kelt, csomagsz�m 

--mikori a leg�rt�kesebb csomag
--melyik csomagnak mi az �ssz�rt�ke, ki� �s mikor adt�k fel
--csomag_t�tel ennek mekkora az �ssz �rt�ke
create view csomagok
as
Select ct.csomag, MAX(r.vk�d) as v�s�rl�, MAX(cs.feladva) as rendel�s_d�tuma, SUM(c.egys_�r) as csomag_�rt�ke
from csom_t�tel	ct
	inner join cikk c on ct.cikksz�m=c.cikksz�m
	inner join rendel�s r on r.rend_sz�m=ct.rend_sz�m
	inner join csomag cs  on cs.csomag=ct.csomag		
Group by ct.csomag


Select v�s�rl�, rendel�s_d�tuma
from csomagok K
where csomag_�rt�ke=(Select max(csomag_�rt�ke) from csomagok where csomagok.v�s�rl�=K.v�s�rl�

--5 melyik csomagban mi a legr�gebbi rendel�si t�tel?

---------------------------------------------------------------------
use csomagkuldoB

--1 melyik rend_t�telb�l mennyi nincs m�g kisz�ll�tva?
-- rend sz�m, mennyi
Select rend_sz�m, menny as nincs_sz�ll�tva from rend_t�tel
where csomag is NUll
UNION
Select rend_sz�m, menny from rend_t�tel rt inner join csomag c on rt.csomag=c.csomag
where c.feladva is NUll 


--2 melyik cikkb�l ki rendelt utolj�ra?
--neve, vev�, kelt
Select v.n�v, c.elnev, r.kelt from rend_t�tel rt
	inner join cikk c on rt.cikksz�m=c.cikksz�m
	inner join rendel�s r on rt.rend_sz�m=r.rend_sz�m
	inner join vev� v on v.vk�d=r.vk�d
		where kelt = (Select MAX(br.kelt) from rendel�s br	
						inner join rend_t�tel brt on brt.rend_sz�m=br.rend_sz�m
						inner join cikk bc on bc.cikksz�m=brt.cikksz�m
						where c.cikksz�m=bc.cikksz�m
		)
	Group by v.n�v, c.elnev, r.kelt

--3 melyik rendel�sen melyik a legdr�g�bb cikk?
--egys�g�r rend_sz�m
Select rend_sz�m, c.elnev, c.egys_�r from rend_t�tel rt 
	inner join cikk c on rt.cikksz�m=c.cikksz�m
	--inner join rendel�s r on r.rend_sz�m=rt.rend_sz�m
	where c.egys_�r = (Select MAX(bc.egys_�r) from cikk bc
						inner join rend_t�tel brt on brt.cikksz�m=bc.cikksz�m
						where brt.rend_sz�m=rt.rend_sz�m
						)
	group by rend_sz�m, c.elnev, c.egys_�r


--4 melyik vev�nek mikori a leg�rt�kesebb csomagja?
--vev� neve, kelt, csomagsz�m 
Select * from rend_t�tel rt
	inner join csomag cs on rt.csomag=cs.csomag
	inner join cikk c on c.cikksz�m=rt.cikksz�m
	--where sum()
	--group by



--5 melyik csomagban mi a legr�gebbi rendel�si t�tel?
Select cs.csomag, c.elnev, r.kelt from rend_t�tel rt
	inner join rendel�s r on rt.rend_sz�m=r.rend_sz�m
	inner join csomag cs on rt.csomag=cs.csomag
	inner join cikk c on c.cikksz�m=rt.cikksz�m
	where kelt= 
	(
		Select min(br.kelt) from rendel�s br
		where cs.csomag = (Select * from csomag)
	)
	group by cs.csomag,  r.kelt, c.elnev

SELECT c.csomag, MIN(r.kelt) AS legr�gebbi_rendel�s_d�tuma
FROM csom_t�tel c
	INNER JOIN rend_t�tel rt ON c.rend_sz�m = rt.rend_sz�m AND c.cikksz�m = rt.cikksz�m
	INNER JOIN rendel�s r ON c.rend_sz�m = r.rend_sz�m
GROUP BY c.csomag
ORDER BY legr�gebbi_rendel�s_d�tuma;