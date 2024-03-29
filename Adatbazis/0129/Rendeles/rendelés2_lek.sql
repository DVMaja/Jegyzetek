USE [rendelés2]
GO
/****** Object:  UserDefinedFunction [dbo].[futja]    Script Date: 2019. 08. 24. 2:00:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Maximum mennyi gyártható le a pillanatnyi anyag-készletek mellett egy adott termékből
-- adott termékhez szükséges anyagok akt. készletei mennyi termék legyártásához elegendők

CREATE FUNCTION [dbo].[futja] 
(
		@kód int
)
RETURNS int
AS
BEGIN
	DECLARE @elég int
	SELECT @elég=min(cast(készlet/menny as int)) from szerkezet sz, anyag a 
				where sz.azonosító=a.azonosító and kód=@kód
		
	RETURN @elég

END
-- select dbo.futja(2)
GO
/****** Object:  UserDefinedFunction [dbo].[hó12]    Script Date: 2019. 08. 24. 2:00:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[hó12]
(
	-- nincs bemenő param
)
RETURNS 
@hónapok  TABLE 
(
	hó tinyint
)
AS
BEGIN
	declare @v tinyint
	while (select count(*) from @hónapok) < 12
	begin
		select @v=count(*) from @hónapok
		insert into @hónapok values (@v+1)
	end
	
	RETURN 
END

--select * from dbo.hó12()
GO
/****** Object:  UserDefinedFunction [dbo].[korlát]    Script Date: 2019. 08. 24. 2:00:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- adott rend_tételből mennyit kell még összesen kiszállítani

create FUNCTION [dbo].[korlát]
(
	@rendszám char(20),
	@kód int
)
RETURNS int
AS
BEGIN
	
	DECLARE 
	@korlát int
	
	SELECT @korlát=r_menny-teljesítve 
	from rend_tétel
	where rendszám=@rendszám and kód=@kód
	RETURN @korlát

END
GO
/****** Object:  UserDefinedFunction [dbo].[ktsg]    Script Date: 2019. 08. 24. 2:00:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- adott termék pillanatnyi önköltsége
create FUNCTION [dbo].[ktsg]
(
		@tkód int
)
RETURNS money
AS
BEGIN
	DECLARE @ktsg money
	select @ktsg=sum(menny*átl_ár)from szerkezet sz, anyag a
	where sz.azonosító=a.azonosító and sz.kód=@tkód
	RETURN @ktsg

END
GO
-- select *, dbo.ktsg(kód) as önktsg from termék

/****** Object:  UserDefinedFunction [dbo].[prooba]    Script Date: 2019. 08. 24. 2:00:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[prooba]
(
	--
)
RETURNS 
@honapok TABLE 
(
	hó tinyint
)
AS
BEGIN
declare @v tinyint
while (select count(*) from @honapok)<12
begin
select @v=count(*) from @honapok
insert into @honapok values (@v+1)
end
		
-- select * from #hónapok
--
--drop table #hónapok
		
	RETURN 
END
GO
/****** Object:  UserDefinedFunction [dbo].[rend_engedménye]    Script Date: 2019. 08. 24. 2:00:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[rend_engedménye] 
-- Adott rendeléshez a most érvényes engedmény százalékának kiszámítása
(
	@rsz char(20)
)
RETURNS tinyint
AS
BEGIN
	DECLARE @eng tinyint
	declare @össz money
	
	SELECT @össz=sum(r_menny*akt_ár) from rend_tétel rt, termék t
	where rt.kód=t.kód and rendszám=@rsz
	
	select @eng=százalék from engedmény
	where határ=(select max(határ) from engedmény where határ<=@össz)

	RETURN @eng

END

--select dbo.rend_engedménye('r111')

--select rendszám, dbo.rend_engedménye(rendszám)as eng_százalék
--from rend_fej

GO
/****** Object:  UserDefinedFunction [dbo].[termék_ára]    Script Date: 2019. 08. 24. 2:00:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- adott napon az adott termék árát adja vissza

create FUNCTION [dbo].[termék_ára] 
(	
	@akkor datetime, @tkód int
)
RETURNS money
AS
BEGIN
	
	DECLARE @ár money

	SELECT @ár=régi_ár from árvált
	where mikor=(select min(mikor) from árvált where mikor>@akkor and kód=@tkód)and kód=@tkód

	if @ár is null
		select @ár=akt_ár from termék where kód=@tkód
	
	RETURN @ár

END
select dbo.termék_ára(2024-01-28, 1)
select dbo.termék_ára(getDate(), 1)

GO
/****** Object:  UserDefinedFunction [dbo].[segéd]    Script Date: 2019. 08. 24. 2:00:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- adott termék hányféle anyagból áll
CREATE FUNCTION [dbo].[segéd] 
(	
)
RETURNS TABLE 
AS
RETURN 
(
	SELECT kód, COUNT(*) AS darab FROM szerkezet GROUP BY kód
)
GO
/****** Object:  UserDefinedFunction [dbo].[ugyanannyi]    Script Date: 2019. 08. 24. 2:00:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- termék-párok, amik azonos számú anyagból állnak
CREATE FUNCTION [dbo].[ugyanannyi] 
(	
)
RETURNS TABLE 
AS
RETURN 
(
	SELECT egyik.kód as egyik, másik.kód as másik
	FROM dbo.segéd() egyik, dbo.segéd() másik
	WHERE egyik.darab=másik.darab AND egyik.kód<másik.kód

)
GO
/****** Object:  UserDefinedFunction [dbo].[utolsó_árvált]    Script Date: 2019. 08. 24. 2:00:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- az egyes termékeknek mikor volt az utolsó árváltozása 
-- (nem haszn.)
CREATE FUNCTION [dbo].[utolsó_árvált] 
(	
)
RETURNS TABLE 
AS
RETURN 
(

	SELECT kód, MAX(mikor) AS utolsó
	FROM árvált
	GROUP by kód
)
GO
/****** Object:  View [dbo].[lek2]    Script Date: 2019. 08. 24. 2:00:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[lek2]
-- Hányat szállítottak ki az egyes termékekbõl a legutolsó árváltozás óta az árváltozás elõtti és utáni rendelésekre?
as
SELECT u. kód
	, case when r.kelt<utolsó then 'elõtti' else 'utáni' end as változás
	, SUM(sz_menny) AS összesen	 
FROM dbo.utolsó_árvált() u, száll_tétel szt, száll_fej sz, rend_fej r
WHERE u.kód=szt.kód AND szt.szlevél=sz.szlevél 
AND szt.rendszám=r.rendszám AND sz.kelt>=utolsó
GROUP BY u.kód, case when r.kelt<utolsó then 'elõtti' else 'utáni' end;
-- select * from lek2
--select  * from dbo.utolsó_árvált() u, száll_tétel szt, száll_fej sz, rend_fej r

GO
/****** Object:  View [dbo].[lek3]    Script Date: 2019. 08. 24. 2:00:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE view [dbo].[lek3]
-- Mely termék-párok épülnek fel ugyanolyan anyagokból?
as
SELECT egyik, másik
FROM dbo.ugyanannyi()
WHERE NOT EXISTS 
(SELECT * FROM dbo.szerkezet as f
WHERE kód=egyik AND NOT EXISTS 
(SELECT * FROM dbo.szerkezet as a
WHERE kód=másik AND a.azonosító=f.azonosító))
--ORDER BY 1,2;

--select * from lek3 order by 1,2
GO
/****** Object:  UserDefinedFunction [dbo].[utolsó]    Script Date: 2019. 08. 24. 2:00:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[utolsó]
()
returns table
as
return
(
select kód, max(kelt) as utolsó --into #utolsó
from rend_fej f inner join  rend_tétel t on f.rendszám=t.rendszám
group by kód
)
GO
/****** Object:  View [dbo].[lek15]    Script Date: 2019. 08. 24. 2:00:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[lek15]
-- Mely termék(ek)bõl rendeltek legrégebben utoljára 
-- (jelezve, ha volt azóta árváltozás)?
as 
select *, 
	(case when utolsó<(select max(mikor) from árvált where kód=ut.kód) then 'igen' else 'nem' end)as volt_e_árvált
from dbo.utolsó() ut
where utolsó=(select min(utolsó) from dbo.utolsó() )

-- select * from lek15
GO
/****** Object:  View [dbo].[volt_száll]    Script Date: 2019. 08. 24. 2:00:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE view [dbo].[volt_száll]
as
--select rendszám, max(szlevél) as utolsó_szlevél 
--from száll_tétel
--group by rendszám
-- de nem mindig lesz a későbbi nagyobb...

select distinct rendszám, szt.szlevél as utolsó_szlevél 
from száll_tétel szt inner join száll_fej szf on szt.szlevél=szf.szlevél
where kelt=(select max(kelt) from száll_fej f inner join száll_tétel t on f.szlevél=t.szlevél where rendszám=szt.rendszám)

GO
/****** Object:  View [dbo].[lesz_száll]    Script Date: 2019. 08. 24. 2:00:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[lesz_száll]
as
select rendszám 
from rend_tétel 
where r_menny>teljesítve
GO
/****** Object:  View [dbo].[lek16]    Script Date: 2019. 08. 24. 2:00:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[lek16]
-- Összes rendelés-szám utolsó szállítólevele (jelezve, ha még lesz)
as

select rf.rendszám, v.utolsó_szlevél, case when rf.rendszám in (select rendszám from lesz_száll) then 'folyt.' else 'kész' end as kiszállítás
from rend_fej rf left outer join volt_száll v on v.rendszám=rf.rendszám

-- select * from lek16


GO
/****** Object:  UserDefinedFunction [dbo].[tör_rend]    Script Date: 2019. 08. 24. 2:00:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[tör_rend]
-- A kitörölhetõ megrendelések listája, azaz: semmi kiszállítás, és legalább 30 napja volt a hat.idõ
()
returns table
as
return
(
select rendszám, kelt, engedmény 
from rend_fej
where rendszám not in (select rendszám from rend_tétel where teljesítve>0)
		and datediff(day,hat_idő,getdate())>30 
)
GO
/****** Object:  UserDefinedFunction [dbo].[elmaradt_árbev]    Script Date: 2019. 08. 24. 2:00:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[elmaradt_árbev]
-- A kitörölhetõ megrendelések listája az elmaradt árbevétellel
()
returns table
as
return
(
select tr.rendszám, 
		sum(r_menny*dbo.termék_ára(kelt, kód)*(100-engedmény)/100) as elmaradt_összeg
from dbo.tör_rend() tr, rend_tétel rt
where tr.rendszám=rt.rendszám
group by tr.rendszám

)
--select * from dbo.elmaradt_árbev()
GO
/****** Object:  UserDefinedFunction [dbo].[lek11]    Script Date: 2019. 08. 24. 2:00:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[lek11]
-- Adott dátumok közé esõ, partnerenként bontott tényleges árbevételek
(
	@tól datetime, @ig datetime
)
returns table
as 
--begin
return
	(
	select partner,sum(fizetendő) as árbevétel
	from számla sz, száll_fej sf, száll_tétel st, rend_fej rf
	where sz.szlaszám=sf.szlaszám
	and st.szlevél=sf.szlevél
	and rf.rendszám=st.rendszám
	and sorszám=1
	and sz.kelt between @tól and @ig
	group by partner
	)
--end

-- select * from dbo.lek11(cast('2019-01-01' as datetime), getdate())
GO
/****** Object:  UserDefinedFunction [dbo].[lek19]    Script Date: 2019. 08. 24. 2:00:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE function [dbo].[lek19]
-- Azon termékek aktuális árának listája, amelyekbe egy adott anyag beépül 
-- (jelezve, ha az anyagköltség magasabb az árnál)
(
@azon int
)
returns table
as
return
(
select termék.*, dbo.ktsg(termék.kód)as önktsge, 
		case when akt_ár<dbo.ktsg(termék.kód) then 'ráfizetéses' end as megj
from termék, szerkezet
where termék.kód=szerkezet.kód and azonosító=@azon
)

--select * from dbo.lek19(222)
GO
/****** Object:  UserDefinedFunction [dbo].[lek22]    Script Date: 2019. 08. 24. 2:00:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[lek22]
(
@szla char(20)
)
-- adott számla tételeinek részletezése
returns table
as
return
(

select st.szlevél,sf.kelt as száll_kelt, sf.összeg, sf.fizetendő, st.sorszám, st.rendszám, st.kód, st.sz_menny, rt.r_menny, rt.teljesítve, rf.partner, rf.kelt as rend_kelt, rf.hat_idő, rf.engedmény
from száll_fej sf, száll_tétel st, rend_tétel rt, rend_fej rf
where sf.szlevél=st.szlevél and rt.rendszám=st.rendszám and rt.kód=st.kód and rf.rendszám=rt.rendszám 
	and szlaszám=@szla
--order by st.szlevél, sorszám

)
--select * from dbo.lek22('szla55')
--order by szlevél, sorszám
GO
/****** Object:  UserDefinedFunction [dbo].[lek23]    Script Date: 2019. 08. 24. 2:00:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE function [dbo].[lek23]
-- Adott partner számára számlázható tételek listája
(
@pkód int
)
returns table
as
return
(
select st.szlevél, sf.kelt as sz_kelt, sf.összeg, sf.fizetendő, st.sorszám, st.rendszám, st.kód, st.sz_menny, rf.kelt as r_kelt, rf.hat_idő, rf.engedmény
from száll_fej sf, száll_tétel st, rend_fej rf
where sf.szlevél=st.szlevél and rf.rendszám=st.rendszám 
	and szlaszám is null and partner=@pkód
--order by st.szlevél, sorszám
)

--select * from dbo.lek23(22)
--order by szlevél, sorszám




GO
/****** Object:  UserDefinedFunction [dbo].[lek9]    Script Date: 2019. 08. 24. 2:00:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE function [dbo].[lek9]
()
-- Azon partnerek listája, akik 
-- legalább 1 éve nem rendeltek ÉS minden rendelésük teljesült
returns table
as
return
(

select * from partner
where partner not in 
	(
	select partner
	from rend_fej
	where rendszám IN 
		(select rendszám from rend_tétel where r_menny>teljesítve)
	)
	and partner in 
	(
	select partner
	from rend_fej
	)
intersect 

select * from partner
where partner not in 
	(
	select partner from rend_fej where dateadd(year,1,kelt)>getdate()
	)


)
--select * from dbo.lek9()
GO
/****** Object:  View [dbo].[lek1]    Script Date: 2019. 08. 24. 2:00:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create view [dbo].[lek1]
as 

-- Az engedmény sávok szabályos megjelenítése

SELECT határ AS alsó_határ, 
(SELECT MIN(határ) FROM engedmény WHERE határ> a.határ)-1 
AS felső_határ, százalék
FROM engedmény a;
GO
/****** Object:  View [dbo].[lek10]    Script Date: 2019. 08. 24. 2:00:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[lek10]
as
-- Az egyes rendelési tételekre történõ szállítások száma a számlázás állapota szerint
select	rendszám,kód, 
		case when szlaszám is not null then 'igen' else 'nem' end as számlázva, 
		count(*) as hány_száll
from száll_tétel st,száll_fej sf
where st.szlevél=sf.szlevél
group by rendszám,kód, 
		case when szlaszám is not null then 'igen' else 'nem' end

-- select * from lek10
GO
/****** Object:  View [dbo].[lek12]    Script Date: 2019. 08. 24. 2:00:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[lek12]
as
-- Mely termékekbe épül be csupa készlettel rendelkezõ anyag?
select kód
from szerkezet 
except
select kód
from szerkezet inner join anyag on anyag.azonosító=szerkezet.azonosító
where készlet=0

--select * from lek12
GO
/****** Object:  View [dbo].[lek13]    Script Date: 2019. 08. 24. 2:00:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[lek13]
as
-- Átlagosan hány százalékkal változtak a termékárak az év elejéhez képest?

select avg(vált.változás) as átlag
from (
	select kód, (-dbo.termék_ára(cast(dateadd(day,-DATEPART(dy,getdate())+1,getdate()) as date), kód)+akt_ár)/dbo.termék_ára (cast(dateadd(day,-DATEPART(dy,getdate())+1,getdate()) as date), kód) 
		as változás
	  from termék
	  )as vált


GO
/****** Object:  View [dbo].[lek14]    Script Date: 2019. 08. 24. 2:00:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[lek14]
as

-- A határidõk elõtt hány nappal teljesítették az egyes rendeléseket?

select rf.rendszám, min(hat_idő)- max(sf.kelt) as ha_idő_előtt
from rend_fej rf, száll_tétel st, száll_fej sf
where rf.rendszám not in (select rendszám from rend_tétel
		where r_menny>teljesítve)
		and st.rendszám=rf.rendszám and st.szlevél=sf.szlevél
group by rf.rendszám
GO
/****** Object:  View [dbo].[lek21]    Script Date: 2019. 08. 24. 2:00:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[lek21]
-- A termékek önköltség szerinti minősítése
as
select *,(select szöveg from minősítés where alsó=
		(select max(alsó) as határ from minősítés
		where alsó<=dbo.ktsg(termék.kód)))as minősítés
from termék
GO
/****** Object:  View [dbo].[lek5]    Script Date: 2019. 08. 24. 2:00:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[lek5]
as
select month(dátum) as hónap, sum(mennyiség*be_ár) as kiadás
from beszerzés
where year(dátum)=year(getdate())
group by month(dátum)
union
select hó, 0 
from dbo.hó12()
where hó not in
(
select month(dátum) from beszerzés where year(dátum)=year(getdate())
)

--select * from lek5
GO
/****** Object:  View [dbo].[lek6]    Script Date: 2019. 08. 24. 2:00:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[lek6]
-- Az anyagoknak a beszerzés gyakorisága szerint csökkenõ listája
as

select *, 
	(select count(*) from beszerzés where azonosító=a.azonosító)as beszerz_száma
from anyag a
--order by beszerz_száma desc

--select * from lek6
--order by beszerz_száma desc
GO
/****** Object:  View [dbo].[lek8]    Script Date: 2019. 08. 24. 2:00:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[lek8]
-- Az eddigi árbevételek megbontása
-- tényleges árbevételre (számlázott),
-- esedékes árbevételre (kiszállított, de nem számlázott),
-- várható árbevételre (ki nem szállított)
as 
select '1.) tényleges:' as árbevétel,sum(végösszeg) as összege
from számla
union
select '2.) esedékes:',sum(fizetendő)
from száll_fej
where szlaszám is null
union
select '3.) várható:',sum((r_menny-teljesítve)*dbo.termék_ára(rf.kelt,
kód)*(100-engedmény)/100)
from rend_tétel rt inner join rend_fej rf on rf.rendszám=rt.rendszám
where r_menny>teljesítve
GO
/****** Object:  View [dbo].[proba]    Script Date: 2019. 08. 24. 2:00:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create view [dbo].[proba]
as
select month(dátum) as hónap, sum(mennyiség*be_ár) as kiadás
from beszerzés
where year(dátum)=year(getdate())
group by month(dátum)
union
select hó, 0 from dbo.prooba()
where hó not in
(
select month(dátum) from beszerzés where year(dátum)=year(getdate())
)
GO
/****** Object:  StoredProcedure [dbo].[sp_lek15]    Script Date: 2019. 08. 24. 2:00:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sp_lek15]

-- Mely termék(ek)bõl rendeltek legrégebben utoljára
-- (jelezve, ha volt azóta árváltozás)?
as
begin

select kód, max(kelt) as utolsó into #utolsó
from rend_fej f inner join rend_tétel t on f.rendszám=t.rendszám
group by kód
-- select * from #utolsó

select *,
(case when utolsó<(select max(mikor) from árvált where
kód=#utolsó.kód) then 'igen' else 'nem' end)as volt_e_árvált
from #utolsó
where utolsó=(select min(utolsó) from #utolsó)

drop table #utolsó

end

--exec sp_lek15
GO
/****** Object:  StoredProcedure [dbo].[sp_lek20]    Script Date: 2019. 08. 24. 2:00:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[sp_lek20]

-- A kitörölhetõ megrendelések listája az elmaradt árbevétel összegével
-- azaz: semmi kiszállítás, és legalább 30 napja volt a hat.idõ
as
begin

select rendszám, kelt, engedmény into #tör_rend
from rend_fej
where rendszám not in (select rendszám from rend_tétel where teljesítve>0)
		and datediff(day,hat_idő,getdate())>30 

select tr.rendszám, 
		sum(r_menny*dbo.termék_ára(kelt, kód)*(100-engedmény)/100) as elmaradt_összeg
from #tör_rend tr, rend_tétel rt
where tr.rendszám=rt.rendszám
group by tr.rendszám

drop table #tör_rend

end

--exec sp_lek20
GO
/****** Object:  StoredProcedure [dbo].[sp_lek4]    Script Date: 2019. 08. 24. 2:00:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sp_lek4]
-- Adott határidõre vonatkozó teljes anyagszükséglet 
-- a hiányzó mennyiségekkel a pillanatnyi készletek mellett

@hatidő datetime

as 
begin

select azonosító, sum((r_menny-teljesítve)*menny)as szükséges into #szükséglet
from szerkezet sz, rend_fej rf, rend_tétel rt
where rf.rendszám=rt.rendszám and sz.kód=rt.kód and hat_idő=@hatidő
group by azonosító

select s.azonosító, szükséges, case when szükséges>készlet then szükséges-készlet else 0 end as hiány
from anyag a, #szükséglet s
where a.azonosító=s.azonosító

drop table #szükséglet

end
;

--exec sp_lek4 '2019-05-31'
GO
/****** Object:  StoredProcedure [dbo].[sp_lek5]    Script Date: 2019. 08. 24. 2:00:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_lek5] 
	-- nincs paramétere, de ha lenne, ld. nincs()ben!
AS
BEGIN
	-- Az idei összes havi kiadások összege
	create table #hónapok (hó tinyint)
	
	declare @v tinyint
	while (select count(*) from #hónapok)<12
	begin
	select @v=count(*) from #hónapok
	insert into #hónapok values (@v+1)
	end
	-- select * from #hónapok
	select month(dátum) as hónap, sum(mennyiség*be_ár) as kiadás
	from beszerzés
	where year(dátum)=year(getdate())
	group by month(dátum)
	union
	select hó, 0 from #hónapok
	where hó not in
	(
	select month(dátum) from beszerzés where year(dátum)=year(getdate())
	)
	
	drop table #hónapok

END

-- exec sp_lek5 
GO
/****** Object:  StoredProcedure [dbo].[sp_lek7]    Script Date: 2019. 08. 24. 2:00:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sp_lek7]
-- A termékek össz-rendelés mennyisége szerint csökkenõ listájának az elsõ 3 helyezettje
-- van már előtag a hotverseny kezelésére!
as
begin
select top 3 with ties kód,  sum(r_menny) as összes
from rend_tétel
group by kód
order by 2 desc
end
-- exec sp_lek7 
GO
