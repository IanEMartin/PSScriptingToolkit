function Test-WinRM {
  [CmdletBinding(
    SupportsShouldProcess,
    ConfirmImpact = 'High')]
  param
  (
    [Parameter(
      ValueFromPipeline,
      ValueFromPipelineByPropertyName)]
    $ComputerName
  )

  BEGIN {
  }

  PROCESS {
    #invoke a command to get WinRM service status
    $Result = Invoke-Command -ComputerName $ComputerName -ScriptBlock {Get-Service | Where-Object {($_.Name -eq 'WinRM') -and ($_.Status -eq 'Running')}} -ErrorVariable WinRMPresentError -ErrorAction SilentlyContinue #DevSkim: ignore DS104456
    if ($null -ne $Result) {
      $WinRMStatus = $True
    } else {
      $WinRMStatus = $False
    }
    if ($VerbosePreference -eq 'Continue') {
      if ($null -ne (Test-WSMan)) {
        Write-Verbose ('[{0}] WSMan available: {1}' -f $ComputerName, $True)
      } else {
        Write-Verbose ('[{0}] WSMan available: {1}' -f $ComputerName, $False)
      }
      Write-Verbose ('[{0}] WinRM available: {1}' -f $ComputerName, $WinRMStatus)
    }
    $WinRMStatus
  }
}
