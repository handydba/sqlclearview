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
 *
**/

USE [SQLClearview]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- SQLClearview.dbo.DatabaseBackupHistory definition

-- Drop table

-- DROP TABLE SQLClearview.dbo.DatabaseBackupHistory;

CREATE TABLE SQLClearview.dbo.DatabaseBackupHistory (
	[UtcTimestamp] datetime NOT NULL,
	[ServerTimestamp] datetime NOT NULL,
	[ServerName] nvarchar(128) NOT NULL,
	[DatabaseName] nvarchar(12) NOT NULL,
	[PhysicalDeviceName] nvarchar(260) NULL,
	[BackupSetId] int NULL,
	[BackupSetName] nvarchar(128) NULL,
	[BackupType] varchar(4) NULL,
	[BackupStartDate] datetime NULL,
	[BackupFinishDate] datetime NULL,
	[BackupSize] numeric(20,0) NULL,
	[SQLServerMajorVersion] tinyint NULL,
	[SQLServerMinorVersion] tinyint NULL,
	[SQLServerBuildVersion] smallint NULL,
	[DatabaseCompatibilityLevel] tinyint NULL,
	[DatabaseVersion] int NULL
);
