$scoopPrefix = scoop prefix soulseekqt
if ($scoopPrefix) {
    $soulseekqt = "$scoopPrefix\SoulseekQt.exe"
} else {
    $soulseekqt = es -i -n 1 -r "\.exe$" "SoulseekQt\SoulseekQt.exe"
}
Start-Process $soulseekqt
Start-Sleep -Seconds 15
nircmd win max process "soulseekqt.exe"
nircmd win min process "soulseekqt.exe"
