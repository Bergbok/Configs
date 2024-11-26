Invoke-WebRequest "https://github.com/GooseMod/OpenAsar/releases/latest/download/app.asar" -OutFile ".\app.asar"

$npDiscordPaths = Get-ChildItem "$env:LOCALAPPDATA\Discord" -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -like "app*" }

if ($npDiscordPaths) {
    foreach ($path in $npDiscordPaths) {
        $destination = Join-Path $path.FullName "resources"
        New-Item -ItemType Directory "$destination" -Force | Out-Null
        Copy-Item ".\app.asar" -Destination "$destination" -Force
        Write-Host -ForegroundColor Green "Successfully installed OpenAsar to $destination"
    }
}

if (Get-Command scoop -ErrorAction SilentlyContinue) {
    if (scoop list | Select-String -Pattern "discord" -SimpleMatch) {
        $destinations = Get-ChildItem "$env:USERPROFILE\scoop\apps\discord\*\app\app-*\resources" -ErrorAction SilentlyContinue

        if ($destinations) {
            foreach ($destination in $destinations) {                
                Copy-Item ".\app.asar" -Destination "$($destination.FullName)\app.asar" -Force
                Write-Host -ForegroundColor Green "Successfully installed OpenAsar to $($destination.FullName)"
            }
        }
    }
}

Remove-Item ".\app.asar" -Force
