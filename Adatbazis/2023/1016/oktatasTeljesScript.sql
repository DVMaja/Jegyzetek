USE [master]
GO
/****** Object:  Database [oktatás]    Script Date: 2023. 10. 16. 15:55:29 ******/
CREATE DATABASE [oktatás]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'oktatás', FILENAME = N'/var/opt/mssql/data/oktatás.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'oktatás_log', FILENAME = N'/var/opt/mssql/data/oktatás_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [oktatás] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [oktatás].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [oktatás] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [oktatás] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [oktatás] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [oktatás] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [oktatás] SET ARITHABORT OFF 
GO
ALTER DATABASE [oktatás] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [oktatás] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [oktatás] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [oktatás] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [oktatás] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [oktatás] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [oktatás] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [oktatás] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [oktatás] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [oktatás] SET  ENABLE_BROKER 
GO
ALTER DATABASE [oktatás] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [oktatás] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [oktatás] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [oktatás] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [oktatás] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [oktatás] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [oktatás] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [oktatás] SET RECOVERY FULL 
GO
ALTER DATABASE [oktatás] SET  MULTI_USER 
GO
ALTER DATABASE [oktatás] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [oktatás] SET DB_CHAINING OFF 
GO
ALTER DATABASE [oktatás] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [oktatás] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [oktatás] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [oktatás] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'oktatás', N'ON'
GO
ALTER DATABASE [oktatás] SET QUERY_STORE = OFF
GO
USE [oktatás]
GO
/****** Object:  UserDefinedFunction [dbo].[hetiOraszam]    Script Date: 2023. 10. 16. 15:55:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[hetiOraszam]
(
	@tantargy char(5)	
)
returns tinyint
as 
begin
	return (select heti_óraszám from tantárgy where tant=@tantargy)	
end
GO
/****** Object:  UserDefinedFunction [dbo].[meghaladja]    Script Date: 2023. 10. 16. 15:55:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[meghaladja]
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
	--ha egy táblából kellenek adatok, akkor egymás után be lehetne írni őket
	--set @korlát = (select heti_óraszám from tantárgy where tant=@tant)
	--set @van = (select count(*) from órarend where osztály=@tant)
	select @korlát=heti_óraszám from tantárgy where tant=@tant
	--ezek értékadássok
	select @van=count(*) from órarend where osztály=@tant
	if @korlát< @van
		set @vissza = 1	
	return @vissza
end
GO
/****** Object:  UserDefinedFunction [dbo].[tanár_ütközés]    Script Date: 2023. 10. 16. 15:55:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[tanár_ütközés]
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
GO
/****** Object:  Table [dbo].[tanít]    Script Date: 2023. 10. 16. 15:55:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tanít](
	[osztály] [char](2) NOT NULL,
	[tant] [char](5) NOT NULL,
	[tanár] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[osztály] ASC,
	[tant] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[nézet1]    Script Date: 2023. 10. 16. 15:55:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create view [dbo].[nézet1] as
select *, dbo.hetiOraszam(tant) as előírt from tanít
GO
/****** Object:  Table [dbo].[órarend]    Script Date: 2023. 10. 16. 15:55:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[órarend](
	[osztály] [char](2) NOT NULL,
	[nap] [tinyint] NOT NULL,
	[óra] [tinyint] NOT NULL,
	[tant] [char](5) NULL,
	[terem] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[osztály] ASC,
	[nap] ASC,
	[óra] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[leutemezve]    Script Date: 2023. 10. 16. 15:55:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[leutemezve]
as
select osztály, tant, count(*) as megvan
from órarend
group by osztály, tant
GO
/****** Object:  View [dbo].[leütemezve]    Script Date: 2023. 10. 16. 15:55:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[leütemezve]
as
select osztály, tant, count(*) as leutemezett
from órarend
group by osztály, tant

union

select osztály, tant, 0
from tanít T
	where osztály + tant not in(select osztály + tant from órarend)
GO
/****** Object:  Table [dbo].[tantárgy]    Script Date: 2023. 10. 16. 15:55:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tantárgy](
	[tant] [char](5) NOT NULL,
	[megnevezés] [varchar](25) NOT NULL,
	[heti_óraszám] [tinyint] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[tant] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[hiányB]    Script Date: 2023. 10. 16. 15:55:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[hiányB] as
select le.*, heti_óraszám-leutemezett as hiányA
from
	(select osztály, tant, count(*) as leutemezett
	from órarend
	group by osztály, tant
	union
	select osztály, tant, 0
	from tanít t
		where not exists (select 1 from órarend where osztály=t.osztály and tant=t.tant)
	)le 
	inner join tantárgy gy on le.tant=gy.tant
where heti_óraszám > leutemezett
GO
/****** Object:  View [dbo].[hiányD]    Script Date: 2023. 10. 16. 15:55:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[hiányD]
as
select le.*, heti_óraszám-leutemezett as hiányA
from
	(select osztály, tant, count(*) as leutemezett
	from órarend
	group by osztály, tant
	union
	(
	select t.osztály, t.tant, 0
	from tanít t
	left outer join órarend o on t.osztály=o.osztály and t. tant=o.tant
	where o.osztály is Null
	))le 
	inner join tantárgy gy on le.tant=gy.tant
where heti_óraszám > leutemezett
GO
/****** Object:  View [dbo].[hiányC]    Script Date: 2023. 10. 16. 15:55:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[hiányC]
as
select le.*, heti_óraszám-leutemezett as hiányA
from
	(select osztály, tant, count(*) as leutemezett
	from órarend
	group by osztály, tant
	union
	(
	select osztály, tant, 0 from tanít
	except
	select osztály, tant, 0 from órarend
	))le 
	inner join tantárgy gy on le.tant=gy.tant
where heti_óraszám > leutemezett
GO
/****** Object:  View [dbo].[hiányok]    Script Date: 2023. 10. 16. 15:55:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[hiányok]
as
select le.*, heti_óraszám-leutemezett as hiányA
from
	(	
	select t.osztály, t.tant, count(o.osztály) as leutemezett --count(*) hamis lenne
		from tanít t
		left outer join órarend o on t.osztály=o.osztály and t. tant=o.tant
		group by t.osztály, t.tant --o.osztáy, o.tant tévedés lenne
	)le 
	inner join tantárgy gy on le.tant=gy.tant
where heti_óraszám > leutemezett
GO
/****** Object:  Table [dbo].[diák]    Script Date: 2023. 10. 16. 15:55:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[diák](
	[azon] [int] IDENTITY(101,1) NOT NULL,
	[osztály] [char](2) NOT NULL,
	[név] [varchar](30) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[azon] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tanár]    Script Date: 2023. 10. 16. 15:55:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tanár](
	[kód] [int] IDENTITY(11,1) NOT NULL,
	[név] [varchar](30) NOT NULL,
	[szoba] [smallint] NULL,
PRIMARY KEY CLUSTERED 
(
	[kód] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[terem]    Script Date: 2023. 10. 16. 15:55:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[terem](
	[tszám] [int] NOT NULL,
	[kapacitás] [smallint] NULL,
PRIMARY KEY CLUSTERED 
(
	[tszám] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [NonClusteredIndex-20230925-154430]    Script Date: 2023. 10. 16. 15:55:29 ******/
