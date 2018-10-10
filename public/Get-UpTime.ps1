function Get-Uptime {
  [CmdletBinding(
    SupportsShouldProcess,
    ConfirmImpact = 'Low')]
  param
  (
    [Parameter(
      ValueFromPipeline,
      ValueFromPipelineByPropertyName)]
    $ComputerName
  )

  Begin {
    if ($null -eq $ComputerName) {
      $ComputerName = $env:COMPUTERNAME
    }
    $value = '' | Select-Object -Property ComputerName, LastReboot, Uptime, Service
  }

  Process {
    foreach ($computer in $ComputerName) {
      if ($null -ne (Test-WSMan -ComputerName $computer -ErrorAction SilentlyContinue)) {
        $value.Service = 'WSMan (CIMInstance)'
        $query = Get-CimInstance -ComputerName $computer -Query 'SELECT LastBootUpTime FROM Win32_OperatingSystem'
        $boottime = $query.LastBootUpTime
      } else {
        $value.Service = 'WMI'
        $query = Get-WmiObject -ComputerName $computer -Query 'SELECT LastBootUpTime FROM Win32_OperatingSystem'
        $boottime = $query.ConvertToDateTime($query.LastBootUpTime)
      }
      $now = Get-Date
      $uptime = $now - $boottime
      $value.ComputerName = $computer
      $value.LastReboot = Get-Date -Date ($boottime) -Format 'yyyy-MM-dd HH:mm'
      $value.Uptime = ('{0} Days {1} Hrs {2} Min {3} Sec' -f $uptime.days, $uptime.hours, $uptime.Minutes, $uptime.Seconds)
      $value
    }
  }
}
