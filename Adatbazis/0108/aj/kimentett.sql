USE [master]
GO
/****** Object:  Database [ajandekozas2]    Script Date: 2024. 01. 08. 16:04:57 ******/
CREATE DATABASE [ajandekozas2]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'ajandekozas2', FILENAME = N'/var/opt/mssql/data/ajandekozas2.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'ajandekozas2_log', FILENAME = N'/var/opt/mssql/data/ajandekozas2_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [ajandekozas2] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [ajandekozas2].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [ajandekozas2] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [ajandekozas2] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [ajandekozas2] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [ajandekozas2] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [ajandekozas2] SET ARITHABORT OFF 
GO
ALTER DATABASE [ajandekozas2] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [ajandekozas2] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [ajandekozas2] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [ajandekozas2] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [ajandekozas2] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [ajandekozas2] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [ajandekozas2] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [ajandekozas2] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [ajandekozas2] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [ajandekozas2] SET  ENABLE_BROKER 
GO
ALTER DATABASE [ajandekozas2] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [ajandekozas2] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [ajandekozas2] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [ajandekozas2] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [ajandekozas2] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [ajandekozas2] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [ajandekozas2] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [ajandekozas2] SET RECOVERY FULL 
GO
ALTER DATABASE [ajandekozas2] SET  MULTI_USER 
GO
ALTER DATABASE [ajandekozas2] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [ajandekozas2] SET DB_CHAINING OFF 
GO
ALTER DATABASE [ajandekozas2] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [ajandekozas2] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [ajandekozas2] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [ajandekozas2] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'ajandekozas2', N'ON'
GO
ALTER DATABASE [ajandekozas2] SET QUERY_STORE = OFF
GO
USE [ajandekozas2]
GO
/****** Object:  UserDefinedFunction [dbo].[helyes_szotarbeli]    Script Date: 2024. 01. 08. 16:04:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[helyes_szotarbeli]
(
@kk int, @tip char(1)--külső kulcsnak való adat, és hogy milyen típusú legyen
)
returns bit
as
begin
	declare @vi bit=0
	if @tip=(select típus from szótár where id=@kk)
		set @vi=1
	return @vi
end
GO
/****** Object:  Table [dbo].[ajándék]    Script Date: 2024. 01. 08. 16:04:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ajándék](
	[ajazon] [int] IDENTITY(10000,1) NOT NULL,
	[termék] [int] NOT NULL,
	[hány] [tinyint] NULL,
	[átadás] [date] NULL,
	[alkalom] [int] NULL,
	[irány] [char](1) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ajazon] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ajándékozás]    Script Date: 2024. 01. 08. 16:04:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ajándékozás](
	[ajándék] [int] NOT NULL,
	[személy] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ajándék] ASC,
	[személy] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dolog]    Script Date: 2024. 01. 08. 16:04:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dolog](
	[dkód] [int] IDENTITY(495,10) NOT NULL,
	[elnevezés] [varchar](30) NULL,
	[besorolás] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[dkód] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[kedvel]    Script Date: 2024. 01. 08. 16:04:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[kedvel](
	[személy] [int] NOT NULL,
	[termék] [int] NOT NULL,
	[mérték] [tinyint] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[személy] ASC,
	[termék] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[személy]    Script Date: 2024. 01. 08. 16:04:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[személy](
	[azon] [int] IDENTITY(100,1) NOT NULL,
	[név] [varchar](20) NULL,
	[viszony] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[azon] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[szótár]    Script Date: 2024. 01. 08. 16:04:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[szótár](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[érték] [char](30) NULL,
	[típus] [char](1) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[termék]    Script Date: 2024. 01. 08. 16:04:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[termék](
	[tkód] [int] IDENTITY(500,10) NOT NULL,
	[jellemző] [int] NULL,
	[márka] [int] NULL,
	[dolog] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[tkód] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[szótár] ON 

INSERT [dbo].[szótár] ([id], [érték], [típus]) VALUES (4, N'barát                         ', N'V')
INSERT [dbo].[szótár] ([id], [érték], [típus]) VALUES (9, N'csak úgy                      ', N'A')
INSERT [dbo].[szótár] ([id], [érték], [típus]) VALUES (2, N'edesség                       ', N'B')
INSERT [dbo].[szótár] ([id], [érték], [típus]) VALUES (7, N'epres                         ', N'J')
INSERT [dbo].[szótár] ([id], [érték], [típus]) VALUES (8, N'fantasy                       ', N'J')
INSERT [dbo].[szótár] ([id], [érték], [típus]) VALUES (10, N'határozatlan                  ', N'V')
INSERT [dbo].[szótár] ([id], [érték], [típus]) VALUES (1, N'ital                          ', N'B')
INSERT [dbo].[szótár] ([id], [érték], [típus]) VALUES (3, N'karácsony                     ', N'A')
INSERT [dbo].[szótár] ([id], [érték], [típus]) VALUES (5, N'Lego                          ', N'M')
INSERT [dbo].[szótár] ([id], [érték], [típus]) VALUES (6, N'milka                         ', N'M')
SET IDENTITY_INSERT [dbo].[szótár] OFF
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__dolog__E843C83D0108D955]    Script Date: 2024. 01. 08. 16:04:58 ******/
ALTER TABLE [dbo].[dolog] ADD UNIQUE NONCLUSTERED 
(
	[elnevezés] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__személy__DF6C2042FB06EB51]    Script Date: 2024. 01. 08. 16:04:58 ******/
