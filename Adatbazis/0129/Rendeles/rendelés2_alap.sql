--create database rendelés2
--go

USE [rendelés2]
GO

/****** Object:  UserDefinedFunction [dbo].[száll_összege]    Script Date: 2019. 08. 24. 1:57:02 ******/
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

/****** Object:  UserDefinedFunction [dbo].[száll_fizetend]    Script Date: 2019. 08. 24. 1:57:02 ******/
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
/****** Object:  UserDefinedFunction [dbo].[összegzés]    Script Date: 2019. 08. 24. 1:57:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

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
-- a 3 számított mező függvénye...
-- +1 engedményszámításhoz haszn. fgv: termék_ára()

/****** Object:  UserDefinedFunction [dbo].[termék_ára]    Script Date: 08/28/2019 14:29:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- adott napon az adott termék árát adja vissza

CREATE FUNCTION [dbo].[termék_ára] 
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
go
----------------------------------------------------------------------------------

/****** Object:  Table [dbo].[Anyag]    Script Date: 2019. 08. 24. 2:03:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
/****** Object:  Table [dbo].[Árvált]    Script Date: 2019. 08. 24. 2:03:47 ******/
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
/****** Object:  Table [dbo].[Beszerzés]    Script Date: 2019. 08. 24. 2:03:47 ******/
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
/****** Object:  Table [dbo].[Engedmény]    Script Date: 2019. 08. 24. 2:03:47 ******/
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
/****** Object:  Table [dbo].[Minősítés]    Script Date: 2019. 08. 24. 2:03:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
/****** Object:  Table [dbo].[Partner]    Script Date: 2019. 08. 24. 2:03:47 ******/
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
/****** Object:  Table [dbo].[Rend_fej]    Script Date: 2019. 08. 24. 2:03:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
/****** Object:  Table [dbo].[Rend_tétel]    Script Date: 2019. 08. 24. 2:03:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
/****** Object:  Table [dbo].[Száll_fej]    Script Date: 2019. 08. 24. 2:03:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
/****** Object:  Table [dbo].[Száll_tétel]    Script Date: 2019. 08. 24. 2:03:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
/****** Object:  Table [dbo].[Számla]    Script Date: 2019. 08. 24. 2:03:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
/****** Object:  Table [dbo].[Szerkezet]    Script Date: 2019. 08. 24. 2:03:47 ******/
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
/****** Object:  Table [dbo].[Termék]    Script Date: 2019. 08. 24. 2:03:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
