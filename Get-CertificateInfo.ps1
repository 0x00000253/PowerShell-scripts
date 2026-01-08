$certFolder = "C:\Users\frederikd\OneDrive - Cegeka\Desktop\certs"
$certFiles = Get-ChildItem -Path $certFolder -Filter *.cer -File

foreach($certFile in $certFiles) {

    $cer = [System.Security.Cryptography.X509Certificates.X509Certificate2]::new((Convert-Path $certFile.FullName))

    $issueDate = $cer.NotBefore.ToString('dd/MM/yyyy')
    $expireDate = $cer.NotAfter.ToString('dd/MM/yyyy')
    $subjectName = (($cer.SubjectName.Name -split ',')[0] -split 'CN=')[1]
    "$subjectName`t$($cer.Thumbprint)`t$($cer.SerialNumber)`t$issueDate`t$expireDate"
    break
}
