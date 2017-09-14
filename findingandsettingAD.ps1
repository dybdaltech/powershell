#Lag et random passord!
function createPassword () {
    $store = Get-Random -Minimum 1000 -Maximum 9999
    $pass = "nesna" + $store.ToString()
    Write-Host $pass
    Write-Output $pass | Out-File "F:\Benjamin\out.txt"
    $securePass = ConvertTo-SecureString -String $pass -AsPlainText -Force
    return $securePass
}

function find-aduser([string]$firstName, [string]$lastName){
    $storeUser = "*$firstName* *$lastName*"
    $aduser = Get-ADUser -f {name -like $storeUser}
}
$a = $true
Write-Host "STARTED, Write name."
While($a -eq $true) {
    Write-Host "-------------------------------------------------------------------" -ForegroundColor Red
    $userInput = Read-Host 
    if( $userInput -eq "exit" ) {
        $a = $false
    } else {
        Write-Host "Searching AD..."
        $search = find-aduser $userInput
        Start-Sleep -Seconds 1
        write-host $search.SAMAccountName
        $newPassword = createPassword
        Set-AdAccountPassword -Identity $search -Reset -NewPassword $newPassword
        Write-Host "Reload.."
    }
}

