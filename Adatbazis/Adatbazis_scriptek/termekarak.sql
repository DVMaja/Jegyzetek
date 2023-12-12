USE [master]
GO

/****** Object:  Database [Termékárak]    Script Date: 2023. 11. 07. 8:04:28 ******/
CREATE DATABASE [Termékárak]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Termékárak', FILENAME = N'/var/opt/mssql/data/Termékárak.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Termékárak_log', FILENAME = N'/var/opt/mssql/data/Termékárak_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO

IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Termékárak].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO

ALTER DATABASE [Termékárak] SET ANSI_NULL_DEFAULT OFF 
GO

ALTER DATABASE [Termékárak] SET ANSI_NULLS OFF 
GO

ALTER DATABASE [Termékárak] SET ANSI_PADDING OFF 
GO

ALTER DATABASE [Termékárak] SET ANSI_WARNINGS OFF 
GO

ALTER DATABASE [Termékárak] SET ARITHABORT OFF 
GO

ALTER DATABASE [Termékárak] SET AUTO_CLOSE OFF 
GO

ALTER DATABASE [Termékárak] SET AUTO_SHRINK OFF 
GO

ALTER DATABASE [Termékárak] SET AUTO_UPDATE_STATISTICS ON 
GO

ALTER DATABASE [Termékárak] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO

ALTER DATABASE [Termékárak] SET CURSOR_DEFAULT  GLOBAL 
GO

ALTER DATABASE [Termékárak] SET CONCAT_NULL_YIELDS_NULL OFF 
GO

ALTER DATABASE [Termékárak] SET NUMERIC_ROUNDABORT OFF 
GO

ALTER DATABASE [Termékárak] SET QUOTED_IDENTIFIER OFF 
GO

ALTER DATABASE [Termékárak] SET RECURSIVE_TRIGGERS OFF 
GO

ALTER DATABASE [Termékárak] SET  ENABLE_BROKER 
GO

ALTER DATABASE [Termékárak] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO

ALTER DATABASE [Termékárak] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO

ALTER DATABASE [Termékárak] SET TRUSTWORTHY OFF 
GO

ALTER DATABASE [Termékárak] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO

ALTER DATABASE [Termékárak] SET PARAMETERIZATION SIMPLE 
GO

ALTER DATABASE [Termékárak] SET READ_COMMITTED_SNAPSHOT OFF 
GO

ALTER DATABASE [Termékárak] SET HONOR_BROKER_PRIORITY OFF 
GO

ALTER DATABASE [Termékárak] SET RECOVERY FULL 
GO

ALTER DATABASE [Termékárak] SET  MULTI_USER 
GO

ALTER DATABASE [Termékárak] SET PAGE_VERIFY CHECKSUM  
GO

ALTER DATABASE [Termékárak] SET DB_CHAINING OFF 
GO

ALTER DATABASE [Termékárak] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO

ALTER DATABASE [Termékárak] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO

ALTER DATABASE [Termékárak] SET DELAYED_DURABILITY = DISABLED 
GO

ALTER DATABASE [Termékárak] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO

ALTER DATABASE [Termékárak] SET QUERY_STORE = OFF
GO

ALTER DATABASE [Termékárak] SET  READ_WRITE 
GO

