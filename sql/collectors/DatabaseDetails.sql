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
 * Credits:
 * Based on: https://blog.sqlauthority.com/2010/11/12/sql-server-get-all-the-information-of-database-using-sys-databases/
**/

DECLARE @UtcTimestamp datetime, @ServerTimestamp datetime
/* Set these early so they remain constant for duration of query */
SELECT @UtcTimestamp = GetUTCDate(), @ServerTimestamp = SYSDATETIMEOFFSET();

SELECT
    [UtcTimestamp] = @UtcTimestamp
	, [ServerTimestamp] = @ServerTimestamp
	, [ServerName] = @@SERVERNAME
	, [DatabaseId] = database_id
	, [DatabaseName] = CONVERT(VARCHAR(256), DB.name)
  , [OwnerLogin] = SUSER_sname(owner_sid)
	, [Status] = CONVERT(VARCHAR(10), DATABASEPROPERTYEX(name, 'status'))
	-- ,state_desc
	, [NumDatafiles] = (SELECT COUNT(1) FROM sys.master_files WHERE DB_NAME(database_id) = DB.name AND type_desc = 'rows')
	, [DatafileMb] = (SELECT SUM((size*8)/1024) FROM sys.master_files WHERE DB_NAME(database_id) = DB.name AND type_desc = 'rows')
	, [NumLogfiles] = (SELECT COUNT(1) FROM sys.master_files WHERE DB_NAME(database_id) = DB.name AND type_desc = 'log')
	, [LogfileMb] = (SELECT SUM((size*8)/1024) FROM sys.master_files WHERE DB_NAME(database_id) = DB.name AND type_desc = 'log')
	, [UserAccess] = user_access_desc
	, [RecoveryModel] = recovery_model_desc
	, [CompatibilityLevel] = CASE compatibility_level
		/* of little use, for information only:
		WHEN 60 THEN '60 (SQL Server 6.0)'
		WHEN 65 THEN '65 (SQL Server 6.5)'
		WHEN 70 THEN '70 (SQL Server 7.0)'
		WHEN 80 THEN '80 (SQL Server 2000)'
		WHEN 90 THEN '90 (SQL Server 2005)'
		*/
		WHEN 100 THEN '100 (SQL Server 2008 or 2008R2)'
		WHEN 110 THEN '110 (SQL Server 2012 )'
		WHEN 120 THEN '120 (SQL Server 2014)'
		WHEN 130 THEN '130 (SQL Server 2016)'
		WHEN 140 THEN '140 (SQL Server 2017)'
		WHEN 150 THEN '150 (SQL Server 2019)'
		ELSE cast(compatibility_level as varchar(20))
	  END
	, [CreateDate] = create_date
	, [LastDatabaseBackup] = (
		 SELECT TOP 1 backup_start_date
		 FROM msdb..backupset BK
		 WHERE BK.database_name = DB.name
		 AND ( type = 'D' or type = 'I' )
		 ORDER BY backup_set_id DESC
	  )
	, [LastLogBackup] = (
		 SELECT TOP 1 backup_start_date
		 FROM msdb..backupset BK
		 WHERE BK.database_name = DB.name
		 AND type = 'L'
		 ORDER BY backup_set_id DESC
	  )
	, [PageVerifyOption] = page_verify_option_desc
	, [FlagFullTextEnabled] = is_fulltext_enabled
	, [FlagAutoCloseOn] = is_auto_close_on
	, [FlagReadOnly] = is_read_only
	, [FlagAutoShrinkOn] = is_auto_shrink_on
	, [FlagAutoCreateStatsOn] = is_auto_create_stats_on
	, [FlagAutoUpdateStatsOn] = is_auto_update_stats_on
	, [FlagInStandby] = is_in_standby
	, [FlagCleanlyShutdown] = is_cleanly_shutdown
FROM
  sys.databases DB
