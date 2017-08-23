$gruppe = Get-ADgroupMember -Identity "Locked out gruppe"

foreach($person in $gruppe){
    $identity = $person.SamAccountName
    $a = $identity | select LockedOut
    if($a = "@{LockedOut=True}"){
        Write-Host "Account Locked out: " + $identity.DistuingishedName
    }
}