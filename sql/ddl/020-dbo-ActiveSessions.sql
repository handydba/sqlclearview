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

USE [SQLClearview]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ActiveSessions](
	[UtcTimestamp] [datetime] NOT NULL,
	[ServerTimestamp] [datetime] NOT NULL,
	[ServerName] [nvarchar](128) NOT NULL,
	[Sid] [smallint] NULL,
	[LoginName] [nvarchar](128) NOT NULL,
	[HostName] [nvarchar](128) NULL,
	[DatabaseName] [nvarchar](128) NULL,
	[ProgramName] [nvarchar](128) NULL,
	[State] [nvarchar](60) NULL,
	[LoginTime] [datetime] NOT NULL,
	[LastRequestStartTime] [datetime] NOT NULL,
	[Command] [nvarchar](32) NULL,
	[ElapsedSecs] [numeric](17, 6) NULL,
	[OpenTransactionCount] [int] NOT NULL,
	[CpuSecs] [numeric](17, 6) NULL,
	[PhysicalReads] [bigint] NULL,
	[LogicalReads] [bigint] NULL,
	[Writes] [bigint] NULL,
	[RowCount] [bigint] NULL,
	[BlockedObject] [nvarchar](256) NULL,
	[BlockerSid] [smallint] NULL,
	[BlockerLoginName] [nvarchar](128) NULL,
	[BlockerHostName] [nvarchar](128) NULL,
	[SqlText] [nvarchar](max) NULL,
	[SqlQueryPlan] [xml] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
