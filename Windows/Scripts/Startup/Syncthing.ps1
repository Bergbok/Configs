if (Get-Command syncthing -ErrorAction SilentlyContinue) {
    $syncthing = "syncthing"
} else {
    $syncthing = es -i -n 1 -r "\.exe$" "syncthing.exe"
}
Start-Process $syncthing -Args "--no-browser --no-console"

Start-Sleep -Seconds 3

if (Get-Command syncthingtray -ErrorAction SilentlyContinue) {
    $syncthingtray = "syncthingtray"
} else {
    $syncthingtray = es -i -n 1 -r "\.exe$" "syncthingtray.exe"
}
Start-Process $syncthingtray
