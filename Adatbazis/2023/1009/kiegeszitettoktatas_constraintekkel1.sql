select * from órarend
--ellenõrizve hogy nem engedi meg a uniqe miatt
insert into órarend values('1A', 2, 2, 'IRO1',11)


--minél töb indexet hozok létre annál tovább tart az adatokat betölteni

--konstraintek létrehozása 10.02
--egyszerû megszorítások -> egyszerû megszor.
--heti óraszám >0 , kapacítás > 0, nal eleme [1, 5], óra eleme [1, 10]


alter table tantárgy
add check (heti_óraszám>0)

--COnstraints jobb gomb script constraint to és ki lehet másolni
ALTER TABLE [dbo].[terem]  WITH CHECK ADD  CONSTRAINT [CK_terem] CHECK  (([kapacitás]>(0)))
GO

ALTER TABLE [dbo].[terem] CHECK CONSTRAINT [CK_terem]
GO
--érdemes rövideket írmi, hogy lássok a hiba üzenetet

--össz msz-ok az órarendben:
--az osztály adott tantárgyi órája nem lehet a heti óraszámot meghaladó
go
create function meghaladja
(
	@tant char(5)
	--a saját változók @-osak lesznek
	,@oszt char(2)
)
returns bit
--igen ha sok, egyébként nem
as 
begin
	IF
	(select heti_óraszám from tantárgy where tant=@tant)
		<=(select count(*) from órarend where osztály=@tant)
	--két skalárt hasonlítunk össze
		return 1
	else
		return 0
end

--vagy kevesebb kijárattal

go
create function meghaladja
(
	@tant char(5)
	--a saját változók @-osak lesznek
	,@oszt char(2)
)
returns bit
--igen ha sok, egyébként nem
as 
begin
	declare @vissza bit
	set @vissza = 0 -- hogy ne keljen else ág
	IF
	(select heti_óraszám from tantárgy where tant=@tant)
		<=(select count(*) from órarend where osztály=@tant)
	--két skalárt hasonlítunk össze
		set @vissza = 1
	--else
	--	set @vissza = 0
	return @vissza
end

----ajánlott eszközökkel
go
create function meghaladja
(
	@tant char(5)	
	,@oszt char(2)
)
returns bit
as 
begin
	declare @vissza bit = 0
	declare @korlát tinyint, @van tinyint
	--set @vissza = 0 	
	--ha egy táblából kellenek adatok, akkor egymás után be lehetne írni õket
	--set @korlát = (select heti_óraszám from tantárgy where tant=@tant)
	--set @van = (select count(*) from órarend where osztály=@tant)
	select @korlát=heti_óraszám from tantárgy where tant=@tant
	--ezek értékadássok
	select @van=count(*) from órarend where osztály=@tant
	if @korlát< @van
		set @vissza = 1	
	return @vissza
end

-- adott tant heti óraszámát
go 
create function hetiOraszam
(
	@tantargy char(5)	
)
returns tinyint
as 
begin
	return (select heti_óraszám from tantárgy where tant=@tantargy)	
end

create view nézet1 as
select *, dbo.hetiOraszam(tant) as elõírt from tanít

select * from nézet1


-------------------------------------
go 
-- adott osztálynak adott tárgyat/ tant tanító tanár adott napon és órában nem ütközhet
--kijavítandó, konstraintbe elhelyezendõ
create function tanár_ütközés
(
	@osztály char(2)
	, @tant char(5)
	,@nap tinyint
	,@óra tinyint
)
returns bit
as 
begin
	declare @tanár int, @vissza bit
	select @tanár=tanár from tanít where osztály=@osztály and tant=@tant
	--lehet változósan is 
	if 1<(select count(*) 
		from órarend r inner join tanít t on t.osztály=r.osztály and t.tant=r.tant
		where tanár=@tanár and nap=@nap and óra=@óra)
		set @vissza= 1--ha több mint 1 sora van, vagyis vsn ütközés
	else 
		set @vissza = 0
--javítsd át 
	---endif
return @vissza
end

--select * from órarend o inner join tanít t on o.osztály=t.osztály and o.tant=t.tant
--order by tanár, nap, óra
--megszorítás feltétele: 


--select dbo.meghaladja('mat1', '1a')
--a mat1 et az 1a nak nyugodtan felvihetem mertnem haladja meg
--megszorításként a felt dbo meghaladja(tant)
-- ha hozzáadtuk a konstrainthez, akkor nem lehet módosítani

--az adott osztálynak az adott tantárgya nem ütközhet az adott nap adott órájában
--megvan e az összes óraszám minden tanít sorhoz



