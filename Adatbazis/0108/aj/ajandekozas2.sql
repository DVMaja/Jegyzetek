USE [master]
GO

--CREATE DATABASE ajandekozas2
GO
USE ajandekozas2
GO



CREATE TABLE [dbo].[sz�t�r]
(
	[id] [int] IDENTITY(1,1) NOT NULL,
	[�rt�k] [char](30) NULL,
	[t�pus] [char](1) NULL,
PRIMARY KEY ([id] ASC)
)
--t�pus �s �rt�k lesz eggy�tt a uniqe
-- itt tartjuk a dolgok besorol�s�t, a szem�lyek viszony�d fel�d,
--a term�k m�rk�j�t �s jellemz�j�t, az aj�nd�k alkalm�t...
GO

ALTER TABLE [dbo].[sz�t�r]  
WITH CHECK ADD  CONSTRAINT [CK_szotar] CHECK  
(([t�pus]='B' OR [t�pus]='J' OR [t�pus]='M' OR [t�pus]='A' OR t�pus='V'))

CREATE TABLE [dbo].[dolog]
(
	[dk�d] [int] IDENTITY(495,10) NOT NULL,
	[elnevez�s] [varchar](30) NULL,
	[besorol�s] [int] NULL,
PRIMARY KEY ([dk�d])
)

CREATE TABLE [dbo].[term�k]
(
	[tk�d] [int] IDENTITY(500,10) NOT NULL,
	[jellemz�] [int] NULL,
	[m�rka] [int] NULL,
	[dolog] [int] NOT NULL,
PRIMARY KEY (	[tk�d] ASC)
)
GO

CREATE TABLE [dbo].[szem�ly]
(
	[azon] [int] IDENTITY(100,1) NOT NULL,
	[n�v] [varchar](20) NULL,
	viszony int not null,
PRIMARY KEY (	[azon] ASC)
)

CREATE TABLE [dbo].[kedvel]
(
	[szem�ly] [int] NOT NULL,
	[term�k] [int] NOT NULL,
	[m�rt�k] [tinyint] NOT NULL,
PRIMARY KEY ([szem�ly] ASC,	[term�k] ASC)
)

GO

ALTER TABLE [dbo].[kedvel]  WITH CHECK ADD FOREIGN KEY([szem�ly])
REFERENCES [dbo].[szem�ly] ([azon])
GO
ALTER TABLE [dbo].[kedvel]  WITH CHECK ADD FOREIGN KEY([term�k])
REFERENCES [dbo].[term�k] ([tk�d])
GO
ALTER TABLE [dbo].[term�k]  WITH CHECK ADD FOREIGN KEY([dolog])
REFERENCES [dbo].[dolog] ([dk�d])


CREATE TABLE [dbo].[aj�nd�k]
(
	[ajazon] [int] IDENTITY(10000,1) NOT NULL,
	[term�k] [int] NOT NULL,
	[h�ny] [tinyint] NULL,
	[�tad�s] [date] NULL,
	[alkalom] [int] NULL,
	ir�ny char(1) not null,
PRIMARY KEY (ajazon) 
)

GO

CREATE TABLE [dbo].[aj�nd�koz�s]
(
	[aj�nd�k] [int] NOT NULL,
	[szem�ly] [int] NOT NULL,
PRIMARY KEY ([aj�nd�k],	[szem�ly] )
)
GO

ALTER TABLE [dbo].[aj�nd�k]  WITH CHECK ADD FOREIGN KEY([term�k])
REFERENCES [dbo].[term�k] ([tk�d])
GO
ALTER TABLE [dbo].[aj�nd�koz�s]  WITH CHECK ADD FOREIGN KEY([aj�nd�k])
REFERENCES [dbo].[aj�nd�k] ([ajazon])
GO
ALTER TABLE [dbo].[aj�nd�koz�s]  WITH CHECK ADD FOREIGN KEY([szem�ly])
REFERENCES [dbo].[szem�ly] ([azon])


-------

ALTER TABLE [dbo].[aj�nd�k]  WITH CHECK ADD  CONSTRAINT [CK_aj�nd�k] CHECK  (([h�ny]>(0)))

GO

ALTER TABLE [dbo].[aj�nd�k]  WITH CHECK ADD  CONSTRAINT [CK_aj�nd�koz�s] CHECK  (([ir�ny]='A' OR [ir�ny]='K'))

GO

