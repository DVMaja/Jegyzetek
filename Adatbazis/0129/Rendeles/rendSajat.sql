create database  rendeles2

use rendel�s2


Select * from  beszerz�s
Select * from anyag
Select * from  term�k
Select * from  szerkezet

Select * from �rv�lt
Select * from Min�s�t�s

Select * from Partner
Select * from Rend_fej
Select * from Rend_t�tel
--Select * from Engedm�ny

Select * from Term�k
Select * from Sz�ll_fej
Select * from Sz�ll_t�tel
Select * from Sz�mla

select dbo.term�k_�ra('20240129', 3)

select dbo.futja(3)
--select dbo.term�k_�ra(2024-01-28, 1)
--select dbo.term�k_�ra(getDate(), 1)
--Minden term�k olcs� e
--Mennyibe ker�l egy adott napon egy adott term�k
--ha megt�rt�nik egy updsate akkor az if azt n�zi ami m�r benn van , �s egy after updatell v�ltoztat

--lek2
select * 
from Sz�ll_t�tel t
	inner join Sz�ll_fej f on  t.szlev�l=f.szlev�l



--melyik term�knek mikor volt az utols� �rv�lt
select k�d, MAX(mikor)
from �rv�lt
group by k�d

select * 
from Rend_fej

--lek3
--ez elj�r�s is lehetett volna
--lek4

--lek5
--. Az idei kiad�sok �sszege havi bont�sban
--selectbe alselectbeb ki lehet iratni az �sszes h�napot
--vagy outer joinnal
go
create view lek5b
as
select MONTH(b.d�tum) as h�nap, SUM(b.be_�r*b.mennyis�g) as �ssz_kiadas
from Beszerz�s b
where year(GETDATE())=year(b.d�tum)
group by MONTH(b.d�tum) 

go
create view lek5c
as
select * , (Select sum(mennyis�g*be_�r) as kiad�s from Beszerz�s b 
where MONTH(b.d�tum)=ho.h� and YEAR(GETDATE())=YEAR(b.d�tum))
from dbo.h�12() ho

--outerjoin a h�nappal D megold�s
--a h�nap 12 f�
select ho.h�, idei.kiad�s 
from dbo.h�12() ho
	left outer join (
		select month(d�tum) as h�nap, sum(mennyis�g*be_�r) as kiad�s
		from beszerz�s
		where year(d�tum)=year(getdate())
		group by month(d�tum)) idei on idei.h�nap=ho.h�

go
create view lek5d
as
--k�ls�leg kapcsoljuk hozz� a beszeerz�s
select ho.h�, sum(mennyis�g*be_�r) as kiad�s
from dbo.h�12() ho
	left outer join Beszerz�s b on MONTH(b.d�tum)=ho.h� and YEAR(GETDATE())=YEAR(b.d�tum)
group by ho.h�

--TOP 3 with ties ha az els� h�rom kell

--lek8

--lek9
--minden rendel�se �regebb �s minden rendel�se teljes�lt
--k�tszer tagadunk
--ne legyen egy �ven bel�li
--�ssel lehet
--egy �ven bel�l rendelt


--lek10 -- hib�s
--jav�tott r�sz
-- count(distinct st.szlev�l) as h�ny_sz�ll
--sz�ll-t�telben


--lek 11
--szlasz�m is not null
--szT 
--nem j�
--a fizetend� nem a f�t�bl�ban van
select partner,sum(fizetend�) as �rbev�tel, SUM(v�g�sszeg) as hamis
	from sz�mla sz, sz�ll_fej sf, sz�ll_t�tel st, rend_fej rf
	where sz.szlasz�m=sf.szlasz�m
	and st.szlev�l=sf.szlev�l
	and rf.rendsz�m=st.rendsz�m
	and sorsz�m=1--biztos�tja hogy ne t�telesen summ�zza csak az els�t
	--and sz.kelt between @t�l and @ig
	group by partner
--maradjon minden t�telb�l egy s�r
--ne menjen hamisan a summba feleslegesen
--12-23ig