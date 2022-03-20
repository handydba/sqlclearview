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
**/

USE [SQLClearview]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/**
 * Definitions of servers
 * A simple table which drives the data collections,
 * see ServerCollections which defines which collections apply to servers
 * See also the ServerDetails collector
**/
CREATE TABLE [ref].[Servers] (
  [ServerName] [nvarchar](128) NOT NULL,
  /* IP Address is used by collector to avoid DNS lookup errors */
  [IpAddress] [nvarchar](45) NOT NULL,
  CONSTRAINT Servers_PK PRIMARY KEY ([ServerName])
) ON [PRIMARY]
GO

INSERT INTO [ref].[Servers] (
  [ServerName]
) VALUES (
  'sql1'
) ;
