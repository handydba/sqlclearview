/**
 * Copyright 2022 Alan Jeskins-Powell
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http: *www.apache.org/licenses/LICENSE-2.0
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

-- SQLClearview.dbo.DatabaseDetails definition

-- Drop table

-- DROP TABLE SQLClearview.dbo.DatabaseDetails;

CREATE TABLE SQLClearview.dbo.DatabaseDetails (
	[UtcTimestamp] datetime NOT NULL,
	[ServerTimestamp] datetime NOT NULL,
	[ServerName] nvarchar(128) NOT NULL,
	[DatabaseId] int NOT NULL,
	[DatabaseName] nvarchar(256) NOT NULL,
	[OwnerLogin] nvarchar(128) NULL,
	[Status] nvarchar(10) NULL,
	[NumDatafiles] int NULL,
	[DatafileMb] int NULL,
	[NumLogfiles] int NULL,
	[LogfileMb] int NULL,
	[UserAccess] nvarchar(60) NULL,
	[RecoveryModel] nvarchar(60) NULL,
	[CompatibilityLevel] nvarchar(31) NULL,
	[CreateDate] datetime NOT NULL,
	[LastDatabaseBackup] datetime NULL,
	[LastLogBackup] datetime NULL,
	[PageVerifyOption] nvarchar(60) NULL,
	[FlagFullTextEnabled] bit NULL,
	[FlagAutoCloseOn] bit NOT NULL,
	[FlagReadOnly] bit NULL,
	[FlagAutoShrinkOn] bit NULL,
	[FlagAutoCreateStatsOn] bit NULL,
	[FlagAutoUpdateStatsOn] bit NULL,
	[FlagInStandby] bit NULL,
	[FlagCleanlyShutdown] bit NULL
);
