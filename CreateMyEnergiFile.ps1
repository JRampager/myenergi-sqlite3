Param([string]$text)
New-Item -Path 'Files\MyEnergi.txt' -ItemType File -Force
Set-Content 'Files\MyEnergi.txt' $text