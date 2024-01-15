USE [master]
GO

--CREATE DATABASE ajandekozas2
GO
USE ajandekozas2
GO



CREATE TABLE [dbo].[szótár]
(
	[id] [int] IDENTITY(1,1) NOT NULL,
	[érték] [char](30) NULL,
	[típus] [char](1) NULL,
PRIMARY KEY ([id] ASC)
)
--típus és érték lesz eggyütt a uniqe
-- itt tartjuk a dolgok besorolását, a személyek viszonyád feléd,
--a termék márkáját és jellemzõjét, az ajándék alkalmát...
GO

ALTER TABLE [dbo].[szótár]  
WITH CHECK ADD  CONSTRAINT [CK_szotar] CHECK  
(([típus]='B' OR [típus]='J' OR [típus]='M' OR [típus]='A' OR típus='V'))

CREATE TABLE [dbo].[dolog]
(
	[dkód] [int] IDENTITY(495,10) NOT NULL,
	[elnevezés] [varchar](30) NULL,
	[besorolás] [int] NULL,
PRIMARY KEY ([dkód])
)

CREATE TABLE [dbo].[termék]
(
	[tkód] [int] IDENTITY(500,10) NOT NULL,
	[jellemzõ] [int] NULL,
	[márka] [int] NULL,
	[dolog] [int] NOT NULL,
PRIMARY KEY (	[tkód] ASC)
)
GO

CREATE TABLE [dbo].[személy]
(
	[azon] [int] IDENTITY(100,1) NOT NULL,
	[név] [varchar](20) NULL,
	viszony int not null,
PRIMARY KEY (	[azon] ASC)
)

CREATE TABLE [dbo].[kedvel]
(
	[személy] [int] NOT NULL,
	[termék] [int] NOT NULL,
	[mérték] [tinyint] NOT NULL,
PRIMARY KEY ([személy] ASC,	[termék] ASC)
)

GO

ALTER TABLE [dbo].[kedvel]  WITH CHECK ADD FOREIGN KEY([személy])
REFERENCES [dbo].[személy] ([azon])
GO
ALTER TABLE [dbo].[kedvel]  WITH CHECK ADD FOREIGN KEY([termék])
REFERENCES [dbo].[termék] ([tkód])
GO
ALTER TABLE [dbo].[termék]  WITH CHECK ADD FOREIGN KEY([dolog])
REFERENCES [dbo].[dolog] ([dkód])


CREATE TABLE [dbo].[ajándék]
(
	[ajazon] [int] IDENTITY(10000,1) NOT NULL,
	[termék] [int] NOT NULL,
	[hány] [tinyint] NULL,
	[átadás] [date] NULL,
	[alkalom] [int] NULL,
	irány char(1) not null,
PRIMARY KEY (ajazon) 
)

GO

CREATE TABLE [dbo].[ajándékozás]
(
	[ajándék] [int] NOT NULL,
	[személy] [int] NOT NULL,
PRIMARY KEY ([ajándék],	[személy] )
)
GO

ALTER TABLE [dbo].[ajándék]  WITH CHECK ADD FOREIGN KEY([termék])
REFERENCES [dbo].[termék] ([tkód])
GO
ALTER TABLE [dbo].[ajándékozás]  WITH CHECK ADD FOREIGN KEY([ajándék])
REFERENCES [dbo].[ajándék] ([ajazon])
GO
ALTER TABLE [dbo].[ajándékozás]  WITH CHECK ADD FOREIGN KEY([személy])
REFERENCES [dbo].[személy] ([azon])


-------

ALTER TABLE [dbo].[ajándék]  WITH CHECK ADD  CONSTRAINT [CK_ajándék] CHECK  (([hány]>(0)))

GO

ALTER TABLE [dbo].[ajándék]  WITH CHECK ADD  CONSTRAINT [CK_ajándékozás] CHECK  (([irány]='A' OR [irány]='K'))

GO

