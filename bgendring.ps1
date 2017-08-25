$oldPath = "C:\bilder\bg.jpg"
if(Test-Path $oldPath){
    $oldFile = Get-ChildItem -Path C:\bilder\bg.jpg -File
} else {
    $oldFile = $False
}
$dir = Get-ChildItem -Path C:\bilder\*.jpg -File 
$array = @()
foreach($bilde in $dir){
    $array += ,$bilde 
}
$max = $array.Count
$randomNum = Get-Random -Minimum 1 -Maximum $max
$oldFileNewName = Get-Random -Minimum $max -Maximum 999999
$selected = $array[$randomNum]
Write-Host $selected
if($oldFile -ne $False){
    Rename-Item -Path $oldFile -NewName "$oldFileNewName.jpg"
}
Rename-Item -Path $selected -NewName "bg.jpg"
