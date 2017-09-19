#Create a random password!
function createPassword () {
    $store = Get-Random -Minimum 1000 -Maximum 9999
    $pass = "NewefwergrgPauilul8iord" + $store.ToString()
    Write-Host $pass
    Write-Output $pass | Out-File "E:\Benjamin\out.txt"
    #$securePass = ConvertTo-SecureString -String $pass -AsPlainText -Force
    #return $securePass
    return $pass
}

#Find the ADUser
function find-aduser ( [string]$firstName, [string]$lastName ) {
    $storeUser = "$firstName" + "*" + "$lastName"
    try{
        $aduser = Get-ADUser -Filter {name -like $storeUser} 
    } Catch {
        $errormsg = $_.Exception.Message
        Write-Host $errormsg
        Break
    }
    if( $aduser -isnot [Microsoft.ActiveDirectory.Management.ADAccount] ) {
        if ( $aduser ) {
            write-host "Multiple users found: " $aduser.length
            for( $i=0; $i -lt $aduser.length ) {
                Write-Host "                                       "
                Write-Host "-------------------$i---------------------------------" -ForegroundColor Magenta
                write-host $aduser[$i].DistuingishedName
                Write-Host $aduser[$i].Name
                write-Host $aduser[$i].SAMAccountName
                Write-Host "_____________________________________________________" -ForegroundColor Gray
                $i++
            }
    
            $choice = Read-Host 
            if( $choice -gt $aduser.length ) {
                Write-Host "Number greater than array length, please choose a number between 0 and " $aduser.length
                return
            }
            Write-Host "Is this correct? " -ForegroundColor Red
            Write-Host $aduser[$choice]
            $secondChoice = Read-Host -Prompt "Yes or No"
            if( $secondChoice -eq "y") {
                return $aduser[$choice]
            }
            else {
                return $null
            }
        } else {
            return $null
        }

    }
    Write-Host $aduser
    return $aduser
}


$a = $true
Write-Host "STARTED, Write name."
While($a -eq $true) {
    Write-Host "-------------------------------------------------------------------" -ForegroundColor Red
    $userInput = Read-Host -Prompt "Given Name"
    $badinput = Read-Host -Prompt "Surname"
    $search = find-aduser $userInput $badinput
    if( $search -eq $null) {
        Invoke-Expression .\findingandsettingAD.ps1 #LAZY AF
    }
    $newPassword = createPassword
    Write-Output $search.SAMAccountName "," $newPassword | Out-File "E:\qwee21sd\outTotal.txt" -NoNewline -Append
    $newPassword = ConvertTo-SecureString -String $newPassword.ToString() -AsPlainText -Force -ErrorAction SilentlyContinue 
    Set-AdAccountPassword -Identity $search -Reset -NewPassword $newPassword -ErrorAction SilentlyContinue
    Write-Host "Reloading.."
}

