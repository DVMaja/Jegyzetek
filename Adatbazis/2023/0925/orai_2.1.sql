--USE [master]
--GO
--/****** Object:  Database [Term�k�rak]    Script Date: 2021. 01. 24. 19:25:48 ******/
--CREATE DATABASE [Term�k�rak]
-- CONTAINMENT = NONE
-- ON  PRIMARY 
--( NAME = N'Term�k�rak', FILENAME = N'C:\Program Files (x86)\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\Term�k�rak.mdf' , SIZE = 4160KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
-- LOG ON 
--( NAME = N'Term�k�rak_log', FILENAME = N'C:\Program Files (x86)\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\Term�k�rak_log.ldf' , SIZE = 1040KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
--GO
--ALTER DATABASE [Term�k�rak] SET COMPATIBILITY_LEVEL = 110
--GO
--IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
--begin
--EXEC [Term�k�rak].[dbo].[sp_fulltext_database] @action = 'enable'
--end
--GO
--ALTER DATABASE [Term�k�rak] SET ANSI_NULL_DEFAULT OFF 
--GO
--ALTER DATABASE [Term�k�rak] SET ANSI_NULLS OFF 
--GO
--ALTER DATABASE [Term�k�rak] SET ANSI_PADDING OFF 
--GO
--ALTER DATABASE [Term�k�rak] SET ANSI_WARNINGS OFF 
--GO
--ALTER DATABASE [Term�k�rak] SET ARITHABORT OFF 
--GO
--ALTER DATABASE [Term�k�rak] SET AUTO_CLOSE ON 
--GO
--ALTER DATABASE [Term�k�rak] SET AUTO_CREATE_STATISTICS ON 
--GO
--ALTER DATABASE [Term�k�rak] SET AUTO_SHRINK OFF 
--GO
--ALTER DATABASE [Term�k�rak] SET AUTO_UPDATE_STATISTICS ON 
--GO
--ALTER DATABASE [Term�k�rak] SET CURSOR_CLOSE_ON_COMMIT OFF 
--GO
--ALTER DATABASE [Term�k�rak] SET CURSOR_DEFAULT  GLOBAL 
--GO
--ALTER DATABASE [Term�k�rak] SET CONCAT_NULL_YIELDS_NULL OFF 
--GO
--ALTER DATABASE [Term�k�rak] SET NUMERIC_ROUNDABORT OFF 
--GO
--ALTER DATABASE [Term�k�rak] SET QUOTED_IDENTIFIER OFF 
--GO
--ALTER DATABASE [Term�k�rak] SET RECURSIVE_TRIGGERS OFF 
--GO
--ALTER DATABASE [Term�k�rak] SET  ENABLE_BROKER 
--GO
--ALTER DATABASE [Term�k�rak] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
--GO
--ALTER DATABASE [Term�k�rak] SET DATE_CORRELATION_OPTIMIZATION OFF 
--GO
--ALTER DATABASE [Term�k�rak] SET TRUSTWORTHY OFF 
--GO
--ALTER DATABASE [Term�k�rak] SET ALLOW_SNAPSHOT_ISOLATION OFF 
--GO
--ALTER DATABASE [Term�k�rak] SET PARAMETERIZATION SIMPLE 
--GO
--ALTER DATABASE [Term�k�rak] SET READ_COMMITTED_SNAPSHOT OFF 
--GO
--ALTER DATABASE [Term�k�rak] SET HONOR_BROKER_PRIORITY OFF 
--GO
--ALTER DATABASE [Term�k�rak] SET RECOVERY SIMPLE 
--GO
--ALTER DATABASE [Term�k�rak] SET  MULTI_USER 
--GO
--ALTER DATABASE [Term�k�rak] SET PAGE_VERIFY CHECKSUM  
--GO
--ALTER DATABASE [Term�k�rak] SET DB_CHAINING OFF 
--GO
--ALTER DATABASE [Term�k�rak] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
--GO
--ALTER DATABASE [Term�k�rak] SET TARGET_RECOVERY_TIME = 0 SECONDS 
--GO
USE [Term�k�rak]
GO
/****** Object:  UserDefinedFunction [dbo].[term�k�ra0]    Script Date: 2021. 01. 24. 19:25:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[term�k�ra0]
-- ar �R0 t�bl�b�l val� keres�s: adott term�k adott napon mennyibe ker�l
(
	@term�k int,
	@mikor date
)
returns money
as
begin
	-- return (select �r from �R0 where term�k=@term�k and dt�l<=@mikor and dig>=@mikor)
	return (select �r from �R0 where term�k=@term�k and @mikor between dt�l and isnull(dig, getdate()))

end

 --select dbo.term�k�ra0(101,cast('2020-02-17' as date))


GO
/****** Object:  UserDefinedFunction [dbo].[term�k�ra1]    Script Date: 2021. 01. 24. 19:25:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[term�k�ra1]
-- ar �R t�bl�b�l val� keres�s helyett a k�nyelmes n�zetb�l: adott term�k adott napon mennyibe ker�l
(
	@term�k int,
	@mikor date
)
returns money
as
begin
	
	return (select �j_�r from �rlista1 where term�k=@term�k and @mikor between dt�l and isnull(dig, getdate()))

end
 --select dbo.term�k�ra1(101,cast('2020-02-17' as date))

GO
/****** Object:  UserDefinedFunction [dbo].[term�k�ra11]    Script Date: 2021. 01. 24. 19:25:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[term�k�ra11]
-- ar �R t�bl�b�l val� keres�s: adott term�k adott napon mennyibe ker�l
(
	@term�k int,
	@mikor date
)
returns money
as
begin
	declare @datum date
	select @datum=MAX(dt�l) from �R where term�k=@term�k and dt�l<=@mikor
	return (select �j_�r from �R where term�k=@term�k and dt�l=@datum)

end
 --select dbo.term�k�ra11(101,cast('2020-02-17' as date))

GO
/****** Object:  UserDefinedFunction [dbo].[term�k�ra2]    Script Date: 2021. 01. 24. 19:25:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[term�k�ra2]
-- az V�LT t�bl�b�l val� keres�s helyett a k�nyelmes n�zetb�l: adott term�k adott napon mennyibe ker�l
(
	@term�k int,
	@mikor date
)
returns money
as
begin
	return (select �r from �Rlista2 where term�k=@term�k and @mikor between dt�l and dig)

end
 --select dbo.term�k�ra2(101,cast('2020-02-17' as date))

GO
/****** Object:  UserDefinedFunction [dbo].[term�k�ra22]    Script Date: 2021. 01. 24. 19:25:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[term�k�ra22]
-- a V�LT t�bl�s esetben val� keres�s: adott term�k adott napon mennyibe ker�l
(
	@term�k int,
	@mikor date
)
returns money
as
begin
	declare @d�tum date, @vissza money
	select @d�tum=MIN(dig) from v�lt where term�k=@term�k and @mikor<=dig 
	if @d�tum is not null
		select @vissza=r�gi_�r from V�LT where term�k=@term�k and @d�tum=dig
	else
		select @vissza=akt_�r from term�k where tk�d=@term�k
	-- az if v�ge...
	return @vissza
end
 --select dbo.term�k�ra22(101,cast('2020-02-17' as date))

GO
/****** Object:  Table [dbo].[�R]    Script Date: 2021. 01. 24. 19:25:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[�R](
	[term�k] [int] NOT NULL,
	[dt�l] [date] NOT NULL,
	[�j_�r] [money] NULL,
 CONSTRAINT [PK_�R] PRIMARY KEY CLUSTERED 
(
	[term�k] ASC,
	[dt�l] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[�R0]    Script Date: 2021. 01. 24. 19:25:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[�R0](
	[term�k] [int] NOT NULL,
	[dt�l] [date] NOT NULL,
	[dig] [date] NULL,
	[�r] [money] NULL,
 CONSTRAINT [PK_�R0] PRIMARY KEY CLUSTERED 
(
	[term�k] ASC,
	[dt�l] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TERM�K]    Script Date: 2021. 01. 24. 19:25:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TERM�K](
	[tk�d] [int] IDENTITY(101,1) NOT NULL,
	[elnev] [char](30) NOT NULL,
	[akt_�r] [money] NOT NULL,
 CONSTRAINT [PK_TERM�K] PRIMARY KEY CLUSTERED 
(
	[tk�d] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[V�LT]    Script Date: 2021. 01. 24. 19:25:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[V�LT](
	[term�k] [int] NOT NULL,
	[dig] [date] NOT NULL,
	[r�gi_�r] [money] NULL,
 CONSTRAINT [PK_V�LT] PRIMARY KEY CLUSTERED 
(
	[term�k] ASC,
	[dig] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  View [dbo].[�rlista0]    Script Date: 2021. 01. 24. 19:25:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[�rlista0]
as
select * from �r0 

GO
/****** Object:  View [dbo].[�rlista1]    Script Date: 2021. 01. 24. 19:25:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[�rlista1]
as 
-- az �Rb�l egy teljes �rlista
select	term�k, 
		dt�l, 
		(select dateadd(day, -1,MIN(dt�l)) from �r where term�k=K.term�k and dt�l>K.dt�l ) as dig,	
		�j_�r
from �R K

GO
/****** Object:  View [dbo].[�rlista2]    Script Date: 2021. 01. 24. 19:25:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[�rlista2]
as
-- a V�LTb�l egy teljes �rlista
select	term�k, 
		(select isnull(dateadd(day, +1,MAX(dig)), cast('2020-01-02'as date)) from v�lt where term�k=K.term�k and dig<K.dig ) as dt�l,	
		dig,
		r�gi_�r as �r
from V�LT K
UNION
select tk�d, cast('2020-01-02'as date), cast(getdate() as date), akt_�r
from term�k
where tk�d NOT IN (select term�k from v�lt)
UNION
select tk�d, (select dateadd(day,+1,max(dig)) from v�lt where term�k=tk�d), cast(getdate() as date), akt_�r
from term�k
where  tk�d IN (select term�k from v�lt)

GO
INSERT [dbo].[�R] ([term�k], [dt�l], [�j_�r]) VALUES (101, CAST(0x91400B00 AS Date), 1500.0000)
GO
INSERT [dbo].[�R] ([term�k], [dt�l], [�j_�r]) VALUES (101, CAST(0xEB400B00 AS Date), 1000.0000)
GO
INSERT [dbo].[�R] ([term�k], [dt�l], [�j_�r]) VALUES (101, CAST(0xF2400B00 AS Date), 1500.0000)
GO
INSERT [dbo].[�R] ([term�k], [dt�l], [�j_�r]) VALUES (101, CAST(0x0A410B00 AS Date), 2000.0000)
GO
INSERT [dbo].[�R] ([term�k], [dt�l], [�j_�r]) VALUES (103, CAST(0x91400B00 AS Date), 2500.0000)
GO
INSERT [dbo].[�R] ([term�k], [dt�l], [�j_�r]) VALUES (103, CAST(0x0A410B00 AS Date), 3000.0000)
GO
INSERT [dbo].[�R] ([term�k], [dt�l], [�j_�r]) VALUES (104, CAST(0x91400B00 AS Date), 2000.0000)
GO
INSERT [dbo].[�R] ([term�k], [dt�l], [�j_�r]) VALUES (105, CAST(0x91400B00 AS Date), 1100.0000)
GO
INSERT [dbo].[�R] ([term�k], [dt�l], [�j_�r]) VALUES (106, CAST(0x91400B00 AS Date), 9500.0000)
GO
INSERT [dbo].[�R0] ([term�k], [dt�l], [dig], [�r]) VALUES (101, CAST(0x91400B00 AS Date), CAST(0xEA400B00 AS Date), 1500.0000)
GO
INSERT [dbo].[�R0] ([term�k], [dt�l], [dig], [�r]) VALUES (101, CAST(0xEB400B00 AS Date), CAST(0xF1400B00 AS Date), 1000.0000)
GO
INSERT [dbo].[�R0] ([term�k], [dt�l], [dig], [�r]) VALUES (101, CAST(0xF2400B00 AS Date), CAST(0x09410B00 AS Date), 1500.0000)
GO
INSERT [dbo].[�R0] ([term�k], [dt�l], [dig], [�r]) VALUES (101, CAST(0x0A410B00 AS Date), NULL, 2000.0000)
GO
INSERT [dbo].[�R0] ([term�k], [dt�l], [dig], [�r]) VALUES (103, CAST(0x91400B00 AS Date), CAST(0x09410B00 AS Date), 2500.0000)
GO
INSERT [dbo].[�R0] ([term�k], [dt�l], [dig], [�r]) VALUES (103, CAST(0x0A410B00 AS Date), NULL, 3000.0000)
GO
INSERT [dbo].[�R0] ([term�k], [dt�l], [dig], [�r]) VALUES (104, CAST(0x91400B00 AS Date), NULL, 2000.0000)
GO
INSERT [dbo].[�R0] ([term�k], [dt�l], [dig], [�r]) VALUES (105, CAST(0x91400B00 AS Date), NULL, 1100.0000)
GO
INSERT [dbo].[�R0] ([term�k], [dt�l], [dig], [�r]) VALUES (106, CAST(0x91400B00 AS Date), NULL, 9500.0000)
GO
SET IDENTITY_INSERT [dbo].[TERM�K] ON 

GO
INSERT [dbo].[TERM�K] ([tk�d], [elnev], [akt_�r]) VALUES (101, N'sz�nk�                        ', 2000.0000)
GO
INSERT [dbo].[TERM�K] ([tk�d], [elnev], [akt_�r]) VALUES (103, N'korcsolya                     ', 3000.0000)
GO
INSERT [dbo].[TERM�K] ([tk�d], [elnev], [akt_�r]) VALUES (104, N's�l                           ', 2000.0000)
GO
INSERT [dbo].[TERM�K] ([tk�d], [elnev], [akt_�r]) VALUES (105, N'keszty�                       ', 1100.0000)
GO
INSERT [dbo].[TERM�K] ([tk�d], [elnev], [akt_�r]) VALUES (106, N'kab�t                         ', 9500.0000)
GO
SET IDENTITY_INSERT [dbo].[TERM�K] OFF
GO
INSERT [dbo].[V�LT] ([term�k], [dig], [r�gi_�r]) VALUES (101, CAST(0xEA400B00 AS Date), 1500.0000)
GO
INSERT [dbo].[V�LT] ([term�k], [dig], [r�gi_�r]) VALUES (101, CAST(0xF1400B00 AS Date), 1000.0000)
GO
INSERT [dbo].[V�LT] ([term�k], [dig], [r�gi_�r]) VALUES (101, CAST(0x09410B00 AS Date), 1500.0000)
GO
INSERT [dbo].[V�LT] ([term�k], [dig], [r�gi_�r]) VALUES (103, CAST(0x09410B00 AS Date), 2500.0000)
GO
ALTER TABLE [dbo].[�R]  WITH CHECK ADD  CONSTRAINT [FK_�R_TERM�K] FOREIGN KEY([term�k])
REFERENCES [dbo].[TERM�K] ([tk�d])
GO
ALTER TABLE [dbo].[�R] CHECK CONSTRAINT [FK_�R_TERM�K]
GO
ALTER TABLE [dbo].[�R0]  WITH CHECK ADD  CONSTRAINT [FK_�R0_TERM�K] FOREIGN KEY([term�k])
REFERENCES [dbo].[TERM�K] ([tk�d])
GO
ALTER TABLE [dbo].[�R0] CHECK CONSTRAINT [FK_�R0_TERM�K]
GO
ALTER TABLE [dbo].[V�LT]  WITH CHECK ADD  CONSTRAINT [FK_V�LT_TERM�K] FOREIGN KEY([term�k])
REFERENCES [dbo].[TERM�K] ([tk�d])
GO
ALTER TABLE [dbo].[V�LT] CHECK CONSTRAINT [FK_V�LT_TERM�K]
GO
USE [master]
GO
ALTER DATABASE [Term�k�rak] SET  READ_WRITE 
GO