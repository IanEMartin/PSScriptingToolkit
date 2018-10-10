function Get-DriveSpaceInfo {
  [CmdletBinding()]
  param
  (
    [Parameter(
      ValueFromPipeline,
      ValueFromPipelineByPropertyName)]
    $ComputerName
  )

  Begin {
    $value = '' | Select-Object -Property ComputerName, SizeGb, FreeSpaceGb, Service
  }

  Process {
    $value.Service = ''
    $value.ComputerName = $ComputerName
    $value.SizeGb = $null
    $value.FreeSpaceGb = $null
    if ($null -ne (Test-WSMan -ComputerName $ComputerName -ErrorAction SilentlyContinue)) {
      $value.Service = 'WSMan (CIMInstance)'
      $diskinfo = Get-CimInstance -ComputerName $ComputerName -ClassName Win32_LogicalDisk -Filter "DeviceID='C:'" -ErrorAction SilentlyContinue | Select-Object -Property Size, FreeSpace
    } else {
      $value.Service = 'WMI'
      $diskinfo = Get-WmiObject -ComputerName $ComputerName -Class Win32_LogicalDisk -Filter "DeviceID='C:'" -ErrorAction SilentlyContinue | Select-Object -Property Size, FreeSpace
    }
    if ($null -ne $diskinfo) {
      $value.SizeGb = [math]::round(($diskinfo.Size / 1Gb), 2)
      $value.FreeSpaceGb = [math]::round(($diskinfo.FreeSpace / 1Gb), 2)
    }
    return $value
  }
}
