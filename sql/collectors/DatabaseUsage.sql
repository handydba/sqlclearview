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
 *  See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * Note:
 * Default, only captures usage for online databases
**/


DECLARE @UtcTimestamp datetime, @ServerTimestamp datetime
/* Set these early so they remain constant for duration of query */
SELECT @UtcTimestamp = GetUTCDate(), @ServerTimestamp = SYSDATETIMEOFFSET();

DECLARE @SQL nvarchar(max)

CREATE TABLE #tempFileInformation (
	[DatabaseName] nvarchar(12) NOT NULL,
	[LogicalFileName] nvarchar(128) NOT NULL,
	[PhysicalFileName] nvarchar(260) NOT NULL,
	[FileType] nvarchar(60) NULL,
	[FileState] nvarchar(60) NULL,
	[Filegroup] nvarchar(128) NULL,
	[FilesizeMb] decimal(10,2) NULL,
	[UsedMb] decimal(10,2) NULL,
	[FreeMb] decimal(10,2) NULL,
	[ActualFree%] decimal(10,2) NULL,
	[Autogrow] nvarchar(8) NOT NULL,
	[AutoGrow%] int NOT NULL,
	[AutogrowMb] int NULL,
	[AutogrowMaxsizeMb] int NULL
);

SELECT @SQL = '
USE [?]
INSERT INTO #tempFileInformation
SELECT
   [DatabaseName]=DB_NAME()
  ,[LogicalFileName]=df.name
  ,[PhysicalFileName]=df.physical_name
  ,[FileType]=df.type_desc
  ,[FileState]=df.state_desc
  ,[Filegroup]=ISNULL(fg.name,df.type_desc)
  ,[FilesizeMb]=CONVERT(DECIMAL(10,2),df.size/128.0)
  ,[UsedMb] = CONVERT(DECIMAL(10,2),df.size/128.0 - ((SIZE/128.0) - CAST(FILEPROPERTY(df.name, ''SPACEUSED'') AS INT)/128.0))
  ,[FreeMb] = CONVERT(DECIMAL(10,2),df.size/128.0 - CAST(FILEPROPERTY(df.name, ''SPACEUSED'') AS INT)/128.0)
  ,[ActualFree%] = CONVERT(DECIMAL(10,2),((df.size/128.0 - CAST(FILEPROPERTY(df.name, ''SPACEUSED'') AS INT)/128.0)/(df.SIZE/128.0))*100)
  ,[Autogrow] = CASE growth when 0 THEN ''Disabled'' else ''Enabled'' end
  ,[AutoGrow%] = CASE is_percent_growth WHEN 1 then growth else 0 end
  ,[AutogrowMb] = CASE is_percent_growth WHEN 0 THEN growth/128 else 0 end
  ,[AutogrowMaxsizeMb] = CASE growth WHEN 0 THEN 0 ELSE CASE max_size WHEN -1 THEN 2097152 ELSE max_size/128 END END
FROM sys.database_files df
LEFT JOIN sys.filegroups fg ON ( fg.data_space_id = df.data_space_id )' ;

/**
 * Don't really like using the undocumented sp_MSforeachdb but it is the only way that
 * the query will work as FILEPROPERTY only returns values for the current database
**/

EXEC sp_MSforeachdb @SQL
;

SELECT
    [UtcTimestamp] = @UtcTimestamp
	, [ServerTimestamp] = @ServerTimestamp
	, [ServerName] = @@SERVERNAME
  , fg.*
FROM #tempFileInformation fg ;

DROP TABLE #tempFileInformation ;
