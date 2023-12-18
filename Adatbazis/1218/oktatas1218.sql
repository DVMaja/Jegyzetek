-- a tan�r m�r fel legyen v�ve, 
-- csak annyi �ra legyen le�temezve amennyi 
select * from tanit
select * from tanar
select * from kepes

update tanit set
 tanar=1
 where evf=5 and betu='B' and tant='MAT5'

 go
 create proc orarend_fel
	 @evf tinyint,
	 @betu char(1),
	 @nap tinyint,
	 @ora tinyint,
	 @tant char(5),
	 @terem smallint

as
begin
	-- tan�r ne �tk�zz�n,
	-- 
	declare @tanar int
	select @tanar = tanar from tanit where evf=@evf and betu=@betu and tant=@tant
	if @tanar is null
		print 'NIncs m�g hozz� rendelt tan�r'
	else
		if   0<(select COUNT(*)
			from orarend as o
				inner join tanit as t on o.evf=t.evf and o.betu=t.betu and o.tant=t.tant
			where tanar=@tanar and nap=@nap and ora=@ora
			)
			print 'A tan�r �tk�zne ha '
		else
			if (select heti_oraszam from tantargy where tant=@tant) =
			(select COUNT(*) from orarend where evf=@evf and betu=@betu and tant=@tant)
			print 'Meghaladn� a heti �rasz��mot'
			else
				insert into orarend values(@evf, @betu, @nap, @ora, @tant, @terem)
end
select * from tanit
select * from tanar
select * from kepes
select * from orarend

exec orarend_fel 3, 'A', 1, 5, 'MAT3', 111
exec orarend_fel 3, 'A', 1, 4, 'MAT3', 111
exec orarend_fel 3, 'A', 1, 1, 'MAT3', 111
exec orarend_fel 5, 'A', 1, 2, 'MAT5', 222

create table hianyzas
(
	diak int,
	mikor date,
	ora tinyint,
	igazolt bit,
	primary key (diak, mikor, ora),
	foreign key (diak) references diak(azon)
)

select GETDATE(), DATEPART(dw, GETDATE()) --a r�v�d�t�sekkel vigy�zz
set datefirst 1
--F1-gyel elvisz a dokument�ci�j�hoz
-- a h�tf� lesz a h�t els� napja
go
create proc hianyzik
	@diak int, 
	@mikor date,
	@ora tinyint

as 
begin
declare @evf tinyint, @betu char(1), @nap tinyint, @tant char(5)
	select @evf=evf from diak			
		where azon=@diak
		set @nap=DATEPART(dw, @mikor)
		set datefirst 1

		select @tant=tant from orarend where evf=@evf and betu=@betu and nap=@nap and ora=@nap
		IF @tant is null
			print 'ekkor nem hi�nyozhat'
		else
			begin
				print @tant + '-b�l hi�nyzik'
				insert into hianyzas values(@diak, @mikor, @ora, 0)
			end
end

exec hianyzik 101, '20231218', 2
-- a szorz� a jegynek a sz�rz�ja
--mindenkire minden t�rgyb�l csin�lj �tlagot.