GO
ALTER TABLE [dbo].[kedvel]  WITH CHECK ADD  CONSTRAINT [ck_kedvel] CHECK  (([mérték]>=(0) AND [mérték]<=(5)))

GO

GO


create function helyes_szotarbeli
(
@kk int, @tip char(1)--külsõ kulcsnak való adat, és hogy milyen típusú legyen
)
returns bit
as
begin
	declare @vi bit=0
	if @tip=(select típus from szótár where id=@kk)
		set @vi=1
	return @vi
end

go
--select * from szótár
--select dbo.helyes_szotarbeli(1,'V')

alter table személy
add constraint CK_sz1 check (dbo.helyes_szotarbeli(viszony,'V')=1)

alter table dolog
add constraint CK_sz2 check (dbo.helyes_szotarbeli(besorolás,'B')=1 or besorolás is null)

alter table termék
add constraint CK_sz3 check (dbo.helyes_szotarbeli(jellemzõ,'J')=1 ) -- or jellemzõ is null)

alter table termék
add constraint CK_sz4 check (dbo.helyes_szotarbeli(márka,'M')=1 ) -- or márka is null)

alter table ajándék
add constraint CK_sz5 check (dbo.helyes_szotarbeli(alkalom,'A')=1)

--alter table dolog
--alter column besorolás int null

--alter table termék
--alter column dolog int not null

ALTER TABLE [dbo].[személy] ADD UNIQUE ([név])

ALTER TABLE dolog ADD UNIQUE (elnevezés)

ALTER TABLE szótár ADD UNIQUE (érték, típus)

-- akkor akár nevekkel küldök be a SPsal a kedves sorait...

			--insert into személy values ('Évi', 1)
			--select ident_current('személy')
			--select * from szótár
			--select * from személy


--névvel 
--KI mit mennyire kedvel
--Ha még nincs ilyen személy akkor vegye fel a személyt
use ajandekozas2

insert into szótár values('határozatlan', 'V')

--paraméterk közül jellemzõ és márka értéke lehet '---' 

go create proc kedv_felv
	@sz_neve varchar(20),
	@j_érték char(30),
	@m_érték char(30),
	@d_elnev varchar(30),
	@mérték tinyint
	as
begin
	declare @visz int
	if @sz_neve is null or @j_érték is null or @m_érték is null
		or @d_elnev is null or @mérték is null
		print 'Ki kell töltenimindent ha a jellemzõ, vagy a márka tetszõleges akkor legyen ---'

	else
	begin
		declare @azon int, @dkód int
		declare @jid int, @mid int
		--az aktu gen kulcsok
		select @azon=azon from személy where név= @sz_neve
		if @azon is null
		begin 
			select @visz=id from szótár where érték='határozatlan' and típus='V'
			insert into személy values (@sz_neve, @visz)
			set @azon=IDENT_CURRENT('személy')
			end
		select @dkód=dkód from dolog where elnevezés=@d_elnev
			if @dkód is null
			begin
				insert into dolog values(@d_elnev, null)
				set @dkód=IDENT_CURRENT('dolog')
				end
							
			select @jid=id from dolog where érték=@j_érték and típus='J'
			if @jid is null
			begin
				insert into szótár values(@j_érték, 'J')
				set @jid=IDENT_CURRENT('szótár')
				end

			select @mid=id from szótár where érték=@m_érték and típus='M'
			if @mid is null
			begin
				insert into szótár values(@m_érték, 'M')
				set @mid=IDENT_CURRENT('szótár')
				end

			select @tkód=tkód from termék
			where dolog=@dkód and jellemzõ=@



	end


	--JÓ
	create proc kedv_felv
@sz_neve varchar(20),
@j_érték char(30),
@m_érték char(30),
@d_elnev varchar(30),
@mérték tinyint
 
