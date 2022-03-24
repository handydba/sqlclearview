/**
 * Copyright 2022 Alan Jeskins-Powell
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
**/

USE [master]
GO

CREATE DATABASE [SQLClearview]
 CONTAINMENT = NONE
 ON PRIMARY
( NAME = N'SQLClearview', FILENAME = N'/var/opt/mssql/data/SQLClearview.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON
( NAME = N'SQLClearview_log', FILENAME = N'/var/opt/mssql/data/SQLClearview_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO

/**
 * Options below are default for a 2019 installation on Linux
 *
**/
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [SQLClearview].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO

ALTER DATABASE [SQLClearview] SET ANSI_NULL_DEFAULT OFF
GO

ALTER DATABASE [SQLClearview] SET ANSI_NULLS OFF
GO

ALTER DATABASE [SQLClearview] SET ANSI_PADDING OFF
GO

ALTER DATABASE [SQLClearview] SET ANSI_WARNINGS OFF
GO

ALTER DATABASE [SQLClearview] SET ARITHABORT OFF
GO

ALTER DATABASE [SQLClearview] SET AUTO_CLOSE ON
GO

ALTER DATABASE [SQLClearview] SET AUTO_SHRINK OFF
GO

ALTER DATABASE [SQLClearview] SET AUTO_UPDATE_STATISTICS ON
GO

ALTER DATABASE [SQLClearview] SET CURSOR_CLOSE_ON_COMMIT OFF
GO

ALTER DATABASE [SQLClearview] SET CURSOR_DEFAULT  GLOBAL
GO

ALTER DATABASE [SQLClearview] SET CONCAT_NULL_YIELDS_NULL OFF
GO

ALTER DATABASE [SQLClearview] SET NUMERIC_ROUNDABORT OFF
GO

ALTER DATABASE [SQLClearview] SET QUOTED_IDENTIFIER OFF
GO

ALTER DATABASE [SQLClearview] SET RECURSIVE_TRIGGERS OFF
GO

ALTER DATABASE [SQLClearview] SET  ENABLE_BROKER
GO

ALTER DATABASE [SQLClearview] SET AUTO_UPDATE_STATISTICS_ASYNC OFF
GO

ALTER DATABASE [SQLClearview] SET DATE_CORRELATION_OPTIMIZATION OFF
GO

ALTER DATABASE [SQLClearview] SET TRUSTWORTHY OFF
GO

ALTER DATABASE [SQLClearview] SET ALLOW_SNAPSHOT_ISOLATION OFF
GO

ALTER DATABASE [SQLClearview] SET PARAMETERIZATION SIMPLE
GO

ALTER DATABASE [SQLClearview] SET READ_COMMITTED_SNAPSHOT OFF
GO

ALTER DATABASE [SQLClearview] SET HONOR_BROKER_PRIORITY OFF
GO

ALTER DATABASE [SQLClearview] SET RECOVERY FULL
GO

ALTER DATABASE [SQLClearview] SET  MULTI_USER
GO

ALTER DATABASE [SQLClearview] SET PAGE_VERIFY CHECKSUM
GO

ALTER DATABASE [SQLClearview] SET DB_CHAINING OFF
GO

ALTER DATABASE [SQLClearview] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF )
GO

ALTER DATABASE [SQLClearview] SET TARGET_RECOVERY_TIME = 60 SECONDS
GO

ALTER DATABASE [SQLClearview] SET DELAYED_DURABILITY = DISABLED
GO

ALTER DATABASE [SQLClearview] SET ACCELERATED_DATABASE_RECOVERY = OFF
GO

ALTER DATABASE [SQLClearview] SET QUERY_STORE = OFF
GO

ALTER DATABASE [SQLClearview] SET  READ_WRITE
GO
