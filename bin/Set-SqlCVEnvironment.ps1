<#
.SYNOPSIS
Configure SQLClearview environment

.DESCRIPTION
Configure SQLClearview environment

#>

# Import DBATools module - must be in $env:PSMODULEPATH
Import-Module DBATools

# Server hosting CMS database
# . or (local) work for localhost and avoid a TCP connection
$SqlCVServer = "192.168.1.118"
# Database and target for collected data
$SqlCVDatabase = "SQLClearView"

# Path to SQL collector scripts, can be local or UNC
$SqlCVScriptPath = "H:\sqlclearview\sql\collectors"

# Collector credentials
<#
See: https://pscustomobject.github.io/powershell/howto/Store-Credentials-in-PowerShell-Script/

#>
. H:\sqlclearview\bin\New-StringDecryption.ps1
# Define Credentials
[string]$SqlCVUsername = 'SQLClearview-Collector'
[SecureString]$SqlCVPassword = ConvertTo-SecureString -String (New-StringDecryption -EncryptedString 'StrUqL92rzIwDFTJCcpk9Q==') -AsPlainText -Force

# Create the credential object
[pscredential]$SqlCVAdminCredential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList 'SQLClearview-Admin', $SqlCVPassword
[pscredential]$SqlCVCollectorCredential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $SqlCVUsername, $SqlCVPassword

function Write-Log
 {
  param([string]$msg)
	if ($logOutput) {
	  $msg | Out-File $logFile -Append
	}
	Write-Host $msg
}

function Start-Log
{
  Write-Log "Begin $($scriptName) at: $(Get-Date)  Universal Time = $( ((Get-Date).ToUniversalTime()) )"
  Write-Log "----"
  Write-Log "Script directory: $($scriptDirectory)"
  Write-Log "Script parent   : $($scriptParent)"
  Write-Log "Parameters:"
}

function Stop-Log
{
  Write-Log "----"
  Write-Log "End $($scriptName) at: $(Get-Date)  Universal Time = $( ((Get-Date).ToUniversalTime()) )"
}

# Error handling
Trap {
  $ErrorMessage = $_.Exception.Message
  $ErrorInner = $_.Exception.InnerException
  # Send mail
  Write-Log "Error trap, details:"
  Write-Log $ErrorMessage
  Write-Log $ErrorInner
  $insertSql
  Write-Log "Exiting ..."
  Try {
    $s.ConnectionContext.RollbackTransaction();
  } Catch {
    Write-Log "No transaction"
  }
  # Break, or Continue script execution
  Break
}
