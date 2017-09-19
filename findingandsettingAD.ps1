#Create a random password!
function createPassword () {
    $store = Get-Random -Minimum 1000 -Maximum 9999
    $pass = "NesnaPassord" + $store.ToString()
    Write-Host $pass
    Write-Output $pass | Out-File "E:\Benjamin\out.txt"
    #$securePass = ConvertTo-SecureString -String $pass -AsPlainText -Force
    #return $securePass
    return $pass
}

#Find the ADUser
function find-aduser([string]$firstName, [string]$lastName){
    $storeUser = "$firstName" + "*" + "$lastName"
    $aduser = Get-ADUser -Filter {name -like $storeUser}
    if($aduser -isnot [Microsoft.ActiveDirectory.Management.ADAccount]){
        write-host "Multiple users found: " $aduser.length
        $choice = Read-Host 
        if($choice -gt $aduser.length){
            Write-Host "Number greater than array length, please choose a number between 0 and " $aduser.length
            return
        }
        Write-Host $aduser[$choice]
        return $aduser[$choice]
    }
    Write-Host $aduser
    return $aduser
}


$a = $true
Write-Host "STARTED, Write name."
While($a -eq $true) {
    Write-Host "-------------------------------------------------------------------" -ForegroundColor Red
    $userInput = Read-Host 
    $badinput = Read-Host
    $search = find-aduser $userInput $badinput
    $newPassword = createPassword
    #Write-Output $search.SAMAccountName + "|" + $newPassword | clip 
    Write-Output $search.SAMAccountName "|" $newPassword | Out-File "E:\Benjamin\outTotal.txt" -NoNewline -Append
    $newPassword = ConvertTo-SecureString -String $newPassword.ToString() -AsPlainText -Force -ErrorAction SilentlyContinue 
    Set-AdAccountPassword -Identity $search -Reset -NewPassword $newPassword -ErrorAction SilentlyContinue
    Write-Host "Reloading.."
}

