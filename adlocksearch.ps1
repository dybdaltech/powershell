$gruppe = Get-ADgroupMember -Identity "Locked out gruppe"

foreach($person in $gruppe){
    $identity = $person.SamAccountName
    $a = Get-Aduser $identity
    $b = $a | Select-Object LockedOut
    if ($b = "@{LockedOut=True}") {
        Write-Host "true"
    } else { 
        Write-Host "False"
    }
}