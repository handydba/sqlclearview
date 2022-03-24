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

WITH WinInfo AS (
	  SELECT *
		FROM sys.dm_os_windows_info
)
SELECT
    [UtcTimestamp] = @UtcTimestamp
  , [ServerTimestamp] = @ServerTimestamp
  , [ServerName] = @@SERVERNAME
	-- Note: This is only populated for TCP connections to the server
  , [IpAddress] = CAST(CONNECTIONPROPERTY('local_net_address') AS [nvarchar](512))
	-- Note: NULL for default instance
  , [InstanceName] = CAST(SERVERPROPERTY('instancename') AS [nvarchar](512))
	, [Edition] =  CAST(SERVERPROPERTY('edition') AS [nvarchar](512))
	-- Version = major.minor.build.revision
	, [Version] = CAST(SERVERPROPERTY('productversion') AS [nvarchar](512))
	, [VersionString] = @@VERSION
 -- redefined cpu columns for compatibility with older versions
	, [SocketCount] =  cpu_count / hyperthread_ratio
	, [CoresPerSocket] = hyperthread_ratio
 -- In SQL Server 2008 R2 this column is physical_memory_in_bytes
	, [MemoryMB] = physical_memory_kb/1024
	, [WindowsRelease] = WI.windows_release
	, [WindowsSPLevel] = WI.windows_service_pack_level
	, [WindowsSKU] = WI.windows_sku
	-- , [NumaNodeCount] = 1
  -- , cast(serverproperty('machinename') as varchar(80)) as svrid
  -- , CONNECTIONPROPERTY('net_transport') AS net_transport
  -- , CONNECTIONPROPERTY('protocol_type') AS protocol_type
  -- , CONNECTIONPROPERTY('auth_scheme') AS auth_scheme
  -- , CONNECTIONPROPERTY('local_tcp_port') AS local_tcp_port
  --  CONNECTIONPROPERTY('client_net_address') AS client_net_address
FROM
	sys.dm_os_sys_info
JOIN WinInfo WI on 1=1
