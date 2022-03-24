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
	, [ConfigurationId] = configuration_id
	, [OptionName] = name
	, [OptionDescription] = description
	, [MinimumValue] = CAST( minimum AS bigint )
	, [MaximumValue] = CAST( maximum AS bigint )
	, [Value] = CAST( value AS bigint )
	, [ValueInUse] = CAST( value_in_use AS bigint )
	, [IsDynamic] = is_dynamic
	, [IsAdvanced] = is_advanced
FROM
  sys.configurations ;
