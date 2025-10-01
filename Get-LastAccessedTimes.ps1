$folderPath = "C:\path\to\folder"
$exportPath = "C:\users\$env:USERNAME\Desktop\accessTimes.csv"

Get-ChildItem -Path $FolderPath -Recurse -Force |
    Select-Object FullName, @{Name="LastAccessTime"; Expression={ $_.LastAccessTime }} |
    Sort-Object LastAccessTime |
    Export-Csv -Path $exportPath -NoTypeInformation -Encoding utf8
