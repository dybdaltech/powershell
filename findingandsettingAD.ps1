#Import modules used:
Add-Type -AssemblyName System.Speech
$SpeechSynth = New-Object System.Speech.Synthesis.SpeechSynthesizer
cls

Import-Module ActiveDirectory
Write-Host "Imported modules..." -ForegroundColor Cyan
#Create a random password:
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
        $SpeechSynth.Speak("Fetching USER.")
        $aduser = Get-ADUser -Filter {name -like $storeUser} 
    } Catch {
        $errormsg = $_.Exception.Message
        Write-Host $errormsg
        Break
    }
    if( $aduser -isnot [Microsoft.ActiveDirectory.Management.ADAccount] ) {
        if ( $aduser ) {
            write-host "Multiple users found: " $aduser.length
            $SpeechSynth.Speak("Found multiple users.")
            for( $i=0; $i -lt $aduser.length ) {
                Write-Host "                                       "
                Write-Host "-------------------$i---------------------------------" -ForegroundColor Magenta
                Write-Host ""
                write-host $aduser[$i].DistinguishedName
                Write-Host ""
                Write-Host $aduser[$i].Name
                Write-Host ""
                write-Host $aduser[$i].SAMAccountName
                Write-Host "_____________________________________________________" -ForegroundColor Gray
                $i++
            }
    
            $choice = Read-Host 
            if( $choice -gt $aduser.length ) {
                $arrayLength = $aduser.length
                Write-Host "Number greater than array length, please choose a number between 0 and " $aduser.length
                $SpeechSynth.Speak("Number greater than array length, please choose a number between 0 and $arrayLength ")
                return
            } else {
                Write-Host "Is this correct? " -ForegroundColor Red
                Write-Host $aduser[$choice]
                $secondChoice = Read-Host -Prompt "Yes or No"
                if( $secondChoice -like "*y*") {
                    return $aduser[$choice]
                }
                else {
                    Write-Host "Wrong user selected.. Throwing Error" -ForegroundColor Gray
                    return $null
                }
            }

        } else { #If $ADUSER
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
        Write-Host "FATAL error." -ForegroundColor Red
        $SpeechSynth.Speak("fatal error occured, please wait for the system to log the error. Contact system administrator for guidance on how to proceed with this error!")
        $a = $false
    } else {
    $newPassword = createPassword
    Write-Output $search.SAMAccountName "," $newPassword | Out-File "E:\qwee21sd\outTotal.txt" -NoNewline -Append -ErrorAction SilentlyContinue
    $newPassword = ConvertTo-SecureString -String $newPassword.ToString() -AsPlainText -Force -ErrorAction SilentlyContinue 
    Set-AdAccountPassword -Identity $search -Reset -NewPassword $newPassword -ErrorAction SilentlyContinue
    Write-Host "Reloading.."
    $SpeechSynth.Speak("Reloading...")   
    }
    if($a -eq $false){
        $SpeechSynth.Speak("Restart?")
        $userInput2 = Read-Host -Prompt "Restart?"
        if( $userInput2) {
            cls
            [System.Console]::beep(300, 110)
            $a = $true
        } else {
            [System.Console]::beep(300, 290)
            $SpeechSynth.Speak("Exiting ...")
            $a = $a
        }
    }
}

