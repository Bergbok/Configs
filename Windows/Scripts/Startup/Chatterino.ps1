$scoopPrefix = scoop prefix chatterino
if ($scoopPrefix) {
    $chatterino = "$scoopPrefix\chatterino.exe"
} else {
    $chatterino = es -i -n 1 -r "\.exe$" "chatterino.exe"
}
Start-Process $chatterino
Start-Sleep -Seconds 20
nircmd win max process "chatterino.exe"
nircmd win min process "chatterino.exe"