GO
ALTER TABLE [dbo].[kedvel]  WITH CHECK ADD  CONSTRAINT [ck_kedvel] CHECK  (([m�rt�k]>=(0) AND [m�rt�k]<=(5)))

GO

GO


create function helyes_szotarbeli
(
@kk int, @tip char(1)--k�ls� kulcsnak val� adat, �s hogy milyen t�pus� legyen
)
returns bit
as
begin
	declare @vi bit=0
	if @tip=(select t�pus from sz�t�r where id=@kk)
		set @vi=1
	return @vi
end

go
--select * from sz�t�r
--select dbo.helyes_szotarbeli(1,'V')

alter table szem�ly
add constraint CK_sz1 check (dbo.helyes_szotarbeli(viszony,'V')=1)

alter table dolog
add constraint CK_sz2 check (dbo.helyes_szotarbeli(besorol�s,'B')=1 or besorol�s is null)

alter table term�k
add constraint CK_sz3 check (dbo.helyes_szotarbeli(jellemz�,'J')=1 ) -- or jellemz� is null)

alter table term�k
add constraint CK_sz4 check (dbo.helyes_szotarbeli(m�rka,'M')=1 ) -- or m�rka is null)

alter table aj�nd�k
add constraint CK_sz5 check (dbo.helyes_szotarbeli(alkalom,'A')=1)

--alter table dolog
--alter column besorol�s int null

--alter table term�k
--alter column dolog int not null

ALTER TABLE [dbo].[szem�ly] ADD UNIQUE ([n�v])

ALTER TABLE dolog ADD UNIQUE (elnevez�s)

ALTER TABLE sz�t�r ADD UNIQUE (�rt�k, t�pus)

-- akkor ak�r nevekkel k�ld�k be a SPsal a kedves sorait...

			--insert into szem�ly values ('�vi', 1)
			--select ident_current('szem�ly')
			--select * from sz�t�r
			--select * from szem�ly


--n�vvel 
--KI mit mennyire kedvel
--Ha m�g nincs ilyen szem�ly akkor vegye fel a szem�lyt
use ajandekozas2

insert into sz�t�r values('hat�rozatlan', 'V')

--param�terk k�z�l jellemz� �s m�rka �rt�ke lehet '---' 

go create proc kedv_felv
	@sz_neve varchar(20),
	@j_�rt�k char(30),
	@m_�rt�k char(30),
	@d_elnev varchar(30),
	@m�rt�k tinyint
	as
begin
	declare @visz int
	if @sz_neve is null or @j_�rt�k is null or @m_�rt�k is null
		or @d_elnev is null or @m�rt�k is null
		print 'Ki kell t�ltenimindent ha a jellemz�, vagy a m�rka tetsz�leges akkor legyen ---'

	else
	begin
		declare @azon int, @dk�d int
		declare @jid int, @mid int
		--az aktu gen kulcsok
		select @azon=azon from szem�ly where n�v= @sz_neve
		if @azon is null
		begin 
			select @visz=id from sz�t�r where �rt�k='hat�rozatlan' and t�pus='V'
			insert into szem�ly values (@sz_neve, @visz)
			set @azon=IDENT_CURRENT('szem�ly')
			end
		select @dk�d=dk�d from dolog where elnevez�s=@d_elnev
			if @dk�d is null
			begin
				insert into dolog values(@d_elnev, null)
				set @dk�d=IDENT_CURRENT('dolog')
				end
							
			select @jid=id from dolog where �rt�k=@j_�rt�k and t�pus='J'
			if @jid is null
			begin
				insert into sz�t�r values(@j_�rt�k, 'J')
				set @jid=IDENT_CURRENT('sz�t�r')
				end

			select @mid=id from sz�t�r where �rt�k=@m_�rt�k and t�pus='M'
			if @mid is null
			begin
				insert into sz�t�r values(@m_�rt�k, 'M')
				set @mid=IDENT_CURRENT('sz�t�r')
				end

			select @tk�d=tk�d from term�k
			where dolog=@dk�d and jellemz�=@



	end


	--J�
	create proc kedv_felv
@sz_neve varchar(20),
@j_�rt�k char(30),
@m_�rt�k char(30),
@d_elnev varchar(30),
@m�rt�k tinyint
 
