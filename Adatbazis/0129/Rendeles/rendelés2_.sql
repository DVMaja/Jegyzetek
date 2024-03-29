USE [Rendelés2]
GO
/****** Object:  StoredProcedure [dbo].[engedmény_be]    Script Date: 2022. 04. 01. 18:21:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- a rendeléstételek fevitelének befejezése után le kell lefuttatni 

CREATE PROCEDURE [dbo].[engedmény_be] 
	@rsz char(20)
	AS
BEGIN
    update rend_fej
    set engedmény=dbo.rend_engedménye(@rsz)
    where rendszám=@rsz
END
-- exec dbo.engedmény_be 'r222'


GO
/****** Object:  UserDefinedFunction [dbo].[futja]    Script Date: 2022. 04. 01. 18:21:14 ******/
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
/****** Object:  UserDefinedFunction [dbo].[korlát]    Script Date: 2022. 04. 01. 18:21:14 ******/
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
/****** Object:  UserDefinedFunction [dbo].[összegzés]    Script Date: 2022. 04. 01. 18:21:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
create FUNCTION [dbo].[összegzés] 
(
	@szla char(25)
)
RETURNS money
AS
BEGIN
	DECLARE @össz money

	SELECT @össz=sum(fizetendő)
	from száll_fej
	where szlaszám=@szla and szlaszám is not null

	if @össz is null
		set @össz=0

	RETURN @össz

END

GO
/****** Object:  UserDefinedFunction [dbo].[rend_engedménye]    Script Date: 2022. 04. 01. 18:21:14 ******/
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
/****** Object:  UserDefinedFunction [dbo].[száll_fizetend]    Script Date: 2022. 04. 01. 18:21:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create FUNCTION [dbo].[száll_fizetend]
(
	@szlev char(20)
)
RETURNS money
AS
BEGIN
	DECLARE @fizetendő money

	
	SELECT @fizetendő=sum(dbo.termék_ára(kelt,kód)*sz_menny*(100-engedmény)/100) from száll_tétel st, rend_fej rf
	where st.rendszám=rf.rendszám and szlevél=@szlev

	if @fizetendő is null
		set @fizetendő=0

	RETURN @fizetendő

END

GO
/****** Object:  UserDefinedFunction [dbo].[száll_összege]    Script Date: 2022. 04. 01. 18:21:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create FUNCTION [dbo].[száll_összege]
(
	@szlev char(20)
)
RETURNS money
AS
BEGIN
	DECLARE @összeg money

	
	SELECT @összeg=sum(dbo.termék_ára(kelt,kód)*sz_menny) from száll_tétel st, rend_fej rf
	where st.rendszám=rf.rendszám and szlevél=@szlev

	if @összeg is null
		set @összeg=0

	RETURN @összeg

END

GO
/****** Object:  Table [dbo].[Anyag]    Script Date: 2022. 04. 01. 18:21:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Anyag](
	[azonosító] [int] NOT NULL,
	[a_név] [varchar](30) NOT NULL,
	[mért_egys] [char](5) NOT NULL,
	[készlet] [decimal](18, 2) NULL,
	[átl_ár] [money] NULL,
 CONSTRAINT [PK_Anyag] PRIMARY KEY CLUSTERED 
(
	[azonosító] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Árvált]    Script Date: 2022. 04. 01. 18:21:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Árvált](
	[kód] [int] NOT NULL,
	[mikor] [datetime] NOT NULL,
	[régi_ár] [money] NOT NULL,
 CONSTRAINT [PK_Árvált] PRIMARY KEY CLUSTERED 
(
	[kód] ASC,
	[mikor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Beszerzés]    Script Date: 2022. 04. 01. 18:21:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Beszerzés](
	[dátum] [date] NOT NULL,
	[azonosító] [int] NOT NULL,
	[mennyiség] [decimal](16, 2) NOT NULL,
	[be_ár] [money] NOT NULL,
 CONSTRAINT [PK_Beszerzés] PRIMARY KEY CLUSTERED 
(
	[dátum] ASC,
	[azonosító] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Engedmény]    Script Date: 2022. 04. 01. 18:21:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Engedmény](
	[százalék] [tinyint] NOT NULL,
	[határ] [money] NOT NULL,
 CONSTRAINT [PK_Engedmény] PRIMARY KEY CLUSTERED 
(
	[százalék] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Minősítés]    Script Date: 2022. 04. 01. 18:21:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Minősítés](
	[alsó] [int] NOT NULL,
	[szöveg] [char](20) NOT NULL,
 CONSTRAINT [PK_Minősítés] PRIMARY KEY CLUSTERED 
(
	[alsó] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Partner]    Script Date: 2022. 04. 01. 18:21:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Partner](
	[partner] [int] NOT NULL,
	[p_név] [nchar](40) NOT NULL,
	[irsz] [nchar](10) NOT NULL,
	[hely] [nchar](40) NOT NULL,
	[utca] [nchar](30) NOT NULL,
	[tel] [nchar](15) NOT NULL,
 CONSTRAINT [PK_Partner] PRIMARY KEY CLUSTERED 
(
	[partner] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Rend_fej]    Script Date: 2022. 04. 01. 18:21:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Rend_fej](
	[rendszám] [char](20) NOT NULL,
	[kelt] [datetime] NOT NULL,
	[hat_idő] [datetime] NOT NULL,
	[partner] [int] NOT NULL,
	[engedmény] [tinyint] NULL,
 CONSTRAINT [PK_Rend_fej] PRIMARY KEY CLUSTERED 
(
	[rendszám] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Rend_tétel]    Script Date: 2022. 04. 01. 18:21:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Rend_tétel](
	[rendszám] [char](20) NOT NULL,
	[kód] [int] NOT NULL,
	[r_menny] [int] NOT NULL,
	[teljesítve] [int] NOT NULL,
 CONSTRAINT [PK_Rend_tétel] PRIMARY KEY CLUSTERED 
(
	[rendszám] ASC,
	[kód] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Száll_fej]    Script Date: 2022. 04. 01. 18:21:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Száll_fej](
	[szlevél] [char](20) NOT NULL,
	[kelt] [datetime] NOT NULL,
	[összeg]  AS ([dbo].[száll_összege]([szlevél])),
	[fizetendő]  AS ([dbo].[száll_fizetend]([szlevél])),
	[szlaszám] [char](20) NULL,
 CONSTRAINT [PK_Száll_fej] PRIMARY KEY CLUSTERED 
(
	[szlevél] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Száll_tétel]    Script Date: 2022. 04. 01. 18:21:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Száll_tétel](
	[szlevél] [char](20) NOT NULL,
	[sorszám] [tinyint] NOT NULL,
	[rendszám] [char](20) NOT NULL,
	[kód] [int] NOT NULL,
	[sz_menny] [int] NOT NULL,
 CONSTRAINT [PK_Száll_tétel] PRIMARY KEY CLUSTERED 
(
	[szlevél] ASC,
	[sorszám] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Számla]    Script Date: 2022. 04. 01. 18:21:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Számla](
	[szlaszám] [char](20) NOT NULL,
	[kelt] [datetime] NOT NULL,
	[végösszeg]  AS ([dbo].[összegzés]([szlaszám])),
 CONSTRAINT [PK_Számla] PRIMARY KEY CLUSTERED 
(
	[szlaszám] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Szerkezet]    Script Date: 2022. 04. 01. 18:21:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Szerkezet](
	[kód] [int] NOT NULL,
	[azonosító] [int] NOT NULL,
	[menny] [decimal](14, 2) NOT NULL,
 CONSTRAINT [PK_Szerkezet] PRIMARY KEY CLUSTERED 
(
	[kód] ASC,
	[azonosító] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Termék]    Script Date: 2022. 04. 01. 18:21:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Termék](
	[kód] [int] NOT NULL,
	[t_név] [varchar](50) NOT NULL,
	[akt_ár] [money] NOT NULL,
 CONSTRAINT [PK_Termék] PRIMARY KEY CLUSTERED 
(
	[kód] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Anyag] ADD  CONSTRAINT [DF_Anyag_készlet]  DEFAULT ((0)) FOR [készlet]
GO
ALTER TABLE [dbo].[Anyag] ADD  CONSTRAINT [DF_Anyag_átl_ár]  DEFAULT ((0)) FOR [átl_ár]
GO
ALTER TABLE [dbo].[Rend_tétel] ADD  CONSTRAINT [DF_Rend_tétel_teljesítve]  DEFAULT ((0)) FOR [teljesítve]
GO
ALTER TABLE [dbo].[Árvált]  WITH CHECK ADD  CONSTRAINT [FK_Árvált_Termék] FOREIGN KEY([kód])
REFERENCES [dbo].[Termék] ([kód])
GO
ALTER TABLE [dbo].[Árvált] CHECK CONSTRAINT [FK_Árvált_Termék]
GO
ALTER TABLE [dbo].[Beszerzés]  WITH CHECK ADD  CONSTRAINT [FK_Beszerzés_Anyag] FOREIGN KEY([azonosító])
REFERENCES [dbo].[Anyag] ([azonosító])
GO
ALTER TABLE [dbo].[Beszerzés] CHECK CONSTRAINT [FK_Beszerzés_Anyag]
GO
ALTER TABLE [dbo].[Rend_fej]  WITH CHECK ADD  CONSTRAINT [FK_Rend_fej_Engedmény] FOREIGN KEY([engedmény])
REFERENCES [dbo].[Engedmény] ([százalék])
GO
ALTER TABLE [dbo].[Rend_fej] CHECK CONSTRAINT [FK_Rend_fej_Engedmény]
GO
ALTER TABLE [dbo].[Rend_fej]  WITH CHECK ADD  CONSTRAINT [FK_Rend_fej_Partner] FOREIGN KEY([partner])
REFERENCES [dbo].[Partner] ([partner])
GO
ALTER TABLE [dbo].[Rend_fej] CHECK CONSTRAINT [FK_Rend_fej_Partner]
GO
ALTER TABLE [dbo].[Rend_tétel]  WITH CHECK ADD  CONSTRAINT [FK_Rend_tétel_Rend_fej] FOREIGN KEY([rendszám])
REFERENCES [dbo].[Rend_fej] ([rendszám])
GO
ALTER TABLE [dbo].[Rend_tétel] CHECK CONSTRAINT [FK_Rend_tétel_Rend_fej]
GO
ALTER TABLE [dbo].[Rend_tétel]  WITH CHECK ADD  CONSTRAINT [FK_Rend_tétel_Termék] FOREIGN KEY([kód])
REFERENCES [dbo].[Termék] ([kód])
GO
ALTER TABLE [dbo].[Rend_tétel] CHECK CONSTRAINT [FK_Rend_tétel_Termék]
GO
ALTER TABLE [dbo].[Száll_fej]  WITH CHECK ADD  CONSTRAINT [FK_Száll_fej_Számla] FOREIGN KEY([szlaszám])
REFERENCES [dbo].[Számla] ([szlaszám])
GO
ALTER TABLE [dbo].[Száll_fej] CHECK CONSTRAINT [FK_Száll_fej_Számla]
GO
ALTER TABLE [dbo].[Száll_tétel]  WITH CHECK ADD  CONSTRAINT [FK_Száll_tétel_Rend_tétel] FOREIGN KEY([rendszám], [kód])
REFERENCES [dbo].[Rend_tétel] ([rendszám], [kód])
GO
ALTER TABLE [dbo].[Száll_tétel] CHECK CONSTRAINT [FK_Száll_tétel_Rend_tétel]
GO
ALTER TABLE [dbo].[Száll_tétel]  WITH CHECK ADD  CONSTRAINT [FK_Száll_tétel_Száll_fej] FOREIGN KEY([szlevél])
REFERENCES [dbo].[Száll_fej] ([szlevél])
GO
ALTER TABLE [dbo].[Száll_tétel] CHECK CONSTRAINT [FK_Száll_tétel_Száll_fej]
GO
ALTER TABLE [dbo].[Szerkezet]  WITH CHECK ADD  CONSTRAINT [FK_Szerkezet_Anyag] FOREIGN KEY([azonosító])
REFERENCES [dbo].[Anyag] ([azonosító])
GO
ALTER TABLE [dbo].[Szerkezet] CHECK CONSTRAINT [FK_Szerkezet_Anyag]
GO
ALTER TABLE [dbo].[Szerkezet]  WITH CHECK ADD  CONSTRAINT [FK_Szerkezet_Termék] FOREIGN KEY([kód])
REFERENCES [dbo].[Termék] ([kód])
GO
ALTER TABLE [dbo].[Szerkezet] CHECK CONSTRAINT [FK_Szerkezet_Termék]
GO
ALTER TABLE [dbo].[Anyag]  WITH CHECK ADD  CONSTRAINT [CK_Anyag] CHECK  (([készlet]>=(0)))
GO
ALTER TABLE [dbo].[Anyag] CHECK CONSTRAINT [CK_Anyag]
GO
ALTER TABLE [dbo].[Anyag]  WITH CHECK ADD  CONSTRAINT [CK_Anyag_1] CHECK  (([átl_ár]>=(0)))
GO
ALTER TABLE [dbo].[Anyag] CHECK CONSTRAINT [CK_Anyag_1]
GO
ALTER TABLE [dbo].[Beszerzés]  WITH CHECK ADD  CONSTRAINT [CK_Beszerzés] CHECK  (([mennyiség]>(0)))
GO
ALTER TABLE [dbo].[Beszerzés] CHECK CONSTRAINT [CK_Beszerzés]
GO
ALTER TABLE [dbo].[Beszerzés]  WITH CHECK ADD  CONSTRAINT [CK_Beszerzés_1] CHECK  (([be_ár]>=(0)))
GO
ALTER TABLE [dbo].[Beszerzés] CHECK CONSTRAINT [CK_Beszerzés_1]
GO
ALTER TABLE [dbo].[Engedmény]  WITH CHECK ADD  CONSTRAINT [CK_Engedmény] CHECK  (([százalék]>=(0) AND [százalék]<=(100)))
GO
ALTER TABLE [dbo].[Engedmény] CHECK CONSTRAINT [CK_Engedmény]
GO
ALTER TABLE [dbo].[Rend_fej]  WITH CHECK ADD  CONSTRAINT [CK_Rend_fej] CHECK  (([kelt]<=getdate()))
GO
ALTER TABLE [dbo].[Rend_fej] CHECK CONSTRAINT [CK_Rend_fej]
GO
ALTER TABLE [dbo].[Rend_fej]  WITH CHECK ADD  CONSTRAINT [CK_Rend_fej_1] CHECK  ((dateadd(day,(30),[kelt])<[hat_idő]))
GO
ALTER TABLE [dbo].[Rend_fej] CHECK CONSTRAINT [CK_Rend_fej_1]
GO
ALTER TABLE [dbo].[Rend_fej]  WITH CHECK ADD  CONSTRAINT [CK_Rend_fej_2] CHECK  (([engedmény]>=(0)))
GO
ALTER TABLE [dbo].[Rend_fej] CHECK CONSTRAINT [CK_Rend_fej_2]
GO
ALTER TABLE [dbo].[Rend_tétel]  WITH CHECK ADD  CONSTRAINT [CK_Rend_tétel] CHECK  (([r_menny]>(0)))
GO
ALTER TABLE [dbo].[Rend_tétel] CHECK CONSTRAINT [CK_Rend_tétel]
GO
ALTER TABLE [dbo].[Rend_tétel]  WITH CHECK ADD  CONSTRAINT [CK_Rend_tétel_1] CHECK  (([teljesítve]<=[r_menny]))
GO
ALTER TABLE [dbo].[Rend_tétel] CHECK CONSTRAINT [CK_Rend_tétel_1]
GO
ALTER TABLE [dbo].[Száll_fej]  WITH CHECK ADD  CONSTRAINT [CK_Száll_fej] CHECK  (([kelt]<=getdate()))
GO
ALTER TABLE [dbo].[Száll_fej] CHECK CONSTRAINT [CK_Száll_fej]
GO
ALTER TABLE [dbo].[Száll_tétel]  WITH CHECK ADD  CONSTRAINT [CK_Száll_tétel] CHECK  (([sorszám]>(0)))
GO
ALTER TABLE [dbo].[Száll_tétel] CHECK CONSTRAINT [CK_Száll_tétel]
GO
ALTER TABLE [dbo].[Száll_tétel]  WITH CHECK ADD  CONSTRAINT [CK_Száll_tétel_1] CHECK  (([sz_menny]>(0)))
GO
ALTER TABLE [dbo].[Száll_tétel] CHECK CONSTRAINT [CK_Száll_tétel_1]
GO
ALTER TABLE [dbo].[Szerkezet]  WITH CHECK ADD  CONSTRAINT [CK_Szerkezet] CHECK  (([menny]>(0)))
GO
ALTER TABLE [dbo].[Szerkezet] CHECK CONSTRAINT [CK_Szerkezet]
GO
ALTER TABLE [dbo].[Termék]  WITH CHECK ADD  CONSTRAINT [CK_Termék] CHECK  (([akt_ár]>=(0)))
GO
ALTER TABLE [dbo].[Termék] CHECK CONSTRAINT [CK_Termék]
GO
/****** Object:  Trigger [dbo].[készlet]    Script Date: 2022. 04. 01. 18:21:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- adott anyag beszerzésekor 
-- az anyag súlyozott átlagára és pillanatnyi készlete is megváltozik

create TRIGGER [dbo].[készlet] 
   ON  [dbo].[Beszerzés] 
   AFTER INSERT
AS 
BEGIN
	update anyag
	set átl_ár=(select (átl_ár*készlet+be_ár*mennyiség)/(készlet+mennyiség)  
				from anyag a, inserted i
				where a.azonosító=i.azonosító ),
		készlet=(select készlet+mennyiség
				from anyag a, inserted i
				where a.azonosító=i.azonosító )
	where azonosító=(select azonosító from inserted);
END

GO
/****** Object:  Trigger [dbo].[enged]    Script Date: 2022. 04. 01. 18:21:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- az engedmény tábla határai és százalékai csak azonos rendben növekedhetnek
create TRIGGER [dbo].[enged]
   ON  [dbo].[Engedmény]
   for INSERT,UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
	declare @h1 int, @h2 int
	
	select @h1=count(*) from engedmény 
	where százalék<(select százalék from inserted);
	select @h2=count(*) from engedmény 
	where határ<(select határ from inserted);
	if NOT @h1 = @h2
		rollback tran

END

GO
/****** Object:  Trigger [dbo].[rend_törlés]    Script Date: 2022. 04. 01. 18:21:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- egy rendelés kitörlése - a tételei törlése után - csak akkor történhet meg, 
-- ha a rendelés határideje legalább 30 nappal elmúlt 
-- és egyetlen tételből sem történt teljesítés
 
create TRIGGER [dbo].[rend_törlés]
   ON  [dbo].[Rend_fej]
   instead of DELETE
AS 
BEGIN

	declare @rsz char(15), @hatidő datetime
	select @rsz=rendszám, @hatidő=hat_idő  from deleted	
	if 0=(select count(*) from rend_tétel 
			where rendszám=@rsz and teljesítve>0)AND @hatidő+30<getdate()
		begin
			delete from rend_tétel where rendszám=@rsz
			delete from rend_fej where rendszám=@rsz
		end

END

GO
/****** Object:  Trigger [dbo].[szer_termék]    Script Date: 2022. 04. 01. 18:21:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ne lehessen olyan terméket rendelni, aminek nincs még szerkezete

CREATE TRIGGER [dbo].[szer_termék]
   ON  [dbo].[Rend_tétel] 
   instead of INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	if 0 < (select count(*) from szerkezet where kód=(select inserted.kód from inserted))
		insert into rend_tétel select * from inserted
	else
		raiserror ('nincs szerkezete a terméknek', 10,1)
END

GO
/****** Object:  Trigger [dbo].[szla_partnere]    Script Date: 2022. 04. 01. 18:21:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ha egy nem üres szlaszámú szállítólevélhez  
-- vagy sokadik szállítólevél esetén egy újabb partner szállítóleveléhez 
-- rendelt az akt. szlaszám, 
-- akkor ne történjen meg a száll_fej.szlaszám módosítása

create TRIGGER [dbo].[szla_partnere] 
   ON [dbo].[Száll_fej]  
	AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
	if update(szlaszám)
		if (select szlaszám from deleted) is not null
			or 1<(select count(*) from száll_fej where szlaszám=(select szlaszám from inserted))
			    and 1<(select count(distinct partner) 
					from száll_fej sf inner join (száll_tétel st inner join rend_fej rf on st.rendszám=rf.rendszám) on sf.szlevél=st.szlevél 
					where szlaszám=(select szlaszám from inserted))
		
				rollback tran

END

GO
/****** Object:  Trigger [dbo].[sztétel_törlés]    Script Date: 2022. 04. 01. 18:21:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- tilos a száll_tétel törlése
create TRIGGER [dbo].[sztétel_törlés]
   ON  [dbo].[Száll_tétel] 
   instead of delete
AS 
BEGIN
	SET NOCOUNT ON;
	raiserror('nem szabad', 10, 1)
	
END

GO
/****** Object:  Trigger [dbo].[új_száll_tétel]    Script Date: 2022. 04. 01. 18:21:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- 1 száll_tétel felvitele csak akkor követk.be, ha 
-- első tétel vagy sokadik esetén nem új partnerhez tartozó rendelés-tételre vonatk.
-- és a szállított mennyiség nem nagyobb, mint a rend.tétel teljesítéséhez szükséges korlát
-- és a termékből éppen legyárt. száll.mennyiséghez a szerkezetben előírt anyag-készletek egyike sem kevés
-- Felvitel esetén: 
-- az új száll.tétel a szállítólevélhez tartozó következő sorszámmal kerül fel,
-- és a rend.tétel teljesítve mennyisége is frissül,
-- valamint a szükséges anyagok készlete is lecsökken

create trigger [dbo].[új_száll_tétel]
on [dbo].[Száll_tétel] 
instead of insert 

as
begin

declare @púj int, @prégi int
declare @szlevél char(20)
declare @sorsz tinyint
declare @rendszám char(20)
declare @kód int
declare @sz_menny int

select @szlevél= szlevél,@rendszám=rendszám, @kód=kód,@sz_menny= sz_menny from inserted
select @púj=partner
from rend_fej where rendszám=@rendszám

select @prégi =Max(partner),@sorsz=count(*) from rend_fej f, száll_tétel t
			where t.rendszám=f.rendszám and szlevél=@szlevél

if @sorsz=0 or @púj=@prégi
	if @sz_menny<=dbo.korlát(@rendszám,@kód) AND @sz_menny<=dbo.futja(@kód)
		begin
			insert száll_tétel 
				values (@szlevél, @sorsz+1, @rendszám, @kód, @sz_menny)
			update rend_tétel
				set teljesítve=teljesítve+@sz_menny
				where rendszám=@rendszám and kód=@kód 
			update anyag
				set készlet=készlet-(select menny*@sz_menny from szerkezet
								where kód=@kód and azonosító=anyag.azonosító)
				where azonosító IN(select azonosító from szerkezet where kód=@kód)
				
		end
	
end

GO
/****** Object:  Trigger [dbo].[szerkmódosít]    Script Date: 2022. 04. 01. 18:21:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- amely termékből már történt rendelés, annak szerkezete nem módosítható

create TRIGGER [dbo].[szerkmódosít]
   ON  [dbo].[Szerkezet] 
   AFTER UPDATE
AS 
BEGIN
	if exists (select * from rend_tétel
		where kód=(select deleted.kód from deleted))
		begin
			raiserror('nem szabad', 10, 1)
			print 'neeeeee '
			rollback tran
		end
END

GO
/****** Object:  Trigger [dbo].[árváltozás]    Script Date: 2022. 04. 01. 18:21:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- amikor egy termék ára megváltozik,
-- a régi ár a dátummal bekerül az árváltozás-ba

create TRIGGER [dbo].[árváltozás] 
   ON  [dbo].[Termék]
   AFTER UPDATE 
AS 
BEGIN
	SET NOCOUNT ON;
	declare @mi int, @mennyi money
	
	if update(akt_ár)
	begin
		select @mi=d.kód, @mennyi=d.akt_ár from deleted d;
		insert into árvált values (@mi, getdate(), @mennyi);
	end
END

GO
