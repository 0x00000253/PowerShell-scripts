$servers = Get-ADComputer -Filter { OperatingSystem -like "Windows Server*" } -Properties OperatingSystem

foreach($s in $servers) {

  try {
    $result = Invoke-Command -ComputerName $s.DNSHostName -ScriptBlock  {
      if([System.Environment]::OSVersion.Version.Major -ge 6 -and [System.Environment]::OSVersion.Version.Minor -ge 2) {
        (Get-SmbServerConfiguration).EnableSMB1Protocol
      } else {
        $regVal = Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" -Name "SMB1" -ErrorAction SilentlyContinue
        if($regVal -ne 0) {
          $true
        }
      }
    } -ErrorAction Stop

    [PSCustomObject]@{
      Server = $s.DNSHostName
      OS = $s.OperatingSystem
      SMBv1Enabled = $result
    }
  } catch {
    [PSCustomObject]@{
      Server = $s.DNSHostName
      OS = $s.OperatingSystem
      SMBv1Enabled = "Unreachable: $($_.Exception_Message)"
    }
  }
}
