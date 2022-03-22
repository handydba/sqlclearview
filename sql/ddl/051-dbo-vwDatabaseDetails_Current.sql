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

CREATE VIEW dbo.vwDatabaseDetails_Current
AS
WITH cteCurrent AS (
    SELECT
          [ServerName]
        , [UtcTimestamp] = MAX([UtcTimestamp])
    FROM
        [SQLClearview].[dbo].[DatabaseDetails] WITH (NOLOCK)
    GROUP BY
        [ServerName]
)
SELECT
      dd.[UtcTimestamp]
    , dd.[ServerTimestamp]
    , dd.[ServerName]
    , dd.[DatabaseId]
    , dd.[DatabaseName]
    , dd.[OwnerLogin]
    , dd.[Status]
    , dd.[NumDatafiles]
    , dd.[DatafileMb]
    , dd.[NumLogfiles]
    , dd.[LogfileMb]
    , dd.[UserAccess]
    , dd.[RecoveryModel]
    , dd.[CompatibilityLevel]
    , dd.[CreateDate]
    , dd.[LastDatabaseBackup]
    , dd.[LastLogBackup]
    , dd.[PageVerifyOption]
    , dd.[FlagFullTextEnabled]
    , dd.[FlagAutoCloseOn]
    , dd.[FlagReadOnly]
    , dd.[FlagAutoShrinkOn]
    , dd.[FlagAutoCreateStatsOn]
    , dd.[FlagAutoUpdateStatsOn]
    , dd.[FlagInStandby]
    , dd.[FlagCleanlyShutdown]
FROM
    cteCurrent
JOIN
    [SQLClearview].[dbo].[DatabaseDetails] dd WITH (NOLOCK) ON (
        dd.[ServerName] = cteCurrent.[ServerName]
    AND dd.[UtcTimestamp] = cteCurrent.[UtcTimestamp]
  );
