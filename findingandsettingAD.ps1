#Create a random password!
function createPassword () {
    $store = Get-Random -Minimum 1000 -Maximum 9999
    $pass = "Password" + $store.ToString()
    Write-Host $pass
    Write-Output $pass | Out-File "F:\Benjamin\out.txt"
    $securePass = ConvertTo-SecureString -String $pass -AsPlainText -Force
    return $securePass
}

#Find the ADUser
function find-aduser([string]$firstName, [string]$lastName){
    $storeUser = "*$firstName* *$lastName*"
    $aduser = Get-ADUser -f {name -like $storeUser}
    return $aduser
}


$a = $true
Write-Host "STARTED, Write name."
While($a -eq $true) {
    Write-Host "-------------------------------------------------------------------" -ForegroundColor Red
    $userInput = Read-Host 
    if( $userInput -eq "exit" ) {
        Write-Host "Exiting.."
        Start-sleep -Seconds 1
        $a = $false
    } else {
        Write-Host "Searching AD..."
        $search = find-aduser $userInput
        write-host $search.SAMAccountName
        $newPassword = createPassword
        Set-AdAccountPassword -Identity $search -Reset -NewPassword $newPassword
        Write-Host "Reloading.."
    }
}