as
begin
	declare @visz int
 
	if @sz_neve is null or @j_�rt�k is null or @m_�rt�k is null or @d_elnev is null or @m�rt�k is null
		print 'MINDET ki kell t�lteni, ha a jell., vagy a m�rka tetsz�leges, legyen ---'
	else
	begin
 
		declare @azon int, @dk�d int, @tk�d int, @jid int, @mid int
		select @azon = azon from szem�ly where n�v = @sz_neve
		if @azon is null
			begin
				select @visz = id from sz�t�r where �rt�k = 'hat�rozatlan' and t�pus = 'V'
				insert into szem�ly values (@sz_neve, @visz)
				set @azon = IDENT_CURRENT('szem�ly')
			end
		select @dk�d = dk�d from dolog where elnevez�s = @d_elnev
		if @dk�d is null
			begin
				insert into dolog values (@d_elnev, null)
				set @dk�d=IDENT_CURRENT('dolog')
			end
		select @jid = id from sz�t�r where �rt�k = @j_�rt�k and t�pus = 'J'
		if @jid is null
			begin
				insert into sz�t�r values (@j_�rt�k, 'J')
				set @jid=IDENT_CURRENT('sz�t�r')
			end
		select @mid = id from sz�t�r where �rt�k = @m_�rt�k and t�pus = 'M'
		if @mid is null
			begin
				insert into sz�t�r values (@M_�rt�k, 'M')
				set @mid=IDENT_CURRENT('sz�t�r')
			end
		select @tk�d = tk�d from term�k 
		where dolog = @dk�d and jellemz� = @jid and m�rka = @mid
		if @tk�d is null
			begin
				insert into term�k values (@jid, @mid, @dk�d)
				set @tk�d=IDENT_CURRENT('term�k')
			end
		insert into kedvel
		values(@azon, @tk�d, @m�rt�k)
	end
end
 

exec kedv_felv 'Maja', 'mogyor�s �t', 'Milka', 'csokol�d�', 5;
exec kedv_felv 'Maja', 'feh�r', 'milka', 'csokol�d�', 1;
exec kedv_felv 'Zsolt', 'tramini', 'Varga', 'bor', 5;
exec kedv_felv 'Kati', 'feh�r', '---', 'bor', 1;
exec kedv_felv 'Niki', 'fantazy', 'K�nyvMolyK�pz�', 'k�nyv', 5;
exec kedv_felv 'Niki', 'cukor', 'diana', '�dess�g', 1;
exec kedv_felv 'Ricsi', 'Savany�', 'Haribo', 'Gumicukor', 5;
exec kedv_felv 'Ricsi', 'Ponty', '---', 'hal', 1;
exec kedv_felv 'Korn�l','natur','Milka','csokol�d�',5;
exec kedv_felv 'Korn�l','v�r�s','---','bor',1;
exec kedv_felv 'Hunor', 'aut�', 'Lego', 'j�t�k', 5;
exec kedv_felv 'Hunor', 'orchidea', 'k�k', 'vir�g', 1;
exec kedv_felv 'Leila', 'gumicukor', 'Haribo', '�dess�g', 5;
exec kedv_felv 'Leila', 't�rsasj�t�k', 'Monopoly', 'j�t�k', 1;
exec kedv_felv 'M�rton', 'Star Wars', 'Lucasfilm ', 'film', 5
exec kedv_felv 'M�rton', 'csip�s', 'Lays', 'chips', 1
exec kedv_felv 'Bence', 'piros', 'Ferrari', 'auto', 5
exec kedv_felv 'Bence', 'feh�r', 'Lada', 'auto', 1
exec kedv_felv 'Alexandra', 'feh�r', 'Grand Tokaj', 'bor', 5
exec kedv_felv 'Alexandra', 'bourbon', '---', 'whiskey', 1
exec kedv_felv 'Asztrik', 'Fekete', '---', 'csokol�d�', 4
exec kedv_felv 'Asztrik', 'Epres', 'Milka', 'csokol�d�', 1
exec kedv_felv 'Valentin', 'Sajtos', 'Lays', 'chips', 5
exec kedv_felv 'Valentin', 'Tej', 'Milka', 'csokol�d�', 1
exec kedv_felv 'Zoe', 'narancsos csoki', 'Lindt', 'csokol�d�', 5
exec kedv_felv 'Zoe', 'gy�mb�res tea', 'Pickwick', 'tea', 1
exec kedv_felv 'Bono', 'Mogyor�s', 'Milka', 'csokol�d�', 5
exec kedv_felv 'Bono', 'Tulip�n', 'Feh�r', 'vir�g', 1


end



