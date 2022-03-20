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
 * Credits
 * Inspired by AppDynamics SQL I saw running once, modified to include blocking
 * details, query text and plan
**/

DECLARE @UtcTimestamp datetime, @ServerTimestamp datetime
/* Set these early so they remain constant for duration of query */
SELECT @UtcTimestamp = GetUTCDate(), @ServerTimestamp = SYSDATETIMEOFFSET()

;WITH cte as (
  SELECT
    -- Session details
      [Sid] = der.session_id
    , [LoginName] = des.login_name
    , [HostName] = des.host_name
    , [DatabaseName] = db_name( der.database_id )
    , [ProgramName] = des.program_name
    -- der.status, -- running, suspended, etc
    , [State] = CASE
      WHEN der.wait_type IS NULL THEN 'USING CPU (not waiting)'
      ELSE der.last_wait_type
      END
    , [LoginTime] = des.login_time
    , [LastRequestStartTime] = des.last_request_start_time
    -- Activity details
    , [Command] = der.command
    , [ElapsedSecs] = round(der.total_elapsed_time/1000.0,4)
    -- [Alt ElapssedSecs] = datediff(ss,des.last_request_start_time,getdate())
    , [OpenTransactionCount] = des.open_transaction_count
    , [CpuSecs] = round(der.cpu_time/1000.0,4)
    , [PhysicalReads] = der.reads
    , [LogicalReads] = der.logical_reads
    , [Writes] = der.writes
    , [RowCount] = der.row_count
    -- If blocked, blocker details
    , [BlockedObject] = der.wait_resource
    , [BlockerSid] = der.blocking_session_id
    , [BlockerLoginName] = des_blocker.login_name
    , [BlockerHostName] = des_blocker.host_name
    , [SqlText] = dest.text
		, [SqlQueryPlan] = CONVERT(XML, detqp.query_plan)
  FROM
    sys.dm_exec_sessions des
  LEFT OUTER JOIN ( sys.dm_exec_requests AS der
    LEFT OUTER JOIN sys.dm_exec_sessions AS des_blocker ON
      der.blocking_session_id = des_blocker.session_id
    ) ON  des.session_id = der.session_id
  CROSS APPLY sys.dm_exec_sql_text(der.sql_handle) AS dest
	OUTER APPLY sys.dm_exec_text_query_plan (
      der.plan_handle
    , der.statement_start_offset
    , der.statement_end_offset
  ) detqp
  WHERE UPPER( der.command ) <> 'AWAITING COMMAND'
  AND der.sql_handle is not null
  AND der.sql_handle <> 0x000000000000000000000000000000000000000000000000
  AND der.session_id <> @@SPID
)
SELECT
    [UtcTimestamp] = @UtcTimestamp
  , [ServerTimestamp] = @ServerTimestamp
  , [ServerName] = @@SERVERNAME
  , cte.*
FROM
  cte
