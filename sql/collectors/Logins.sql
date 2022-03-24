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
	, [ServerName] = @@SERVERNAME
	, [LoginName] = sp.name
	, [LoginType] = sp.type_desc
    /**
     * NOTE: password_hash only available to logins with SysAdmin role
     * Column retained for completeness but it's value will always be NULL
    **/
	, [PasswordHash] = sl.password_hash
	, [CreateDate] = sp.create_date
	, [ModifyDate] = sp.modify_date
	, [DefaultDatabaseName] = sp.default_database_name
	, [FlagDisabled] = sp.is_disabled
	, [FlagPolicyChecked] = sl.is_policy_checked
	, [FlagSysadmin] = IS_SRVROLEMEMBER ('sysadmin',sp.name)
FROM
	sys.server_principals sp
LEFT JOIN
	sys.sql_logins sl ON (
		sp.principal_id = sl.principal_id
	)
WHERE
	sp.type not in ('C', 'R')
AND (
  /* Exclude built in logins */
	sp.name NOT LIKE '##%'
	AND sp.name NOT LIKE 'NT %'
  AND sp.name NOT LIKE 'BUILTIN%'
);
