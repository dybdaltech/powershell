function regShit($data){
    [regex]$regex = '(imgur)\.(com)\/.*\/.*'
    $fixed = $regex.Matches($data) | ForEach-Object {$_.Value}
    Write-Host $fixed -ForegroundColor Cyan
    return $fixed
    }
    
    $imgur = Invoke-WebRequest imgur.com
    $imgLinks = $imgur.Links.href
    for($i=0; $i -le 100; $i++){
    $link = $imgLinks[$i]
    if($link -match "/gallery"){
        $final = "imgur.com"+$link
        Write-Host $final -ForegroundColor Green
        $imgurSecond = Invoke-WebRequest $final
        $iSecondLinks = $imgurSecond.Links.href
        Write-host $iSecondLinks -ForegroundColor Yellow
        for($x=0; $x -le 100; $x++){
            $link2 = $iSecondLinks[$x]
                if($link2 -match "/user/"){
                    $a = regShit($link2)
                    Start-Process Chrome $a
                }
            }
        }
        else{
        Write-Host $link
        Write-host "Not gallery link.." -ForegroundColor Red
        }
    }