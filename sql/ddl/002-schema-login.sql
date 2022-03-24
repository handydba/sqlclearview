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
**/

/**
 * Schema
**/

USE [SQLClearView]
GO

/**
 * Schema [ref] for reference data
**/
CREATE SCHEMA [ref]
GO

/**
 * Schema [lts] for long term storage`
**/
CREATE SCHEMA [lts]
GO

/**
 * SQL Server authenticated logins for admin, data collector and Grafana
 * !! CHANGE PASSWORDS !!
**/

USE [master]
GO

CREATE LOGIN [SQLClearview-Admin] WITH PASSWORD=N'xx',
  DEFAULT_DATABASE=[SQLClearview],
  CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO

CREATE LOGIN [SQLClearview-Collector] WITH PASSWORD=N'xx',
  DEFAULT_DATABASE=[master],
  CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO

CREATE LOGIN [SQLClearview-Grafana] WITH PASSWORD=N'xx',
  DEFAULT_DATABASE=[SQLClearview],
  CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO

/**
 * Minimum permissions for collector
**/
GRANT VIEW SERVER STATE TO [SQLClearview-Collector]
GO
GRANT VIEW ANY DEFINITION TO [SQLClearview-Collector]
GO

USE [SQLClearview]
GO

CREATE USER [SQLClearview-Admin] FOR LOGIN [SQLClearview-Admin]
GO
ALTER USER [SQLClearview-Admin] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [SQLClearview-Admin]
GO

/**
 * Grafana (Visualisation) login has read only
**/
CREATE USER [SQLClearview-Grafana] FOR LOGIN [SQLClearview-Grafana]
GO
ALTER USER [SQLClearview-Grafana] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [SQLClearview-Grafana]
GO
