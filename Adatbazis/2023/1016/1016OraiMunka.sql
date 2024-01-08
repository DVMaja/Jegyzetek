select * from cikk
select * from vev�
select * from csomag
select * from rendel�s
select * from rend_t�tel
--melyik rendel�s van teljes�tve
--akinek minden t�tele be van csomagolva �s fel van adva
--rendel�ssz�mok amik vagy ez�rt vagy az�rt neincsenek teljes�tve
--MELYIK CSOMAGBA MILYEN CiKKEK VANN AK
--melyik rendel�s van teljes�tve
--minden t�tele becsomagolva, �s ezek feladva
--a teljes�tet/ ki  sz�ll�tott rendel�sek (MINDEN t�tele becsomagolva �s feladva)
--(nincs becsomagolva vagy nincs feladva)
--az �sszes, t�tellel rendelkez� rendel�s k�z�l
go

create view teljes�tettA
as
Select * from rendel�s
where rend_sz�m in (select rend_sz�m from rend_t�tel) 
and rend_sz�m  not in
(
--nincs becsomgolva
Select rend_sz�m
from rend_t�tel
where csomag is null --nincs or felt�tel

Union -- minden rendez�s csak egyszer fog l�tszani

--nincs feladva
Select rend_sz�m 
from rend_t�tel rt 
	inner join csomag cs on cs.csomag=rt.csomag
where feladva is NULL
)

go

create view teljes�tettB
as
Select * 
from rendel�s
where rend_sz�m in (select rend_sz�m from rend_t�tel) 
and not exists -- ami k�ls� param�teres alselect MINDIG
(
Select rend_sz�m
from rend_t�tel
where csomag is null AND rend_sz�m=rendel�s.rend_sz�m--nincs or felt�tel
Union 
Select 1 --lehet * is , nem l�tszik sehol-> ennek az eredm�nyt�bl�ja ne tartalmazzon sorokat.
from rend_t�tel rt 
	inner join csomag cs on cs.csomag=rt.csomag
where feladva is NULL AND rend_sz�m=rendel�s.rend_sz�m
)

go

create view teljes�tettC
--k�ls� halmazb�l ki akarjuk vonni az A unio B-t ha nincs z�r�jel akkor rossz a sorrend
as
Select rend_sz�m
from rendel�s
where rend_sz�m in (select rend_sz�m from rend_t�tel) 
except
(
Select rend_sz�m
from rend_t�tel
where csomag is null 
Union 
Select rend_sz�m
from rend_t�tel rt 
	inner join csomag cs on cs.csomag=rt.csomag
where feladva is NULL 
)

--h�ny sz�nk�r rendeltek �sszesen
--addott cikkb�l mennyit rendeltek �sszesen

--j�l m�k�sik
go
create function �sszen1
(
	@cikk varchar(30)
)
returns smallint
as 
begin
return
	(
	Select sum(menny) -- a mennyis�g �sszege egy skal�r
	from rend_t�tel  rt
		inner join cikk c on rt.cikksz�m=c.cikksz�m
	where elnev like '%'+@cikk+'%'--'%sz�nk�%'
	)
end

--declare @cikk varchar(30)='sz�nk�'
--select @cikk, '%'+@cikk+'%'
 select dbo.�sszen1('sz�nk�')

 go

 create function csomagban
  --nem skal�r: egy sorade  t�bb oszlopa van, vagy egy oszlopa de sok sora
 --adott csomagban mik vannak, 
 --egy oszlop alatt sok �rt�ket adhat visza, vagy vissza adhatt�bb oszlopot
 (
	@csom char(12)
 )
 returns table
 as
 --beginn ide nem kell mert 1 statement-es ez a verzi� de ha count(cikkszam)- akko kellene
 return
 (
 select cikksz�m, rend_sz�m
from rend_t�tel
where csomag=@csom
)
--t�bla miatt
select * from dbo.csomagban('cs01')


-----------------------------
----------------------------Csomag A 
-----------------------------
use csomagkuldoA

select * from cikk
select * from vev�
select * from csomag
select * from rendel�s
select * from rend_t�tel

go
 
create function �rbev
-- 2 adott d�tum k�z�zti �rbev�tel mekkora
(
	@tol date,
	@ig date
)
returns money
as 
begin
return
(
Select sum(rt.menny*c.egys_�r)
from rend_t�tel rt
	inner join rendel�s r on rt.rend_sz�m=r.rend_sz�m
	inner join cikk c on rt.cikksz�m=c.cikksz�m
where kelt between @tol and @ig
)

end
--select dbo.�rbev('20080420', '20080515')

--Melyik rendel�st h�ny nap alatt teljes�tett�k, ha m�g nem vitt�k ki, akkor mi�ta v�r
-- ha m�g nem vitt�k ki akkor h�ny nap �rta v�rnak r�

--teljes�tettek
go
create view csomagVaras
as
select rend_sz�m, DATEDIFF(DAY, kelt, feladva) as nap, 'alatt telj-ve' as megj --feladva-kelt as eltelt_napok
from rendel�s r
	inner join csomag cs on r.csomag=cs.csomag
where feladva is not Null

UNION

select rend_sz�m, DATEDIFF(DAY, kelt, GETDATE()), 'ja v�rj�k'
from rendel�s r
	inner join csomag cs on r.csomag=cs.csomag
where feladva is Null

UNION

select rend_sz�m, DATEDIFF(DAY, kelt, GETDATE()), 'ja v�rj�k'
from rendel�s 	
where csomag is Null

--mennyi a v�g�sszege amennyit fizetni kell
go

create function v�g�sszeg
(
	@rsz char(12)
)
returns money
as
begin 
Return
(
 select sum(menny*egys_�r)
 from rend_t�tel rt
	inner join cikk c on rt.cikksz�m=c.cikksz�m
where rend_sz�m=@rsz
)
end
