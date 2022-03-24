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
 * Only captures usage for disk containing database files
**/

DECLARE @UtcTimestamp datetime, @ServerTimestamp datetime
/* Set these early so they remain constant for duration of query */
SELECT @UtcTimestamp = GetUTCDate(), @ServerTimestamp = SYSDATETIMEOFFSET();

;WITH cteDisk as (
SELECT DISTINCT
    [DiskLetter] = CASE ISNULL( ovs.volume_mount_point, '' )
    WHEN '' THEN /* Linux */
      '/' /* TODO: Need to do better than this !! */
    ELSE /* Windows */
      SUBSTRING( CONVERT(varchar(512), ovs.volume_mount_point), 1, 1 )
    END
  , [DiskLogicalName] = ISNULL( CONVERT(varchar(512), ovs.logical_volume_name), 'Linux FS' )
  , [Free%] = CAST( 100.0 * ovs.available_bytes / ovs.total_bytes AS DECIMAL(5, 2) )
  , [FreeMb] = ROUND( CAST( 1.0 * ovs.available_bytes / 1048576 AS float ), 0 )
  , [TotalMb] = ROUND( CAST( 1.0 * ovs.total_bytes / 1048576 AS float ), 0 )
from sys.master_files mf
CROSS APPLY sys.dm_os_volume_stats(mf.database_id, mf.[file_id]) ovs
)
SELECT
    [UtcTimestamp] = @UtcTimestamp
	, [ServerTimestamp] = @ServerTimestamp
	, [ServerName] = @@SERVERNAME
  , cteDisk.*
FROM
	cteDisk
