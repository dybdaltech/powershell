#Import modules used:
Clear-Host
Import-Module ActiveDirectory
Write-Host "Imported modules..." -ForegroundColor Cyan

Function Get-StringHash([String] $String,$HashName = "md5")
{
$StringBuilder = New-Object System.Text.StringBuilder
[System.Security.Cryptography.HashAlgorithm]::Create($HashName).ComputeHash([System.Text.Encoding]::UTF8.GetBytes($String))|%{
    #Change "X2" to "x2" if you want the hash in lowercase.
    [Void]$StringBuilder.Append($_.ToString("x2"))
}
$StringBuilder.ToString()
}

#Create a random password:
function Create-Password () {
    $store = Get-Random -Minimum 1000 -Maximum 9999
    $pass = "NewefwergrgPauilul8iord" + $store.ToString()
    Write-Output $pass | Out-File "E:\Benjamin\out.txt"
    return $pass
}

#Find the ADUser
function find-aduser ( [string]$queryUser) {
    try{
        $aduser = Get-ADUser -LDAPFilter "(anr=$queryUser)"
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
                Write-Host ""
                write-host "`t"$aduser[$i].DistinguishedName
                Write-Host ""
                Write-Host "`t"$aduser[$i].Name
                Write-Host ""
                write-Host "`t"$aduser[$i].SAMAccountName
                Write-Host "_____________________________________________________" -ForegroundColor Magenta
                $i++
            }

            #Select a user
            Write-Host ""
            $choice = Read-Host -Prompt "`t Select one: " 
            if( $choice -gt $aduser.length ) {
                $arrayLength = $aduser.length
                Write-Host "Number greater than array length, please choose a number between 0 and " $aduser.length
                return
            } else {
                Write-Host "`t Is this correct? " -ForegroundColor Red
                Write-Host "`t"$aduser[$choice].Name -ForegroundColor Yellow
                $yesno = Read-Host -Prompt "`t Yes or No"
                if( $yesno -like "*y*" ) {
                    return $aduser[$choice]
                } else {
                    Write-Host "Wrong user selected.. Throwing Error" -ForegroundColor Gray
                    return $null
                }
            }

        } else { #/if $aduser
            return $null
        }
    }
    Write-Host $aduser
    return $aduser
}




$a = $true
Write-Host "`Started AD Management script." -ForegroundColor DarkGray
Write-Host "`t Choose an option below:"
Write-Host "`t 1: Reset AD Password"
Write-Host "`t 2: Set MobilePhone on AD Account"
$script_option = Read-Host -Prompt "--"
While($a -eq $true) {
    Write-Host "-------------------------------------------------------------------" -ForegroundColor DarkRed
    #Using function Find-aduser to query AD and find an appropiate user.
    $userInput = Read-Host -Prompt "`t User to search for"
    $search = find-aduser $userInput
    if( $search -eq $null) {
        Write-Host  "Error" -ForegroundColor Red
        $a = $false
    } else {
        if($script_option -eq 1){                       #RESET PASSWORD TODO: Change this to a more cleaner version.
            $myshitPass = Create-Password
            $myshitPass = Get-StringHash $myshitPass 
            $newPassword = $myshitPass.substring(0, 9)
            $newPassword = $newPassword + "A"           # Lazy way to bypass AD policies.
            Write-Output $search.SAMAccountName $newPassword | Out-File "E:\REDACTED\outTotal.txt" -Append -ErrorAction SilentlyContinue -NoClobber
            $newPassword = ConvertTo-SecureString -String $newPassword.ToString() -AsPlainText -Force -ErrorAction SilentlyContinue 
            Set-AdAccountPassword -Identity $search -Reset -NewPassword $newPassword -ErrorAction SilentlyContinue
            Write-Host "Reloading.."

        } elseif ( $script_option -eq 2 ) {
            #TODO: Change this
            $uname = $search.SAMAccountName
            $phoneNr = Read-Host -Prompt "Phone number to add to $uname :"
            Set-ADUser -MobilePhone $phoneNr -Identity $search
        } else {
            Write-Host "Please choose a valid option.."
        }
    }

    #Incase of error:
    if( $a -eq $false ) {
        $userInput2 = Read-Host -Prompt "Restart?"
        if( $userInput2 ) {
            Clear-Host
            $a = $true
        } else {
            $a = $a
        }
    }
}

