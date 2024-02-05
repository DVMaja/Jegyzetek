create database  rendeles2

use rendelés2


Select * from  beszerzés
Select * from anyag
Select * from  termék
Select * from  szerkezet

Select * from Árvált
Select * from Minõsítés

Select * from Partner
Select * from Rend_fej
Select * from Rend_tétel
--Select * from Engedmény

Select * from Termék
Select * from Száll_fej
Select * from Száll_tétel
Select * from Számla

select dbo.termék_ára('20240129', 3)

select dbo.futja(3)
--select dbo.termék_ára(2024-01-28, 1)
--select dbo.termék_ára(getDate(), 1)
--Minden termék olcsó e
--Mennyibe kerül egy adott napon egy adott termék
--ha megtörténik egy updsate akkor az if azt nézi ami már benn van , és egy after updatell változtat

--lek2
select * 
from Száll_tétel t
	inner join Száll_fej f on  t.szlevél=f.szlevél



--melyik terméknek mikor volt az utolsó árvált
select kód, MAX(mikor)
from Árvált
group by kód

select * 
from Rend_fej

--lek3
--ez eljárás is lehetett volna
--lek4

--lek5
--. Az idei kiadások összege havi bontásban
--selectbe alselectbeb ki lehet iratni az összes hónapot
--vagy outer joinnal
go
create view lek5b
as
select MONTH(b.dátum) as hónap, SUM(b.be_ár*b.mennyiség) as össz_kiadas
from Beszerzés b
where year(GETDATE())=year(b.dátum)
group by MONTH(b.dátum) 

go
create view lek5c
as
select * , (Select sum(mennyiség*be_ár) as kiadás from Beszerzés b 
where MONTH(b.dátum)=ho.hó and YEAR(GETDATE())=YEAR(b.dátum))
from dbo.hó12() ho

--outerjoin a hónappal D megoldás
--a hónap 12 fõ
select ho.hó, idei.kiadás 
from dbo.hó12() ho
	left outer join (
		select month(dátum) as hónap, sum(mennyiség*be_ár) as kiadás
		from beszerzés
		where year(dátum)=year(getdate())
		group by month(dátum)) idei on idei.hónap=ho.hó

go
create view lek5d
as
--külsöleg kapcsoljuk hozzá a beszeerzés
select ho.hó, sum(mennyiség*be_ár) as kiadás
from dbo.hó12() ho
	left outer join Beszerzés b on MONTH(b.dátum)=ho.hó and YEAR(GETDATE())=YEAR(b.dátum)
group by ho.hó

--TOP 3 with ties ha az elsõ három kell

--lek8

--lek9
--minden rendelése öregebb és minden rendelése teljesûlt
--kétszer tagadunk
--ne legyen egy éven belüli
--éssel lehet
--egy éven belül rendelt


--lek10 -- hibás
--javított rész
-- count(distinct st.szlevél) as hány_száll
--száll-tételben


--lek 11
--szlaszám is not null
--szT 
--nem jó
--a fizetendõ nem a fõtáblában van
select partner,sum(fizetendõ) as árbevétel, SUM(végösszeg) as hamis
	from számla sz, száll_fej sf, száll_tétel st, rend_fej rf
	where sz.szlaszám=sf.szlaszám
	and st.szlevél=sf.szlevél
	and rf.rendszám=st.rendszám
	and sorszám=1--biztosítja hogy ne tételesen summázza csak az elsõt
	--and sz.kelt between @tól and @ig
	group by partner
--maradjon minden tételbõl egy sór
--ne menjen hamisan a summba feleslegesen
--12-23ig