select * from cikk
select * from vevõ
select * from csomag
select * from rendelés
select * from rend_tétel
--melyik rendelés van teljesítve
--akinek minden tétele be van csomagolva és fel van adva
--rendelésszámok amik vagy ezért vagy azért neincsenek teljesítve
--MELYIK CSOMAGBA MILYEN CiKKEK VANN AK
--melyik rendelés van teljesítve
--minden tétele becsomagolva, és ezek feladva
--a teljesítet/ ki  szállított rendelések (MINDEN tétele becsomagolva és feladva)
--(nincs becsomagolva vagy nincs feladva)
--az összes, tétellel rendelkezõ rendelés közül
go

create view teljesítettA
as
Select * from rendelés
where rend_szám in (select rend_szám from rend_tétel) 
and rend_szám  not in
(
--nincs becsomgolva
Select rend_szám
from rend_tétel
where csomag is null --nincs or feltétel

Union -- minden rendezés csak egyszer fog látszani

--nincs feladva
Select rend_szám 
from rend_tétel rt 
	inner join csomag cs on cs.csomag=rt.csomag
where feladva is NULL
)

go

create view teljesítettB
as
Select * 
from rendelés
where rend_szám in (select rend_szám from rend_tétel) 
and not exists -- ami külsõ paraméteres alselect MINDIG
(
Select rend_szám
from rend_tétel
where csomag is null AND rend_szám=rendelés.rend_szám--nincs or feltétel
Union 
Select 1 --lehet * is , nem látszik sehol-> ennek az eredménytáblája ne tartalmazzon sorokat.
from rend_tétel rt 
	inner join csomag cs on cs.csomag=rt.csomag
where feladva is NULL AND rend_szám=rendelés.rend_szám
)

go

create view teljesítettC
--külsõ halmazból ki akarjuk vonni az A unio B-t ha nincs zárójel akkor rossz a sorrend
as
Select rend_szám
from rendelés
where rend_szám in (select rend_szám from rend_tétel) 
except
(
Select rend_szám
from rend_tétel
where csomag is null 
Union 
Select rend_szám
from rend_tétel rt 
	inner join csomag cs on cs.csomag=rt.csomag
where feladva is NULL 
)

--hány szánkór rendeltek összesen
--addott cikkbõl mennyit rendeltek összesen

--jól mûkösik
go
create function összen1
(
	@cikk varchar(30)
)
returns smallint
as 
begin
return
	(
	Select sum(menny) -- a mennyiség összege egy skalár
	from rend_tétel  rt
		inner join cikk c on rt.cikkszám=c.cikkszám
	where elnev like '%'+@cikk+'%'--'%szánkó%'
	)
end

--declare @cikk varchar(30)='szánkó'
--select @cikk, '%'+@cikk+'%'
 select dbo.összen1('szánkó')

 go

 create function csomagban
  --nem skalár: egy sorade  több oszlopa van, vagy egy oszlopa de sok sora
 --adott csomagban mik vannak, 
 --egy oszlop alatt sok értéket adhat visza, vagy vissza adhattöbb oszlopot
 (
	@csom char(12)
 )
 returns table
 as
 --beginn ide nem kell mert 1 statement-es ez a verzió de ha count(cikkszam)- akko kellene
 return
 (
 select cikkszám, rend_szám
from rend_tétel
where csomag=@csom
)
--tábla miatt
select * from dbo.csomagban('cs01')


-----------------------------
----------------------------Csomag A 
-----------------------------
use csomagkuldoA

select * from cikk
select * from vevõ
select * from csomag
select * from rendelés
select * from rend_tétel

go
 
create function árbev
-- 2 adott dátum közözti árbevétel mekkora
(
	@tol date,
	@ig date
)
returns money
as 
begin
return
(
Select sum(rt.menny*c.egys_ár)
from rend_tétel rt
	inner join rendelés r on rt.rend_szám=r.rend_szám
	inner join cikk c on rt.cikkszám=c.cikkszám
where kelt between @tol and @ig
)

end
--select dbo.árbev('20080420', '20080515')

--Melyik rendelést hány nap alatt teljesítettük, ha még nem vittük ki, akkor mióta vár
-- ha még nem vitték ki akkor hány nap órta várnak rá

--teljesítettek
go
create view csomagVaras
as
select rend_szám, DATEDIFF(DAY, kelt, feladva) as nap, 'alatt telj-ve' as megj --feladva-kelt as eltelt_napok
from rendelés r
	inner join csomag cs on r.csomag=cs.csomag
where feladva is not Null

UNION

select rend_szám, DATEDIFF(DAY, kelt, GETDATE()), 'ja várják'
from rendelés r
	inner join csomag cs on r.csomag=cs.csomag
where feladva is Null

UNION

select rend_szám, DATEDIFF(DAY, kelt, GETDATE()), 'ja várják'
from rendelés 	
where csomag is Null

--mennyi a végösszege amennyit fizetni kell
go

create function végösszeg
(
	@rsz char(12)
)
returns money
as
begin 
Return
(
 select sum(menny*egys_ár)
 from rend_tétel rt
	inner join cikk c on rt.cikkszám=c.cikkszám
where rend_szám=@rsz
)
end
