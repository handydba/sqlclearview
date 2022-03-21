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

CREATE VIEW dbo.vwServerDetails_Current
AS
WITH cteCurrent AS (
    SELECT
          [ServerName]
        , [UtcTimestamp] = MAX([UtcTimestamp])
    FROM
        [SQLClearview].[dbo].[ServerDetails]
    GROUP BY
        [ServerName]
)
SELECT
      sd.[UtcTimestamp]
    , sd.[ServerTimestamp]
    , sd.[ServerName]
    , sd.[IpAddress]
    , sd.[InstanceName]
    , sd.[Edition]
    , sd.[Version]
    , sd.[VersionString]
    , sd.[SocketCount]
    , sd.[CoresPerSocket]
    , sd.[MemoryMB]
    , sd.[WindowsRelease]
    , sd.[WindowsSPLevel]
    , sd.[WindowsSKU]
FROM
    cteCurrent
JOIN
    [SQLClearview].[dbo].[ServerDetails] sd ON (
        sd.[ServerName] = cteCurrent.[ServerName]
    AND sd.[UtcTimestamp] = cteCurrent.[UtcTimestamp]
	);
