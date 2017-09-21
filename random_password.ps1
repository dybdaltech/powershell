function stringer([int]$lengthOfStr) {
    $i = 0
    $alphabet = "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"
    $low_Alphabet = "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"
    $word_list = "Kritka", "RKOGvj", "ek92cnm", "kmjb+\34", "nf833", ",df0", "adcc", "Passw0rd", "supr3", ",934"
    $special = "!", "#", "¤", "%", "&", "=", "'", "^^", ":", "/", "?"
    $password = @()
    while($i -lt $lengthOfStr){
        $number_random_high = Get-Random -Minimum 1 -Maximum 64
        $case_random = Get-Random -Minimum 1 -Maximum 6
        $letter_random = Get-Random -Minimum 1 -Maximum 26
        #START A MESSED UP ALGORITHM
        if($case_random -eq 1) {
            $password += $alphabet[$letter_random]
        } elseif ($case_random -eq 2) {
            $password += $low_alphabet[$letter_random]
            if($letter_random -lt 10) {
                $newrand = Get-Random -Minimum 10 -Maximum 26
                $password += $alphabet[$newrand]
            }
        } elseif ($case_random -eq 3) {
            $spcRandom = Get-Random -Minimum 1 -Maximum 11
            $password += $special[$spcRandom]
        }  elseif ($case_random -eq 4) {
            $list_random = Get-Random -Minimum 1 -Maximum 10
            $password += $word_list[$list_random]
        }

        $password += $number_random_high
        $i++
    } # END LOOP

    $arrayLength = $password.length
    $final = ""
    for($j = 0; $j -lt $arrayLength){
        Write-Host $j
        $j++
    }
    Write-Host $final
    Write-Output $final | Out-File C:\Users\bad\OneDrive\powershell\pas.txt -Append
}

stringer 24