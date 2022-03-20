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
 * Definitions of collections
 * [CollectionName] typically matches the collection SQL file name
**/
CREATE TABLE [ref].[Collections] (
  [CollectionName] nvarchar(50) NOT NULL,
  [Description] nvarchar(1024) NOT NULL,
  CONSTRAINT Collections_PK PRIMARY KEY ([CollectionName])
) ON [PRIMARY]
GO

INSERT INTO [ref].[Collections] (
  [CollectionName],
  [Description]
) VALUES (
  'ActiveSessions', 'Active sessions'
) ;