as
begin
	declare @visz int
 
	if @sz_neve is null or @j_érték is null or @m_érték is null or @d_elnev is null or @mérték is null
		print 'MINDET ki kell tölteni, ha a jell., vagy a márka tetszõleges, legyen ---'
	else
	begin
 
		declare @azon int, @dkód int, @tkód int, @jid int, @mid int
		select @azon = azon from személy where név = @sz_neve
		if @azon is null
			begin
				select @visz = id from szótár where érték = 'határozatlan' and típus = 'V'
				insert into személy values (@sz_neve, @visz)
				set @azon = IDENT_CURRENT('személy')
			end
		select @dkód = dkód from dolog where elnevezés = @d_elnev
		if @dkód is null
			begin
				insert into dolog values (@d_elnev, null)
				set @dkód=IDENT_CURRENT('dolog')
			end
		select @jid = id from szótár where érték = @j_érték and típus = 'J'
		if @jid is null
			begin
				insert into szótár values (@j_érték, 'J')
				set @jid=IDENT_CURRENT('szótár')
			end
		select @mid = id from szótár where érték = @m_érték and típus = 'M'
		if @mid is null
			begin
				insert into szótár values (@M_érték, 'M')
				set @mid=IDENT_CURRENT('szótár')
			end
		select @tkód = tkód from termék 
		where dolog = @dkód and jellemzõ = @jid and márka = @mid
		if @tkód is null
			begin
				insert into termék values (@jid, @mid, @dkód)
				set @tkód=IDENT_CURRENT('termék')
			end
		insert into kedvel
		values(@azon, @tkód, @mérték)
	end
end
 

exec kedv_felv 'Maja', 'mogyorós ét', 'Milka', 'csokoládé', 5;
exec kedv_felv 'Maja', 'fehér', 'milka', 'csokoládé', 1;
exec kedv_felv 'Zsolt', 'tramini', 'Varga', 'bor', 5;
exec kedv_felv 'Kati', 'fehér', '---', 'bor', 1;
exec kedv_felv 'Niki', 'fantazy', 'KönyvMolyKépzõ', 'könyv', 5;
exec kedv_felv 'Niki', 'cukor', 'diana', 'édesség', 1;
exec kedv_felv 'Ricsi', 'Savanyú', 'Haribo', 'Gumicukor', 5;
exec kedv_felv 'Ricsi', 'Ponty', '---', 'hal', 1;
exec kedv_felv 'Kornél','natur','Milka','csokoládé',5;
exec kedv_felv 'Kornél','vörös','---','bor',1;
exec kedv_felv 'Hunor', 'autó', 'Lego', 'játék', 5;
exec kedv_felv 'Hunor', 'orchidea', 'kék', 'virág', 1;
exec kedv_felv 'Leila', 'gumicukor', 'Haribo', 'édesség', 5;
exec kedv_felv 'Leila', 'társasjáték', 'Monopoly', 'játék', 1;
exec kedv_felv 'Márton', 'Star Wars', 'Lucasfilm ', 'film', 5
exec kedv_felv 'Márton', 'csipõs', 'Lays', 'chips', 1
exec kedv_felv 'Bence', 'piros', 'Ferrari', 'auto', 5
exec kedv_felv 'Bence', 'fehér', 'Lada', 'auto', 1
exec kedv_felv 'Alexandra', 'fehér', 'Grand Tokaj', 'bor', 5
exec kedv_felv 'Alexandra', 'bourbon', '---', 'whiskey', 1
exec kedv_felv 'Asztrik', 'Fekete', '---', 'csokoládé', 4
exec kedv_felv 'Asztrik', 'Epres', 'Milka', 'csokoládé', 1
exec kedv_felv 'Valentin', 'Sajtos', 'Lays', 'chips', 5
exec kedv_felv 'Valentin', 'Tej', 'Milka', 'csokoládé', 1
exec kedv_felv 'Zoe', 'narancsos csoki', 'Lindt', 'csokoládé', 5
exec kedv_felv 'Zoe', 'gyömbéres tea', 'Pickwick', 'tea', 1
exec kedv_felv 'Bono', 'Mogyorós', 'Milka', 'csokoládé', 5
exec kedv_felv 'Bono', 'Tulipán', 'Fehér', 'virág', 1


end



