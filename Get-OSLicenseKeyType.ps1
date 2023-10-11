$dir = "C:\users\$($env:USERNAME)\Desktop"
$servers = Get-Content $dir\servers.txt
$output = @()

foreach($s in $servers) {

    $keyDescription = Invoke-Command -ComputerName $s -ScriptBlock { (Get-CimInstance -ClassName SoftwareLicensingProduct | Where-Object { $_.PartialProductKey -ne $null }).Description }
    $keyType = '<not found>'

    if($keyDescription -like "*Volume_KMSCLIENT*") {

        $keyType = 'KMS'
    }
    elseif ($keyDescription -like "*VOLUME_MAK*") {
    
        $keyType = 'MAK'
    }

    $output += "$s,$keyType"

}

$output | Out-File $dir\servers2.txt