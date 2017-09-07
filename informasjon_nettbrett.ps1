
function findInfo {
    $desktop = [Environment]::GetFolderPath("Desktop")
    $adapterInfo = Get-NetAdapter -Name Wi-Fi, Mobiltelefon -ErrorAction SilentlyContinue | select Name, MacAddress 
    $hostnameInfo = $env:COMPUTERNAME
    $adapterInfo = $adapterInfo | % { ($_ | Out-String).Trim() -replace '@\{|\}' }
    Write-output $adapterInfo $hostnameInfo | Out-File $desktop\xnfo.txt
    gc $desktop\xnfo.txt | Out-Printer -name "Konica Minolta 2.etg"
    Start-sleep 3
    Disable-netadapter -Name Wi-Fi -Confirm:$False
}
Write-Host "Adding printer..."
Add-printerport -name "KonicaMinolta 2.etg" -printerhostaddress "172.19.20.21" 
add-printerdriver -Name "KONICA MINOLTA PS Color Laser Class Driver"
add-printer -name "Konica Minolta 2.etg" -port "KonicaMinolta 2.etg" -drivername "KONICA MINOLTA PS Color Laser Class Driver"
Write-host "Getting and printing information..."
findInfo
