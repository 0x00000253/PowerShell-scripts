$folderPath = 'P:\inf.data\Printertag'
$exportPath = 'C:\users\admin.frederikd\Desktop\accessTimes.csv'

Get-ChildItem -Path $FolderPath -Recurse -Force |
    Select-Object FullName, @{Name="LastAccessTime"; Expression={ $_.LastAccessTime }} |
    Sort-Object LastAccessTime |
    Export-Csv -Path $exportPath -Encoding utf8
