<#
Hei! 
#>

$Host.UI.RawUI.WindowTitle = "WEB Service monitor"
Write-Output "Starting..." | out-file "C:\IKT\applikasjonLog.txt" -Append -Force

function work-time{
    $timeDone = "15.30"
    $timeCurrent = Get-Date -Format HH.mm
    if($timeCurrent -eq $timeDone){
        $WT = $false
    } else {
        $WT = $true
    }
    return $WT
}

function get-webService{
    $logfile = Get-Date
    $logfile = $logfile.Date.ToString() + ".txt"
    write-Output "Creating new logfile..." | out-file "C:\IKT\applikasjonLog.txt" -Append -Force
    New-Item -Path "C:\IKT\" -Name $logfile -Force -Type File  
    $services = get-service -Name "*ESA*"
    if(work-time -eq $true){
        foreach($service in $services){
            $time = Get-Date
            if($service.Status -eq "Stopped"){
                Write-Output $service.Name $service.Status $time | Out-File "C:\IKT\$logfile" -Append
            } else {
                Write-Output "Everything is working $time" | Out-File "C:\IKT\$logfile" -Append
            }
        }
    } else { #Else for work-time
        Write-Output "Not working time..." | Out-File "C:\IKT\$logfile" -Append
    }

}