ALTER TABLE [dbo].[személy] ADD UNIQUE NONCLUSTERED 
(
	[név] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__szótár__0B568010FEABD31B]    Script Date: 2024. 01. 08. 16:04:58 ******/
ALTER TABLE [dbo].[szótár] ADD UNIQUE NONCLUSTERED 
(
	[érték] ASC,
	[típus] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ajándék]  WITH CHECK ADD FOREIGN KEY([termék])
REFERENCES [dbo].[termék] ([tkód])
GO
ALTER TABLE [dbo].[ajándékozás]  WITH CHECK ADD FOREIGN KEY([ajándék])
REFERENCES [dbo].[ajándék] ([ajazon])
GO
ALTER TABLE [dbo].[ajándékozás]  WITH CHECK ADD FOREIGN KEY([személy])
REFERENCES [dbo].[személy] ([azon])
GO
ALTER TABLE [dbo].[kedvel]  WITH CHECK ADD FOREIGN KEY([személy])
REFERENCES [dbo].[személy] ([azon])
GO
ALTER TABLE [dbo].[kedvel]  WITH CHECK ADD FOREIGN KEY([termék])
REFERENCES [dbo].[termék] ([tkód])
GO
ALTER TABLE [dbo].[termék]  WITH CHECK ADD FOREIGN KEY([dolog])
REFERENCES [dbo].[dolog] ([dkód])
GO
ALTER TABLE [dbo].[ajándék]  WITH CHECK ADD  CONSTRAINT [CK_ajándék] CHECK  (([hány]>(0)))
GO
ALTER TABLE [dbo].[ajándék] CHECK CONSTRAINT [CK_ajándék]
GO
ALTER TABLE [dbo].[ajándék]  WITH CHECK ADD  CONSTRAINT [CK_ajándékozás] CHECK  (([irány]='A' OR [irány]='K'))
GO
ALTER TABLE [dbo].[ajándék] CHECK CONSTRAINT [CK_ajándékozás]
GO
ALTER TABLE [dbo].[ajándék]  WITH CHECK ADD  CONSTRAINT [CK_sz5] CHECK  (([dbo].[helyes_szotarbeli]([alkalom],'A')=(1)))
GO
ALTER TABLE [dbo].[ajándék] CHECK CONSTRAINT [CK_sz5]
GO
ALTER TABLE [dbo].[dolog]  WITH CHECK ADD  CONSTRAINT [CK_sz2] CHECK  (([dbo].[helyes_szotarbeli]([besorolás],'B')=(1) OR [besorolás] IS NULL))
GO
ALTER TABLE [dbo].[dolog] CHECK CONSTRAINT [CK_sz2]
GO
ALTER TABLE [dbo].[kedvel]  WITH CHECK ADD  CONSTRAINT [ck_kedvel] CHECK  (([mérték]>=(0) AND [mérték]<=(5)))
GO
ALTER TABLE [dbo].[kedvel] CHECK CONSTRAINT [ck_kedvel]
GO
ALTER TABLE [dbo].[személy]  WITH CHECK ADD  CONSTRAINT [CK_sz1] CHECK  (([dbo].[helyes_szotarbeli]([viszony],'V')=(1)))
GO
ALTER TABLE [dbo].[személy] CHECK CONSTRAINT [CK_sz1]
GO
ALTER TABLE [dbo].[szótár]  WITH CHECK ADD  CONSTRAINT [CK_szotar] CHECK  (([típus]='B' OR [típus]='J' OR [típus]='M' OR [típus]='A' OR [típus]='V'))
GO
ALTER TABLE [dbo].[szótár] CHECK CONSTRAINT [CK_szotar]
GO
ALTER TABLE [dbo].[termék]  WITH CHECK ADD  CONSTRAINT [CK_sz3] CHECK  (([dbo].[helyes_szotarbeli]([jellemző],'J')=(1)))
GO
ALTER TABLE [dbo].[termék] CHECK CONSTRAINT [CK_sz3]
GO
ALTER TABLE [dbo].[termék]  WITH CHECK ADD  CONSTRAINT [CK_sz4] CHECK  (([dbo].[helyes_szotarbeli]([márka],'M')=(1)))
GO
ALTER TABLE [dbo].[termék] CHECK CONSTRAINT [CK_sz4]
GO
/****** Object:  StoredProcedure [dbo].[kedv_fel]    Script Date: 2024. 01. 08. 16:04:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[kedv_fel]
@sz_neve varchar(20),
@j_érték char(30),
@m_érték char(30),
@d_elnev varchar(30),
@mérték tinyint
 
as
begin
	declare @visz int
 
	if @sz_neve is null or @j_érték is null or @m_érték is null or @d_elnev is null or @mérték is null
		print 'MINDET ki kell tölteni, ha a jell., vagy a márka tetszőleges, legyen ---'
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
		where dolog = @dkód and jellemző = @jid and márka = @mid
		if @tkód is null
			begin
				insert into termék values (@jid, @mid, @dkód)
				set @tkód=IDENT_CURRENT('termék')
			end
		insert into kedvel
		values(@azon, @tkód, @mérték)
	end
end
GO
USE [master]
GO
ALTER DATABASE [ajandekozas2] SET  READ_WRITE 
GO
