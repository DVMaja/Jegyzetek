USE [master]
GO
/****** Object:  Database [csomagkuldoA]    Script Date: 2023. 10. 16. 15:53:48 ******/
CREATE DATABASE [csomagkuldoA]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'csomagkuldoA', FILENAME = N'/var/opt/mssql/data/csomagkuldoA.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'csomagkuldoA_log', FILENAME = N'/var/opt/mssql/data/csomagkuldoA_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [csomagkuldoA] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [csomagkuldoA].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [csomagkuldoA] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [csomagkuldoA] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [csomagkuldoA] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [csomagkuldoA] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [csomagkuldoA] SET ARITHABORT OFF 
GO
ALTER DATABASE [csomagkuldoA] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [csomagkuldoA] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [csomagkuldoA] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [csomagkuldoA] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [csomagkuldoA] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [csomagkuldoA] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [csomagkuldoA] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [csomagkuldoA] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [csomagkuldoA] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [csomagkuldoA] SET  ENABLE_BROKER 
GO
ALTER DATABASE [csomagkuldoA] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [csomagkuldoA] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [csomagkuldoA] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [csomagkuldoA] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [csomagkuldoA] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [csomagkuldoA] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [csomagkuldoA] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [csomagkuldoA] SET RECOVERY FULL 
GO
ALTER DATABASE [csomagkuldoA] SET  MULTI_USER 
GO
ALTER DATABASE [csomagkuldoA] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [csomagkuldoA] SET DB_CHAINING OFF 
GO
ALTER DATABASE [csomagkuldoA] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [csomagkuldoA] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [csomagkuldoA] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [csomagkuldoA] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'csomagkuldoA', N'ON'
GO
ALTER DATABASE [csomagkuldoA] SET QUERY_STORE = OFF
GO
USE [csomagkuldoA]
GO
/****** Object:  UserDefinedFunction [dbo].[árbev]    Script Date: 2023. 10. 16. 15:53:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[árbev]
-- 2 adott dátum közözti árbevétel mekkora
(
	@tol date,
	@ig date
)
returns money
as 
begin
return
(
Select sum(rt.menny*c.egys_ár)
from rend_tétel rt
	inner join rendelés r on rt.rend_szám=r.rend_szám
	inner join cikk c on rt.cikkszám=c.cikkszám
where kelt between @tol and @ig
)

end
GO
/****** Object:  Table [dbo].[csomag]    Script Date: 2023. 10. 16. 15:53:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[csomag](
	[csomag] [char](12) NOT NULL,
	[feladva] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[csomag] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[rendelés]    Script Date: 2023. 10. 16. 15:53:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[rendelés](
	[rend_szám] [char](12) NOT NULL,
	[kelt] [date] NOT NULL,
	[vkód] [int] NOT NULL,
	[csomag] [char](12) NULL,
PRIMARY KEY CLUSTERED 
(
	[rend_szám] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[csomagVaras]    Script Date: 2023. 10. 16. 15:53:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[csomagVaras]
as
select rend_szám, DATEDIFF(DAY, kelt, feladva) as nap, 'alatt telj-ve' as megj --feladva-kelt as eltelt_napok
from rendelés r
	inner join csomag cs on r.csomag=cs.csomag
where feladva is not Null

UNION

select rend_szám, DATEDIFF(DAY, kelt, GETDATE()), 'ja várják'
from rendelés r
	inner join csomag cs on r.csomag=cs.csomag
where feladva is Null

UNION

select rend_szám, DATEDIFF(DAY, kelt, GETDATE()), 'ja várják'
from rendelés 	
where csomag is Null
GO
/****** Object:  Table [dbo].[cikk]    Script Date: 2023. 10. 16. 15:53:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cikk](
	[cikkszám] [char](10) NOT NULL,
	[elnev] [varchar](30) NOT NULL,
	[akt_készlet] [smallint] NULL,
	[egys_ár] [money] NULL,
PRIMARY KEY CLUSTERED 
(
	[cikkszám] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[rend_tétel]    Script Date: 2023. 10. 16. 15:53:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[rend_tétel](
	[rend_szám] [char](12) NOT NULL,
	[cikkszám] [char](10) NOT NULL,
	[menny] [smallint] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[rend_szám] ASC,
	[cikkszám] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[vevő]    Script Date: 2023. 10. 16. 15:53:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[vevő](
	[vkód] [int] NOT NULL,
	[név] [varchar](20) NOT NULL,
	[cím] [varchar](40) NOT NULL,
	[tel] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[vkód] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[rend_tétel]  WITH CHECK ADD FOREIGN KEY([cikkszám])
REFERENCES [dbo].[cikk] ([cikkszám])
GO
ALTER TABLE [dbo].[rend_tétel]  WITH CHECK ADD FOREIGN KEY([rend_szám])
REFERENCES [dbo].[rendelés] ([rend_szám])
GO
ALTER TABLE [dbo].[rendelés]  WITH CHECK ADD FOREIGN KEY([csomag])
REFERENCES [dbo].[csomag] ([csomag])
GO
ALTER TABLE [dbo].[rendelés]  WITH CHECK ADD FOREIGN KEY([vkód])
REFERENCES [dbo].[vevő] ([vkód])
GO
ALTER TABLE [dbo].[cikk]  WITH CHECK ADD CHECK  (([akt_készlet]>=(0)))
GO
ALTER TABLE [dbo].[cikk]  WITH CHECK ADD CHECK  (([egys_ár]>(0)))
GO
ALTER TABLE [dbo].[rend_tétel]  WITH CHECK ADD CHECK  (([menny]>(0)))
GO
USE [master]
GO
ALTER DATABASE [csomagkuldoA] SET  READ_WRITE 
GO
