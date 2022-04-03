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

DECLARE @UtcTimestamp datetime, @ServerTimestamp datetime
/* Set these early so they remain constant for duration of query */
SELECT @UtcTimestamp = GetUTCDate(), @ServerTimestamp = SYSDATETIMEOFFSET();

SELECT
    [UtcTimestamp] = @UtcTimestamp
  , [ServerTimestamp] = @ServerTimestamp
  , [ServerName] = @@ServerName
	, [DatabaseName] = bset.database_name
	, [PhysicalDeviceName] = bmed.physical_device_name
	, [BackupSetId] = bset.backup_set_id
	, [BackupSetName] = bset.name
	, [BackupType] = CASE bset.type
  	WHEN 'D' then 'Full'
  	WHEN 'I' then 'Incr'
  	WHEN 'L' then 'TLog'
  	ELSE bset.type
    END
	, [BackupStartDate] = bset.backup_start_date
	, [BackupFinishDate] = bset.backup_finish_date
	, [BackupSize] = bset.backup_size
	, [SQLServerMajorVersion] = bset.software_major_version
	, [SQLServerMinorVersion] = bset.software_minor_version
	, [SQLServerBuildVersion] = bset.software_build_version
	, [DatabaseCompatibilityLevel] = bset.compatibility_level
	, [DatabaseVersion] = bset.database_version
FROM
  msdb.dbo.backupset bset
  -- 1:N
JOIN msdb.dbo.backupmediafamily bmed ON (
	bmed.media_set_id = bset.media_set_id
	    -- only first row from media family, e.g. Idera SQLsafe generates 3 or more mediafamily rows per backupset
	AND bmed.family_sequence_number = 1
)
WHERE
    bset.backup_start_date >= dateadd(day,datediff(day,1,GETDATE()),0) /*  >= 00:00:00 yesterday */
AND bset.backup_start_date <  dateadd(day,datediff(day,0,GETDATE()),0) /*  < 00:00:00 today */
AND bset.database_name not in ('master','model','msdb')
