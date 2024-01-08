select * from �rarend
--ellen�rizve hogy nem engedi meg a uniqe miatt
insert into �rarend values('1A', 2, 2, 'IRO1',11)


--min�l t�b indexet hozok l�tre ann�l tov�bb tart az adatokat bet�lteni

--konstraintek l�trehoz�sa 10.02
--egyszer� megszor�t�sok -> egyszer� megszor.
--heti �rasz�m >0 , kapac�t�s > 0, nal eleme [1, 5], �ra eleme [1, 10]


alter table tant�rgy
add check (heti_�rasz�m>0)

--COnstraints jobb gomb script constraint to �s ki lehet m�solni
ALTER TABLE [dbo].[terem]  WITH CHECK ADD  CONSTRAINT [CK_terem] CHECK  (([kapacit�s]>(0)))
GO

ALTER TABLE [dbo].[terem] CHECK CONSTRAINT [CK_terem]
GO
--�rdemes r�videket �rmi, hogy l�ssok a hiba �zenetet

--�ssz msz-ok az �rarendben:
--az oszt�ly adott tant�rgyi �r�ja nem lehet a heti �rasz�mot meghalad�
go
create function meghaladja
(
	@tant char(5)
	--a saj�t v�ltoz�k @-osak lesznek
	,@oszt char(2)
)
returns bit
--igen ha sok, egy�bk�nt nem
as 
begin
	IF
	(select heti_�rasz�m from tant�rgy where tant=@tant)
		<=(select count(*) from �rarend where oszt�ly=@tant)
	--k�t skal�rt hasonl�tunk �ssze
		return 1
	else
		return 0
end

--vagy kevesebb kij�rattal

go
create function meghaladja
(
	@tant char(5)
	--a saj�t v�ltoz�k @-osak lesznek
	,@oszt char(2)
)
returns bit
--igen ha sok, egy�bk�nt nem
as 
begin
	declare @vissza bit
	set @vissza = 0 -- hogy ne keljen else �g
	IF
	(select heti_�rasz�m from tant�rgy where tant=@tant)
		<=(select count(*) from �rarend where oszt�ly=@tant)
	--k�t skal�rt hasonl�tunk �ssze
		set @vissza = 1
	--else
	--	set @vissza = 0
	return @vissza
end

----aj�nlott eszk�z�kkel
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
	declare @korl�t tinyint, @van tinyint
	--set @vissza = 0 	
	--ha egy t�bl�b�l kellenek adatok, akkor egym�s ut�n be lehetne �rni �ket
	--set @korl�t = (select heti_�rasz�m from tant�rgy where tant=@tant)
	--set @van = (select count(*) from �rarend where oszt�ly=@tant)
	select @korl�t=heti_�rasz�m from tant�rgy where tant=@tant
	--ezek �rt�kad�ssok
	select @van=count(*) from �rarend where oszt�ly=@tant
	if @korl�t< @van
		set @vissza = 1	
	return @vissza
end

-- adott tant heti �rasz�m�t
go 
create function hetiOraszam
(
	@tantargy char(5)	
)
returns tinyint
as 
begin
	return (select heti_�rasz�m from tant�rgy where tant=@tantargy)	
end

create view n�zet1 as
select *, dbo.hetiOraszam(tant) as el��rt from tan�t

select * from n�zet1


-------------------------------------
go 
-- adott oszt�lynak adott t�rgyat/ tant tan�t� tan�r adott napon �s �r�ban nem �tk�zhet
--kijav�tand�, konstraintbe elhelyezend�
create function tan�r_�tk�z�s
(
	@oszt�ly char(2)
	, @tant char(5)
	,@nap tinyint
	,@�ra tinyint
)
returns bit
as 
begin
	declare @tan�r int, @vissza bit
	select @tan�r=tan�r from tan�t where oszt�ly=@oszt�ly and tant=@tant
	--lehet v�ltoz�san is 
	if 1<(select count(*) 
		from �rarend r inner join tan�t t on t.oszt�ly=r.oszt�ly and t.tant=r.tant
		where tan�r=@tan�r and nap=@nap and �ra=@�ra)
		set @vissza= 1--ha t�bb mint 1 sora van, vagyis vsn �tk�z�s
	else 
		set @vissza = 0
--jav�tsd �t 
	---endif
return @vissza
end

--select * from �rarend o inner join tan�t t on o.oszt�ly=t.oszt�ly and o.tant=t.tant
--order by tan�r, nap, �ra
--megszor�t�s felt�tele: 


--select dbo.meghaladja('mat1', '1a')
--a mat1 et az 1a nak nyugodtan felvihetem mertnem haladja meg
--megszor�t�sk�nt a felt dbo meghaladja(tant)
-- ha hozz�adtuk a konstrainthez, akkor nem lehet m�dos�tani

--az adott oszt�lynak az adott tant�rgya nem �tk�zhet az adott nap adott �r�j�ban
--megvan e az �sszes �rasz�m minden tan�t sorhoz



