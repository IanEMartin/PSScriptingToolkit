function Out-Log {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory, HelpMessage = 'Enter a string of information you want entered in the log.')]
    [string]$LogData,
    [string]$Path,
    [string]$FileName,
    [switch]$ErrorData,
    [switch]$Screen,
    [switch]$New
  )
  $LogFilePathAndName = ('{0}{1}' -f $Path, $FileName)
  #  Write-Verbose ('Logging to file - {0}' -f $LogFilePathAndName)
  if (!(Test-Path -Path $Path)) {
    New-Item -ItemType Directory -Path $Path -Force
  }
  if ($ErrorData) {
    $LogData = 'ERROR - ' + $LogData
  }
  $LogData = "$(Get-Date -Format 'yyyy-MM-dd HHmm'): " + $LogData
  if ($Screen -or ($VerbosePreference -eq 'Continue') -or ($LogData -match 'VERBOSE:') -or ($LogData -match 'WARNING:')) {
    if ($LogData -match 'WARNING:') {
      Write-Warning $LogData
    } elseif (($VerbosePreference -eq 'Continue') -or ($LogData -match 'VERBOSE:')) {
      Write-Verbose $LogData
    }
    if ($Screen) {
      Write-Output -InputObject $LogData
    }
  }
  if ($new) {
    $LogData | Out-File -FilePath $LogFilePathAndName
  } else {
    $LogData | Out-File -FilePath $LogFilePathAndName -Append
  }
}
