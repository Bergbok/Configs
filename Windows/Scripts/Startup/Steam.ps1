$scoopPrefix = scoop prefix steam
if ($scoopPrefix) {
    $steam = "$scoopPrefix\steam.exe"
} else {
    $steam = es -i -n 1 -r "\.exe$" "steam.exe"
}
Start-Process $steam -Args "-console -nochatui -nofriendsui -silent -forcedesktopscaling 0.69"
Start-Sleep -Seconds 30
nircmd win max process "steam.exe"
nircmd win max process "steamwebhelper.exe"
Start-Sleep -Seconds 0.69
nircmd win min process "steamwebhelper.exe"
