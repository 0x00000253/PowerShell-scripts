$computers = Get-ADComputer -Filter { samaccountname -like "SV*" -or samaccountname -like "SW*" } -Properties OperatingSystem | Where { $_.OperatingSystem -like "*Windows Server*" }

$script = {

    Try {

        if(Test-Path C:\Temp\slmgr.txt) {

            Remove-Item C:\temp\slmgr.txt -Force
        }

        cscript C:\Windows\System32\slmgr.vbs -dlv > C:\temp\slmgr.txt

        $ADBApattern = Select-String -Path C:\temp\slmgr.txt -Pattern "CN=Activation Objects"
        $MAKpattern = Select-String -Path C:\temp\slmgr.txt -Pattern "VOLUME_MAK"
        $KMSpattern = Select-String -Path C:\temp\slmgr.txt -Pattern "VOLUME_KMS"
        $licenseType = $null

        if($MAKpattern -ne $null) {

            $licenseType = 'MAK'
        }
        elseif($KMSpattern -ne $null -and $ADBApattern -eq $null) {

            $licenseType = 'KMS'
        }
        elseif($ADBApattern -ne $null) {

            $licenseType = 'ADBA'
        }
        else {

            $licenseType = 'Undetermined'
        }

        Remove-Item C:\temp\slmgr.txt -Force
        New-Object -TypeName PSCustomObject -Property @{Host=$env:computername; LicenseType=$licenseType}
    }
    Catch {
    }
}


foreach($c in $computers) {

    Invoke-Command -ComputerName $c.DNSHostName -ScriptBlock $script -HideComputerName | Select * -ExcludeProperty RunspaceId
}