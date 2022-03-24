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

CREATE VIEW dbo.vwDiskUsage_Current
AS
WITH cteCurrent AS (
    SELECT
          [ServerName]
        , [UtcTimestamp] = MAX([UtcTimestamp])
    FROM
        [SQLClearview].[dbo].[DiskUsage]
    GROUP BY
        [ServerName]
)
SELECT
      du.[UtcTimestamp]
    , du.[ServerTimestamp]
    , du.[ServerName]
    , du.[DiskLetter]
    , du.[DiskLogicalName]
    , du.[Free%]
    , du.[FreeMb]
    , du.[TotalMb]
FROM
    cteCurrent
JOIN
    [SQLClearview].[dbo].[DiskUsage] du ON (
        du.[ServerName] = cteCurrent.[ServerName]
    AND du.[UtcTimestamp] = cteCurrent.[UtcTimestamp]
	);
