<#
.SYNOPSIS
Load data into SQLClearview database

.DESCRIPTION
Load data into SQLClearview using a defined collection name,

.PARAMETER SqlCVCollection
String. Mandatory.
Name of collection to use, e.g. ActiveSessions. Must exist in ref.Collections.

.PARAMETER logOutput
Switch, Optional
If specified output is written to logfile.

.EXAMPLE
PS> ./Get-SqlCVData.ps1 -SqlCVCollection ActiveSessions

#>


Param(
  [Parameter(Position=0,Mandatory=$true,HelpMessage="Name of collection to use")]
  [String]$SqlCVCollection,
  [Switch]$logOutput
)

# Get script location
$scriptDirectory = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
$scriptParent = Split-Path -Path $ScriptDirectory -Parent
$scriptName = $MyInvocation.MyCommand.Name
$logFile = "$(Split-Path -Path $ScriptParent -Parent)\Log\Monitor\$($scriptName -replace '\..*')-$($cmsTable)-$( Get-Date([datetime]::UtcNow) -Format "yyyy-MM-dd-HH.mm.ss").log"

. $scriptDirectory/Set-SqlCVEnvironment.ps1

Start-Log
# Add parameters to log
foreach ( $boundParam in $PSBoundParameters.GetEnumerator() )
{
  Write-Log "Parameter: $($boundParam.Key), Value: $($boundParam.Value)"
}

$sql = @"
SELECT sc.[ServerName],s.[IpAddress]
FROM [SQLClearview].[ref].[ServerCollections] sc
JOIN [SQLClearview].[ref].[Servers] s ON (s.ServerName=sc.ServerName)
WHERE sc.[CollectionName]='$SqlCVCollection'
"@

$collectorSql = "$($SqlCVScriptPath)\$($SqlCVCollection).sql"
Write-Log "Looking for collector SQL in: $($collectorSql)"
if ( !(Test-Path "$collectorSql") ) {
  Throw "Collector SQL not found"
}
Write-Log "Collecting data ..."
$serverList = Invoke-DbaQuery -sqlinstance $SqlCVServer -SqlCredential $SqlCVAdminCredential -query "$sql"
if ( $serverList -eq $Null ) {
  Write-Log "No servers found for collector, maybe not defined in Collections?"
  Stop-Log
  Return
}

$StopWatch = New-Object System.Diagnostics.Stopwatch
$StopWatch.Start()

$datasets = $serverList  | %{
  Write-Host $_.ServerName
  Invoke-DbaQuery -SQLInstance $_.IpAddress -SqlCredential $SqlCVCollectorCredential -file "$collectorSql" -As DataSet
}

$StopWatch.Stop()
Write-Log "Collection complete in $($StopWatch.Elapsed.TotalSeconds) second(s)"

if ( $datasets -eq $Null ) {
  Write-Log "No data returned from collector"
  Stop-Log
  Return
}
Write-Log "Loading data into $SqlCVDatabase ..."
$StopWatch.Reset()
$StopWatch.Start()

ForEach ( $ds in $datasets ) {
  #ForEach ( $t in $ds.Tables ) {
  #  # $t.Columns[0]
  #  $t.Columns['UtcTimestamp']
  #}
  Try {
	   Write-DbaDbTableData -SqlInstance $SqlCVServer -SqlCredential $SqlCVAdminCredential -Database "$SqlCVDatabase" -Table "$SqlCVCollection" -InputObject $ds -EnableException
  }
  Catch {
    Write-Log "Problem loading data!! $($_.Exception.Message)"
  }
}
$StopWatch.Stop()
Write-Log "Load complete in $($StopWatch.Elapsed.TotalSeconds) second(s)"

Stop-Log
