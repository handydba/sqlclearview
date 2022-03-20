# SQL Clearview

### Menu

- [Features](#features)
- [Install](#install)
- [About](#about)

## Features

- Agentless data collection from SQL Servers instances into a central repository.
- Uses freely available tools.
- Lightweight, collecting data from 60+ instances completes in ~1 minute.
- Exception reporting.
- Visualisation on common dashboard.

## Install

- Install [DBATools](https://dbatools.io)
- Clone this repository
- Update schema-login with credentials
  SQLClearview uses 3 logins, same or separate credentials for each.
  Windows authenticated accounts would be preferred, scripts are configured for
  SQL Server authentication.
- Execute the scripts in sql/ddl.
- Populate Servers and ServerCollections tables with data (see examples in DDL)
- Update Set-SqlCVEnvironment.ps1 - pay particular attention to collector credentials.
  ~~~
  # Create encrypted string
  . H:\sqlclearview\bin\New-StringEncryption.ps1
  New-StringEncryption -StringToEncrypt 'Password123'
  # Output string - paste this into Set-SqlCVEnvironment.ps1
  CAmXApDmUtCFJGYdY1A6ag==
  ~~~
  *Note: the encrypted string can only be decrypted on the same machine that performed the encryption.*
- Start collecting data, e.g.
  ~~~
  PS> H:\sqlclearview\bin\Get-SqlCVData.ps1 ActiveSessions
  ~~~
  Collections can easily be scheduled as SQL Server agent jobs.

Note that the default install expects a [SQLClearview-Collector] login on both the
central repository and client servers. The simplest way to set that up is to use
DBATools to copy the login from the central repository to the server(s) you want to monitor.
~~~
PS> Copy-DbaLogin -Source sql1 -Destination sql2,sql3 -Login "SQLClearview-Collector" -force
~~~

## About

SQL Clearview is a project by Alan Jeskins-Powell and [252 Digital UK](https://252.uk)
