$dnsRecords = Get-Content C:\Path\To\File.txt
$domainFQDN = (Get-ADDomain).DNSRoot
$targetHost = 'WhatTheAliasShouldPointTo'

foreach($d in $dnsRecords) {
  $oldRecord = Get-DnsServerResourceRecord -ComputerName $domainFQDN -ZoneName $domainFQDN -Name $d
  $newRecord = [CimInstance]::New($oldRecord)
  $newRecord.RecordData.HostNameAlias = $targetHost
  $newRecord.TimeToLive = [System.TimeSpan]::FromMinutes(5)
  Set-DnsServerResourceRecord -ComputerName $domainFQDN -ZoneName $domainFQDN -OldInputObject $oldRecord -NewInputObject $newRecord
  [PSCustomObject]@{
    DNSRecord = $d
    OldTarget = $oldRecord.RecordData.HostNameAlias
    NewTarget = $newRecord.RecordData.HostNameAlias
    TTL = $newRecord.TimeToLive
  }

  $oldRecord = $null
  $newRecord = $null
}
