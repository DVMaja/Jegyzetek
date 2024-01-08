--USE [master]
--GO
--/****** Object:  Database [Termékárak]    Script Date: 2021. 01. 24. 19:25:48 ******/
--CREATE DATABASE [Termékárak]
-- CONTAINMENT = NONE
-- ON  PRIMARY 
--( NAME = N'Termékárak', FILENAME = N'C:\Program Files (x86)\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\Termékárak.mdf' , SIZE = 4160KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
-- LOG ON 
--( NAME = N'Termékárak_log', FILENAME = N'C:\Program Files (x86)\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\Termékárak_log.ldf' , SIZE = 1040KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
--GO
--ALTER DATABASE [Termékárak] SET COMPATIBILITY_LEVEL = 110
--GO
--IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
--begin
--EXEC [Termékárak].[dbo].[sp_fulltext_database] @action = 'enable'
--end
--GO
--ALTER DATABASE [Termékárak] SET ANSI_NULL_DEFAULT OFF 
--GO
--ALTER DATABASE [Termékárak] SET ANSI_NULLS OFF 
--GO
--ALTER DATABASE [Termékárak] SET ANSI_PADDING OFF 
--GO
--ALTER DATABASE [Termékárak] SET ANSI_WARNINGS OFF 
--GO
--ALTER DATABASE [Termékárak] SET ARITHABORT OFF 
--GO
--ALTER DATABASE [Termékárak] SET AUTO_CLOSE ON 
--GO
--ALTER DATABASE [Termékárak] SET AUTO_CREATE_STATISTICS ON 
--GO
--ALTER DATABASE [Termékárak] SET AUTO_SHRINK OFF 
--GO
--ALTER DATABASE [Termékárak] SET AUTO_UPDATE_STATISTICS ON 
--GO
--ALTER DATABASE [Termékárak] SET CURSOR_CLOSE_ON_COMMIT OFF 
--GO
--ALTER DATABASE [Termékárak] SET CURSOR_DEFAULT  GLOBAL 
--GO
--ALTER DATABASE [Termékárak] SET CONCAT_NULL_YIELDS_NULL OFF 
--GO
--ALTER DATABASE [Termékárak] SET NUMERIC_ROUNDABORT OFF 
--GO
--ALTER DATABASE [Termékárak] SET QUOTED_IDENTIFIER OFF 
--GO
--ALTER DATABASE [Termékárak] SET RECURSIVE_TRIGGERS OFF 
--GO
--ALTER DATABASE [Termékárak] SET  ENABLE_BROKER 
--GO
--ALTER DATABASE [Termékárak] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
--GO
--ALTER DATABASE [Termékárak] SET DATE_CORRELATION_OPTIMIZATION OFF 
--GO
--ALTER DATABASE [Termékárak] SET TRUSTWORTHY OFF 
--GO
--ALTER DATABASE [Termékárak] SET ALLOW_SNAPSHOT_ISOLATION OFF 
--GO
--ALTER DATABASE [Termékárak] SET PARAMETERIZATION SIMPLE 
--GO
--ALTER DATABASE [Termékárak] SET READ_COMMITTED_SNAPSHOT OFF 
--GO
--ALTER DATABASE [Termékárak] SET HONOR_BROKER_PRIORITY OFF 
--GO
--ALTER DATABASE [Termékárak] SET RECOVERY SIMPLE 
--GO
--ALTER DATABASE [Termékárak] SET  MULTI_USER 
--GO
--ALTER DATABASE [Termékárak] SET PAGE_VERIFY CHECKSUM  
--GO
--ALTER DATABASE [Termékárak] SET DB_CHAINING OFF 
--GO
--ALTER DATABASE [Termékárak] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
--GO
--ALTER DATABASE [Termékárak] SET TARGET_RECOVERY_TIME = 0 SECONDS 
--GO
USE [Termékárak]
GO
/****** Object:  UserDefinedFunction [dbo].[termékára0]    Script Date: 2021. 01. 24. 19:25:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[termékára0]
-- ar ÁR0 táblából való keresés: adott termék adott napon mennyibe kerül
(
	@termék int,
	@mikor date
)
returns money
as
begin
	-- return (select ár from ÁR0 where termék=@termék and dtól<=@mikor and dig>=@mikor)
	return (select ár from ÁR0 where termék=@termék and @mikor between dtól and isnull(dig, getdate()))

end

 --select dbo.termékára0(101,cast('2020-02-17' as date))


GO
/****** Object:  UserDefinedFunction [dbo].[termékára1]    Script Date: 2021. 01. 24. 19:25:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[termékára1]
-- ar ÁR táblából való keresés helyett a kényelmes nézetbõl: adott termék adott napon mennyibe kerül
(
	@termék int,
	@mikor date
)
returns money
as
begin
	
	return (select új_ár from árlista1 where termék=@termék and @mikor between dtól and isnull(dig, getdate()))

end
 --select dbo.termékára1(101,cast('2020-02-17' as date))

GO
/****** Object:  UserDefinedFunction [dbo].[termékára11]    Script Date: 2021. 01. 24. 19:25:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[termékára11]
-- ar ÁR táblából való keresés: adott termék adott napon mennyibe kerül
(
	@termék int,
	@mikor date
)
returns money
as
begin
	declare @datum date
	select @datum=MAX(dtól) from ÁR where termék=@termék and dtól<=@mikor
	return (select új_ár from ÁR where termék=@termék and dtól=@datum)

end
 --select dbo.termékára11(101,cast('2020-02-17' as date))

GO
/****** Object:  UserDefinedFunction [dbo].[termékára2]    Script Date: 2021. 01. 24. 19:25:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[termékára2]
-- az VÁLT táblából való keresés helyett a kényelmes nézetbõl: adott termék adott napon mennyibe kerül
(
	@termék int,
	@mikor date
)
returns money
as
begin
	return (select ár from ÁRlista2 where termék=@termék and @mikor between dtól and dig)

end
 --select dbo.termékára2(101,cast('2020-02-17' as date))

GO
/****** Object:  UserDefinedFunction [dbo].[termékára22]    Script Date: 2021. 01. 24. 19:25:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[termékára22]
-- a VÁLT táblás esetben való keresés: adott termék adott napon mennyibe kerül
(
	@termék int,
	@mikor date
)
returns money
as
begin
	declare @dátum date, @vissza money
	select @dátum=MIN(dig) from vált where termék=@termék and @mikor<=dig 
	if @dátum is not null
		select @vissza=régi_ár from VÁLT where termék=@termék and @dátum=dig
	else
		select @vissza=akt_ár from termék where tkód=@termék
	-- az if vége...
	return @vissza
end
 --select dbo.termékára22(101,cast('2020-02-17' as date))

GO
/****** Object:  Table [dbo].[ÁR]    Script Date: 2021. 01. 24. 19:25:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ÁR](
	[termék] [int] NOT NULL,
	[dtól] [date] NOT NULL,
	[új_ár] [money] NULL,
 CONSTRAINT [PK_ÁR] PRIMARY KEY CLUSTERED 
(
	[termék] ASC,
	[dtól] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ÁR0]    Script Date: 2021. 01. 24. 19:25:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ÁR0](
	[termék] [int] NOT NULL,
	[dtól] [date] NOT NULL,
	[dig] [date] NULL,
	[ár] [money] NULL,
 CONSTRAINT [PK_ÁR0] PRIMARY KEY CLUSTERED 
(
	[termék] ASC,
	[dtól] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TERMÉK]    Script Date: 2021. 01. 24. 19:25:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TERMÉK](
	[tkód] [int] IDENTITY(101,1) NOT NULL,
	[elnev] [char](30) NOT NULL,
	[akt_ár] [money] NOT NULL,
 CONSTRAINT [PK_TERMÉK] PRIMARY KEY CLUSTERED 
(
	[tkód] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[VÁLT]    Script Date: 2021. 01. 24. 19:25:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VÁLT](
	[termék] [int] NOT NULL,
	[dig] [date] NOT NULL,
	[régi_ár] [money] NULL,
 CONSTRAINT [PK_VÁLT] PRIMARY KEY CLUSTERED 
(
	[termék] ASC,
	[dig] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  View [dbo].[árlista0]    Script Date: 2021. 01. 24. 19:25:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[árlista0]
as
select * from ár0 

GO
/****** Object:  View [dbo].[árlista1]    Script Date: 2021. 01. 24. 19:25:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[árlista1]
as 
-- az ÁRból egy teljes árlista
select	termék, 
		dtól, 
		(select dateadd(day, -1,MIN(dtól)) from ár where termék=K.termék and dtól>K.dtól ) as dig,	
		új_ár
from ÁR K

GO
/****** Object:  View [dbo].[árlista2]    Script Date: 2021. 01. 24. 19:25:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[árlista2]
as
-- a VÁLTból egy teljes árlista
select	termék, 
		(select isnull(dateadd(day, +1,MAX(dig)), cast('2020-01-02'as date)) from vált where termék=K.termék and dig<K.dig ) as dtól,	
		dig,
		régi_ár as ár
from VÁLT K
UNION
select tkód, cast('2020-01-02'as date), cast(getdate() as date), akt_ár
from termék
where tkód NOT IN (select termék from vált)
UNION
select tkód, (select dateadd(day,+1,max(dig)) from vált where termék=tkód), cast(getdate() as date), akt_ár
from termék
where  tkód IN (select termék from vált)

GO
INSERT [dbo].[ÁR] ([termék], [dtól], [új_ár]) VALUES (101, CAST(0x91400B00 AS Date), 1500.0000)
GO
INSERT [dbo].[ÁR] ([termék], [dtól], [új_ár]) VALUES (101, CAST(0xEB400B00 AS Date), 1000.0000)
GO
INSERT [dbo].[ÁR] ([termék], [dtól], [új_ár]) VALUES (101, CAST(0xF2400B00 AS Date), 1500.0000)
GO
INSERT [dbo].[ÁR] ([termék], [dtól], [új_ár]) VALUES (101, CAST(0x0A410B00 AS Date), 2000.0000)
GO
INSERT [dbo].[ÁR] ([termék], [dtól], [új_ár]) VALUES (103, CAST(0x91400B00 AS Date), 2500.0000)
GO
INSERT [dbo].[ÁR] ([termék], [dtól], [új_ár]) VALUES (103, CAST(0x0A410B00 AS Date), 3000.0000)
GO
INSERT [dbo].[ÁR] ([termék], [dtól], [új_ár]) VALUES (104, CAST(0x91400B00 AS Date), 2000.0000)
GO
INSERT [dbo].[ÁR] ([termék], [dtól], [új_ár]) VALUES (105, CAST(0x91400B00 AS Date), 1100.0000)
GO
INSERT [dbo].[ÁR] ([termék], [dtól], [új_ár]) VALUES (106, CAST(0x91400B00 AS Date), 9500.0000)
GO
INSERT [dbo].[ÁR0] ([termék], [dtól], [dig], [ár]) VALUES (101, CAST(0x91400B00 AS Date), CAST(0xEA400B00 AS Date), 1500.0000)
GO
INSERT [dbo].[ÁR0] ([termék], [dtól], [dig], [ár]) VALUES (101, CAST(0xEB400B00 AS Date), CAST(0xF1400B00 AS Date), 1000.0000)
GO
INSERT [dbo].[ÁR0] ([termék], [dtól], [dig], [ár]) VALUES (101, CAST(0xF2400B00 AS Date), CAST(0x09410B00 AS Date), 1500.0000)
GO
INSERT [dbo].[ÁR0] ([termék], [dtól], [dig], [ár]) VALUES (101, CAST(0x0A410B00 AS Date), NULL, 2000.0000)
GO
INSERT [dbo].[ÁR0] ([termék], [dtól], [dig], [ár]) VALUES (103, CAST(0x91400B00 AS Date), CAST(0x09410B00 AS Date), 2500.0000)
GO
INSERT [dbo].[ÁR0] ([termék], [dtól], [dig], [ár]) VALUES (103, CAST(0x0A410B00 AS Date), NULL, 3000.0000)
GO
INSERT [dbo].[ÁR0] ([termék], [dtól], [dig], [ár]) VALUES (104, CAST(0x91400B00 AS Date), NULL, 2000.0000)
GO
INSERT [dbo].[ÁR0] ([termék], [dtól], [dig], [ár]) VALUES (105, CAST(0x91400B00 AS Date), NULL, 1100.0000)
GO
INSERT [dbo].[ÁR0] ([termék], [dtól], [dig], [ár]) VALUES (106, CAST(0x91400B00 AS Date), NULL, 9500.0000)
GO
SET IDENTITY_INSERT [dbo].[TERMÉK] ON 

GO
INSERT [dbo].[TERMÉK] ([tkód], [elnev], [akt_ár]) VALUES (101, N'szánkó                        ', 2000.0000)
GO
INSERT [dbo].[TERMÉK] ([tkód], [elnev], [akt_ár]) VALUES (103, N'korcsolya                     ', 3000.0000)
GO
INSERT [dbo].[TERMÉK] ([tkód], [elnev], [akt_ár]) VALUES (104, N'sál                           ', 2000.0000)
GO
INSERT [dbo].[TERMÉK] ([tkód], [elnev], [akt_ár]) VALUES (105, N'kesztyû                       ', 1100.0000)
GO
INSERT [dbo].[TERMÉK] ([tkód], [elnev], [akt_ár]) VALUES (106, N'kabát                         ', 9500.0000)
GO
SET IDENTITY_INSERT [dbo].[TERMÉK] OFF
GO
INSERT [dbo].[VÁLT] ([termék], [dig], [régi_ár]) VALUES (101, CAST(0xEA400B00 AS Date), 1500.0000)
GO
INSERT [dbo].[VÁLT] ([termék], [dig], [régi_ár]) VALUES (101, CAST(0xF1400B00 AS Date), 1000.0000)
GO
INSERT [dbo].[VÁLT] ([termék], [dig], [régi_ár]) VALUES (101, CAST(0x09410B00 AS Date), 1500.0000)
GO
INSERT [dbo].[VÁLT] ([termék], [dig], [régi_ár]) VALUES (103, CAST(0x09410B00 AS Date), 2500.0000)
GO
ALTER TABLE [dbo].[ÁR]  WITH CHECK ADD  CONSTRAINT [FK_ÁR_TERMÉK] FOREIGN KEY([termék])
REFERENCES [dbo].[TERMÉK] ([tkód])
GO
ALTER TABLE [dbo].[ÁR] CHECK CONSTRAINT [FK_ÁR_TERMÉK]
GO
ALTER TABLE [dbo].[ÁR0]  WITH CHECK ADD  CONSTRAINT [FK_ÁR0_TERMÉK] FOREIGN KEY([termék])
REFERENCES [dbo].[TERMÉK] ([tkód])
GO
ALTER TABLE [dbo].[ÁR0] CHECK CONSTRAINT [FK_ÁR0_TERMÉK]
GO
ALTER TABLE [dbo].[VÁLT]  WITH CHECK ADD  CONSTRAINT [FK_VÁLT_TERMÉK] FOREIGN KEY([termék])
REFERENCES [dbo].[TERMÉK] ([tkód])
GO
ALTER TABLE [dbo].[VÁLT] CHECK CONSTRAINT [FK_VÁLT_TERMÉK]
GO
USE [master]
GO
ALTER DATABASE [Termékárak] SET  READ_WRITE 
GO