CREATE UNIQUE NONCLUSTERED INDEX [NonClusteredIndex-20230925-154430] ON [dbo].[órarend]
(
	[nap] ASC,
	[óra] ASC,
	[terem] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[órarend]  WITH CHECK ADD FOREIGN KEY([osztály], [tant])
REFERENCES [dbo].[tanít] ([osztály], [tant])
GO
ALTER TABLE [dbo].[órarend]  WITH CHECK ADD FOREIGN KEY([terem])
REFERENCES [dbo].[terem] ([tszám])
GO
ALTER TABLE [dbo].[tanít]  WITH CHECK ADD FOREIGN KEY([tanár])
REFERENCES [dbo].[tanár] ([kód])
GO
ALTER TABLE [dbo].[tanít]  WITH CHECK ADD FOREIGN KEY([tant])
REFERENCES [dbo].[tantárgy] ([tant])
GO
ALTER TABLE [dbo].[órarend]  WITH CHECK ADD  CONSTRAINT [CK_órarend] CHECK  (([nap]>=(1) AND [nap]<=(6)))
GO
ALTER TABLE [dbo].[órarend] CHECK CONSTRAINT [CK_órarend]
GO
ALTER TABLE [dbo].[órarend]  WITH CHECK ADD  CONSTRAINT [CK_órarend_1] CHECK  (([óra]>=(1) AND [óra]<=(10)))
GO
ALTER TABLE [dbo].[órarend] CHECK CONSTRAINT [CK_órarend_1]
GO
ALTER TABLE [dbo].[órarend]  WITH CHECK ADD  CONSTRAINT [CK_órarend_2] CHECK  (([dbo].[meghaladja]([tant],[osztály])=(0)))
GO
ALTER TABLE [dbo].[órarend] CHECK CONSTRAINT [CK_órarend_2]
GO
ALTER TABLE [dbo].[órarend]  WITH CHECK ADD  CONSTRAINT [CK_órarend_3] CHECK  (([dbo].[tanár_ütközés]([osztály],[tant],[nap],[óra])=(0)))
GO
ALTER TABLE [dbo].[órarend] CHECK CONSTRAINT [CK_órarend_3]
GO
ALTER TABLE [dbo].[tantárgy]  WITH CHECK ADD CHECK  (([heti_óraszám]>(0)))
GO
ALTER TABLE [dbo].[terem]  WITH CHECK ADD  CONSTRAINT [CK_terem] CHECK  (([kapacitás]>(0)))
GO
ALTER TABLE [dbo].[terem] CHECK CONSTRAINT [CK_terem]
GO
USE [master]
GO
ALTER DATABASE [oktatás] SET  READ_WRITE 
GO
