#Requires -RunAsAdministrator

[CmdletBinding(HelpUri="https://github.com/Bergbok/Configs/blob/main/Windows/README.md#Setup.ps1")]
param ()

$ErrorActionPreference = "Continue"

#region Duration Tracker
$script:startTime = Get-Date
$script:originalWindowTitle = $host.UI.RawUI.WindowTitle

function Invoke-Exiting {
    param (
        [datetime]$script:startTime
    )
    $duration = (Get-Date) - $script:startTime
    script:Log "Finished in: $($duration.Hours) hours, $($duration.Minutes) minutes, $($duration.Seconds) seconds, $($duration.Milliseconds) ms`n"
    $host.UI.RawUI.WindowTitle = $script:originalWindowTitle
}

Register-EngineEvent -SourceIdentifier PowerShell.Exiting -Action { Invoke-Exiting $script:startTime } | Out-Null
#endregion

#region Script Scope Variables
$envEntries = (Get-Content "$PSScriptRoot\.env") -split "`n"
foreach ($entry in $envEntries) {
    if ($entry -match "^(.*?)=(.*)$") {
        $key = $matches[1]
        $value = $matches[2]
    }

    if (-not $value) {
        continue
    }

    $key = $key.ToLower() -replace "_", ""
    $value = $value -replace '\$PSScriptRoot', "$PSScriptRoot"

    if ($value -eq "True" -or $value -eq "1") {
        $value = $true
    } elseif ($value -eq "False" -or $value -eq "0") {
        $value = $false
    }

    Set-Variable -Scope Script -Name $key -Value $value
}

# used to have a massive list of params, but now exclusivly using the .env file
foreach ($key in $MyInvocation.BoundParameters.Keys) {
    Set-Variable -Scope Script -Name $key -Value $MyInvocation.BoundParameters[$key]
}

$script:commands = @{
    ".NET 8.0 Desktop Runtime" = @(
        "choco install dotnet-8.0-runtime -y"
        "scoop install extras/windowsdesktop-runtime"
        "winget install --id=Microsoft.DotNet.Runtime.8 --exact --accept-source-agreements --accept-package-agreements"
    )
    "After Dark CC Theme" = @(
        "gdown `$script:afterDarkThemeGDriveID"
        "script:Expand-7zArchive '.\After-Dark-CC-Theme.7z'"
        "Remove-Item '.\After-Dark-CC-Theme.7z'"
        # Copy-Item : The requested operation cannot be performed on a file with a user-mapped section open.
        "Copy-Item '.\After-Dark-CC-Theme\Theme For Win10 22H2\Hide Commandbar\*' -Destination '$env:WINDIR\Resources\Themes' -Recurse -Force -ErrorAction SilentlyContinue"
        "New-Item -ItemType Directory '$env:USERPROFILE\Themes\After-Dark-CC-Theme' -Force | Out-Null"
        "Copy-Item '.\After-Dark-CC-Theme\*' -Destination '$env:USERPROFILE\Themes\After-Dark-CC-Theme' -Recurse -Force -ErrorAction SilentlyContinue"
        "Remove-Item '.\After-Dark-CC-Theme' -Recurse -Force"
        "Set-Location '$env:USERPROFILE\Themes\After-Dark-CC-Theme\OldNewExplorer'"
        "Start-Process '.\OldNewExplorerCfg.exe'"
        "Start-Process 'https://imgur.com/oldnewexplorer-config-C8BNIZL'"
        "Set-Location '$PSScriptRoot'"
        "`$secureuxthemePath = es -i -n 1 -r '\.exe$' 'ThemeTool.exe'"
        "Start-Process `$secureuxthemePath"
        "Start-Sleep -Seconds 0.69"
        "`$themeToolProcess = Get-Process -Name 'ThemeTool' -ErrorAction SilentlyContinue"
        "if (`$themeToolProcess) {
            `$themeToolProcess.CloseMainWindow() | Out-Null
        }"
        "Start-Process '$env:USERPROFILE\Themes\After-Dark-CC-Theme\Icons\iPack Icon\Gray V4 iPack Icon\Gray V4 iPack Icon.exe'"
        "Set-Clipboard 'HKEY_CLASSES_ROOT\CLSID\{679f85cb-0220-4080-b29b-5540cc05aab6}\DefaultIcon'"
        "Start-Process '$env:USERPROFILE\Themes\After-Dark-CC-Theme\Icons\iPack Icon\Windows 10 - Change Quick Access Icon\RegOwnershipEx.exe'"
        "Start-Sleep -Seconds 2"
        "Set-Clipboard 'HKEY_LOCAL_MACHINE\Software\WOW6432Node\Classes\CLSID\{679f85cb-0220-4080-b29b-5540cc05aab6}\DefaultIcon'"
        "Start-Process '$env:USERPROFILE\Themes\After-Dark-CC-Theme\Icons\iPack Icon\Windows 10 - Change Quick Access Icon\RegOwnershipEx.exe'"
        "`$timeout = 120"
        "Write-Host 'Press any key after taking ownership of keys with RegOwnershipEx' -ForegroundColor Green"
        "`$stopwatch = [System.Diagnostics.Stopwatch]::StartNew()"
        "`$keyPressed = `$false"
        "while (`$stopwatch.Elapsed.TotalSeconds -lt `$timeout) {
            `$remainingTime = [math]::Ceiling(`$timeout - `$stopwatch.Elapsed.TotalSeconds)
            if (`$remainingTime -le 5) {
                `$color = 'Red'
            } else {
                `$color = 'Yellow'
            }
            Write-Host -ForegroundColor `$color Skipping in `$remainingTime seconds...
            if ([System.Console]::KeyAvailable) {
                `$key = [System.Console]::ReadKey(`$true)
                `$keyPressed = `$true
                break
            }
            Start-Sleep -Seconds 1
        }"
        "`$stopwatch.Stop()"
        "if (`$keyPressed) {
            `$basePath = '$env:USERPROFILE'
            `$fileName = 'Themes\After-Dark-CC-Theme\Icons\iPack Icon\Windows 10 - Change Quick Access Icon\custom.reg'
            `$fullPath = Join-Path `$basePath -ChildPath `$fileName
            
            Write-Host 'Changing Quick Access icon...' -ForegroundColor Green
            reg import `$fullPath 2>`$null
            & '$PSScriptRoot\Scripts\Reload-Icon-Cache.ps1'
        } else {
            script:Log 'After-Dark-CC-Theme: Skipped Quick Access icon change registry import, you can do it manually with - reg import '$env:USERPROFILE\Icons\iPack Icon\Windows 10 - Change Quick Access Icon\custom.reg''
        }"
    )
    "AltServer" = @(
        "choco install altserver -y"
        "scoop install bergbok/altserver"
        "winget install --id=RileyTestut.AltServer --exact --accept-source-agreements --accept-package-agreements"
    )
    "Ares" = @(
        "scoop install games/ares"
    )
    "Audacity" = @(
        "choco install audacity -y"
        "scoop install extras/audacity"
        "winget install --id=Audacity.Audacity --exact --accept-source-agreements --accept-package-agreements"
    )
    "AudioDeviceCmdlets" = @(
        "scoop install bergbok/audiodevicecmdlets"
        # "Install-Module -Name AudioDeviceCmdlets -AcceptLicense"
    )
    "AutoHotkey" = @(
        "choco install autohotkey -y"
        "scoop install extras/autohotkey"
        "winget install --id=AutoHotkey.AutoHotkey --exact --accept-source-agreements --accept-package-agreements"
        "Copy-Item '$PSScriptRoot\Configs\AutoHotkey' -Destination '$env:USERPROFILE\Code\Scripts' -Recurse -Force"
        "foreach (`$script in (Get-ChildItem '$env:USERPROFILE\Code\Scripts\AutoHotkey\Startup\*')) { 
            New-Item -ItemType SymbolicLink `"$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\`$(`$script.Name)`" -Target `$script.FullName -Force 
        }"
    )
    "Autologon" = @(
        # "choco install autologon"
        "scoop install sysinternals/autologon"
        "autologon"
    )
    "AutoRuns" = @(
        "choco install autoruns -y"
        "scoop install sysinternals/autoruns"
        "winget install --id=Microsoft.Sysinternals.Autoruns --exact --accept-source-agreements --accept-package-agreements"
    )
    "BCUninstaller" = @(
        "choco install bulk-crap-uninstaller -y"
        "scoop install extras/bulk-crap-uninstaller"
        "winget install --id=Klocman.BulkCrapUninstaller --exact --accept-source-agreements --accept-package-agreements"
    )
    "BetterDiscord" = @(
        "New-Item -ItemType Directory '$env:APPDATA\BetterDiscord' -Force | Out-Null"
        "Copy-Item '$(Split-Path $PSScriptRoot)\Cross-Platform\BetterDiscord\*' -Destination '$env:APPDATA\BetterDiscord' -Recurse -Force"
        "`$pluginDir = '$env:APPDATA\BetterDiscord\plugins'"
        "Invoke-WebRequest 'https://raw.githubusercontent.com/mwittrien/BetterDiscordAddons/refs/heads/master/Library/0BDFDB.plugin.js' -OutFile `"`$pluginDir\0BDFDB.plugin.js`""
        "Invoke-WebRequest 'https://raw.githubusercontent.com/zerebos/BDPluginLibrary/refs/heads/master/release/0PluginLibrary.plugin.js' -OutFile `"`$pluginDir\0PluginLibrary.plugin.js`""
        "Invoke-WebRequest 'https://raw.githubusercontent.com/Neodymium7/BetterDiscordStuff/refs/heads/main/ActivityIcons/ActivityIcons.plugin.js' -OutFile `"`$pluginDir\ActivityIcons.plugin.js`""
        "Invoke-WebRequest 'https://raw.githubusercontent.com/arg0NNY/DiscordPlugins/refs/heads/master/BetterAnimations/BetterAnimations.plugin.js' -OutFile `"`$pluginDir\BetterAnimations.plugin.js`""
        "Invoke-WebRequest 'https://raw.githubusercontent.com/jaspwr/BDPlugins/refs/heads/main/BetterAudioPlayer/BetterAudioPlayer.plugin.js' -OutFile `"`$pluginDir\BetterAudioPlayer.plugin.js`""
        "Invoke-WebRequest 'https://raw.githubusercontent.com/zerebos/BetterDiscordAddons/refs/heads/master/Plugins/BetterFormattingRedux/BetterFormattingRedux.plugin.js' -OutFile `"`$pluginDir\BetterFormattingRedux.plugin.js`""
        "Invoke-WebRequest 'https://raw.githubusercontent.com/arg0NNY/DiscordPlugins/refs/heads/master/BetterGuildTooltip/BetterGuildTooltip.plugin.js' -OutFile `"`$pluginDir\BetterGuildTooltip.plugin.js`""
        "Invoke-WebRequest 'https://raw.githubusercontent.com/mwittrien/BetterDiscordAddons/refs/heads/master/Plugins/BetterNsfwTag/BetterNsfwTag.plugin.js' -OutFile `"`$pluginDir\BetterNsfwTag.plugin.js`""
        "Invoke-WebRequest 'https://raw.githubusercontent.com/Zerthox/BetterDiscord-Plugins/refs/heads/master/dist/bd/BetterVolume.plugin.js' -OutFile `"`$pluginDir\BetterVolume.plugin.js`""
        "Invoke-WebRequest 'https://raw.githubusercontent.com/jaimeadf/BetterDiscordPlugins/refs/heads/build/BiggerStreamPreview/dist/BiggerStreamPreview.plugin.js' -OutFile `"`$pluginDir\BiggerStreamPreview.plugin.js`""
        "Invoke-WebRequest 'https://raw.githubusercontent.com/QWERTxD/BetterDiscordPlugins/refs/heads/master/CallTimeCounter/CallTimeCounter.plugin.js' -OutFile `"`$pluginDir\CallTimeCounter.plugin.js`""
        "Invoke-WebRequest 'https://raw.githubusercontent.com/EpicGazel/DiscordFreeEmojis/refs/heads/master/DiscordFreeEmojis.plugin.js' -OutFile `"`$pluginDir\DiscordFreeEmojis.plugin.js`""
        "Invoke-WebRequest 'https://raw.githubusercontent.com/zerebos/BetterDiscordAddons/refs/heads/master/Plugins/DoNotTrack/DoNotTrack.plugin.js' -OutFile `"`$pluginDir\DoNotTrack.plugin.js`""
        "Invoke-WebRequest 'https://raw.githubusercontent.com/Farcrada/DiscordPlugins/refs/heads/master/Double-click-to-edit/DoubleClickToEdit.plugin.js' -OutFile `"`$pluginDir\DoubleClickToEdit.plugin.js`""
        "Invoke-WebRequest 'https://raw.githubusercontent.com/mwittrien/BetterDiscordAddons/refs/heads/master/Plugins/EditUsers/EditUsers.plugin.js' -OutFile `"`$pluginDir\EditUsers.plugin.js`""
        "Invoke-WebRequest 'https://raw.githubusercontent.com/mwittrien/BetterDiscordAddons/refs/heads/master/Plugins/GameActivityToggle/GameActivityToggle.plugin.js' -OutFile `"`$pluginDir\GameActivityToggle.plugin.js`""
        "Invoke-WebRequest 'https://raw.githubusercontent.com/mwittrien/BetterDiscordAddons/refs/heads/master/Plugins/ImageUtilities/ImageUtilities.plugin.js' -OutFile `"`$pluginDir\ImageUtilities.plugin.js`""
        "Invoke-WebRequest 'https://raw.githubusercontent.com/Strencher/BetterDiscordStuff/refs/heads/master/InvisibleTyping/InvisibleTyping.plugin.js' -OutFile `"`$pluginDir\InvisibleTyping.plugin.js`""
        "Invoke-WebRequest 'https://raw.githubusercontent.com/bepvte/bd-addons/refs/heads/main/plugins/NoSpotifyPause.plugin.js' -OutFile `"`$pluginDir\NoSpotifyPause.plugin.js`""
        "Invoke-WebRequest 'https://raw.githubusercontent.com/mwittrien/BetterDiscordAddons/refs/heads/master/Plugins/PluginRepo/PluginRepo.plugin.js' -OutFile `"`$pluginDir\PluginRepo.plugin.js`""
        "Invoke-WebRequest 'https://raw.githubusercontent.com/mwittrien/BetterDiscordAddons/refs/heads/master/Plugins/ReadAllNotificationsButton/ReadAllNotificationsButton.plugin.js' -OutFile `"`$pluginDir\ReadAllNotificationsButton.plugin.js`""
        "Invoke-WebRequest 'https://raw.githubusercontent.com/jaimeadf/BetterDiscordPlugins/refs/heads/build/SecretRingTone/dist/SecretRingTone.plugin.js' -OutFile `"`$pluginDir\SecretRingTone.plugin.js`""
        "Invoke-WebRequest 'https://raw.githubusercontent.com/mwittrien/BetterDiscordAddons/refs/heads/master/Plugins/ShowConnections/ShowConnections.plugin.js' -OutFile `"`$pluginDir\ShowConnections.plugin.js`""
        "Invoke-WebRequest 'https://raw.githubusercontent.com/mwittrien/BetterDiscordAddons/refs/heads/master/Plugins/SplitLargeMessages/SplitLargeMessages.plugin.js' -OutFile `"`$pluginDir\SplitLargeMessages.plugin.js`""
        "Invoke-WebRequest 'https://raw.githubusercontent.com/mwittrien/BetterDiscordAddons/refs/heads/master/Plugins/ThemeRepo/ThemeRepo.plugin.js' -OutFile `"`$pluginDir\ThemeRepo.plugin.js`""
        "Invoke-WebRequest 'https://raw.githubusercontent.com/aarondoet/BetterDiscordStuff/refs/heads/master/Plugins/TypingIndicator/TypingIndicator.plugin.js' -OutFile `"`$pluginDir\TypingIndicator.plugin.js`""
        "Invoke-WebRequest 'https://raw.githubusercontent.com/QWERTxD/BetterDiscordPlugins/main/TypingUsersAvatars/TypingUsersAvatars.plugin.js' -OutFile `"`$pluginDir\TypingUsersAvatars.plugin.js`""
        "`$themeDir = '$env:APPDATA\BetterDiscord\themes'"
        "New-Item -ItemType Directory `$themeDir -Force | Out-Null"
        "Invoke-WebRequest 'https://raw.githubusercontent.com/mwittrien/BetterDiscordAddons/refs/heads/master/Themes/DiscordRecolor/DiscordRecolor.theme.css' -OutFile `"`$themeDir\DiscordRecolor.theme.css`""
        "Invoke-WebRequest 'https://raw.githubusercontent.com/NYRI4/Discolored/refs/heads/master/support/discolored.theme.css' -OutFile `"`$themeDir\discolored.theme.css`""
        "git clone 'https://github.com/Zwylair/BetterDiscordAutoInstaller'"
        "New-Item -ItemType Directory '$env:USERPROFILE\Code\Scripts\Python\BetterDiscord-AutoInstaller' -Force | Out-Null"
        "Copy-Item '.\BetterDiscordAutoInstaller\*' -Destination '$env:USERPROFILE\Code\Scripts\Python\BetterDiscord-AutoInstaller' -Recurse -Force"
        "Remove-Item '.\BetterDiscordAutoInstaller' -Recurse -Force"
        "Set-Location '$env:USERPROFILE\Code\Scripts\Python\BetterDiscord-AutoInstaller'"
        "python -m venv venv"
        ".\venv\Scripts\Activate.ps1"
        "pip install -r requirements.txt"
        "Remove-Item '.\settings.json' -Force -ErrorAction SilentlyContinue"
        "python main.py"
        "deactivate"
        "Set-Location '$PSScriptRoot'"
        "if (Get-Command syncthing -ErrorAction SilentlyContinue) {
            syncthing cli config folders add --id '5rvta-4ecem' --label 'BetterDiscord' --path '$env:APPDATA\BetterDiscord'
        }"
    )
    "BFG Repo-Cleaner" = @(
        "choco install bfg-repo-cleaner -y"
        "scoop install main/bfg"
    )
    "Bun" = @(
        "choco install bun -y"
        "scoop install main/bun"
        "winget install --id=Oven-sh.Bun --exact --accept-source-agreements --accept-package-agreements"
    )
    "Calibre" = @(
        "choco install calibre -y"
        "scoop install extras/calibre"
        "winget install --id=calibre.calibre --exact --accept-source-agreements --accept-package-agreements"
        "if (scoop list | Select-String -Pattern 'calibre' -SimpleMatch) {
            `$destinationPath = '$env:USERPROFILE\scoop\persist\calibre\Calibre Settings'
        } else {
            `$destinationPath = '$env:APPDATA\calibre'
        }"
        "New-Item -ItemType Directory `$destinationPath -Force | Out-Null"
        "Copy-Item '$(Split-Path $PSScriptRoot)\Cross-Platform\Calibre\icons-dark.rcc' -Destination `$destinationPath -Force"
    )
    "CEMU" = @(
        "choco install cemu -y"
        "scoop install games/cemu"
        "winget install --id=Cemu.Cemu --exact --accept-source-agreements --accept-package-agreements"
        "gdown `$script:wiiUSavesGDriveID"
        "script:Expand-7zArchive '.\Wii-U.7z'"
        "Remove-Item '.\Wii-U.7z'"
        "if (scoop list | Select-String -Pattern 'cemu' -SimpleMatch) {
            New-Item -ItemType Directory '$env:USERPROFILE\scoop\persist\cemu\mlc01\usr\save' -Force | Out-Null
            Copy-Item '.\Wii-U\*' -Destination '$env:USERPROFILE\scoop\persist\cemu\mlc01\usr\save' -Recurse -Force
            if (Get-Command syncthing -ErrorAction SilentlyContinue) {
                Set-Content '$env:USERPROFILE\scoop\persist\cemu\mlc01\.stignore' 'usr/title'
                syncthing cli config folders add --id 'riwat-pjoqx' --label 'CEMU MLC' --path '$env:USERPROFILE\scoop\persist\cemu\mlc01'
            }
        } else {
            `$cemu_path = es -i -n 1 -r '\.exe$' 'Cemu.exe'
            `$savePath = `"`$(Split-Path `$cemu_path)\mlc01\usr\save`"
            New-Item -ItemType Directory `$savePath -Force | Out-Null
            Copy-Item '.\Wii-U\*' -Destination `"`$savePath`" -Force
            if (Get-Command syncthing -ErrorAction SilentlyContinue) {
                Set-Content `"`$(Split-Path `$cemu_path)\mlc01\.stignore`" 'usr/title'
                syncthing cli config folders add --id 'riwat-pjoqx' --label 'CEMU MLC' --path `"`$(Split-Path `$cemu_path)\mlc01`"
            }
        }"
        "Remove-Item '.\Wii-U' -Recurse -Force"
    )
    "Chatterino2" = @(
        "choco install chatterino -y"
        # "scoop install extras/chatterino" # taskbar entry
        "winget install --id=ChatterinoTeam.Chatterino --exact --accept-source-agreements --accept-package-agreements"
        "New-Item -ItemType Directory '$env:USERPROFILE\Audio\SFX\Notifications' -Force | Out-Null"
        "Copy-Item '$(Split-Path $PSScriptRoot)\Cross-Platform\Chatterino\default-notification.mp3' -Destination '$env:USERPROFILE\Audio\SFX\Notifications\Metroid-Data-Received.mp3' -Force"
        "Copy-Item '$(Split-Path $PSScriptRoot)\Cross-Platform\Chatterino\jerma-notification.wav' -Destination '$env:USERPROFILE\Audio\SFX\Notifications\Jerma-UWU.wav' -Force"
        "`$settings = Get-Content '$(Split-Path $PSScriptRoot)\Cross-Platform\Chatterino\settings.json'"
        "`$settings = `$settings -replace 'jerma-notification-path-here', (`'$env:USERPROFILE\Audio\SFX\Notifications\Jerma-UWU.wav' -replace '\\', '\\')"
        "`$settings = `$settings -replace 'default-notification-path-here', (`'$env:USERPROFILE\Audio\SFX\Notifications\Metroid-Data-Received.wav' -replace '\\', '\\')"
        "`$settings = `$settings -replace 'imgur-client-id-here', `$script:imgurClientID"
        "if (scoop list | Select-String -Pattern 'chatterino' -SimpleMatch) {
            `$confPath = '$env:USERPROFILE\scoop\persist\chatterino\Settings'
        } else {
            `$confPath = '$env:APPDATA\Chatterino2\Settings'
        }"
        "New-Item -ItemType Directory `$confPath -Force | Out-Null"
        "Copy-Item '$(Split-Path $PSScriptRoot)\Cross-Platform\Chatterino\*' -Exclude 'default-notification.mp3', 'jerma-notification.wav' -Destination `$confPath -Recurse -Force"
        "Set-Content `"`$confPath\settings.json`" -Value `$settings -Force"
        "if (Get-Command syncthing -ErrorAction SilentlyContinue) {
            Set-Content `"`$confPath\.stignore`" '*.json.bkp-*`n*.json.??????'
            syncthing cli config folders add --id 'axgjf-shqtw' --label 'Chatterino' --path `$confPath
        }"
        "script:Log 'Chatterino: If the log in button does nothing, manually log in with https://chatterino.com/client_login'"
    )
    "Cheat Engine" = @(
        "choco install cheatengine -y"
        # "scoop install extras/cheat-engine" # taskbar entry
    )
    "Cmder" = @(
        "choco install cmder -y"
        "scoop install main/cmder"
        "if (scoop list | Select-String -Pattern 'cmder' -SimpleMatch) {
            `$destinationPath = '$env:USERPROFILE\scoop\persist\cmder'
        } else {
            `$destinationPath = (Split-Path (es -i -n 1 -r '\.exe$' 'Cmder.exe'))
        }"
        "New-Item -ItemType Directory `$destinationPath -Force | Out-Null"
        "Copy-Item '$PSScriptRoot\Configs\Cmder\config' -Destination `$destinationPath -Recurse -Force"
        "New-Item -ItemType Directory '$env:USERPROFILE\Themes\oh-my-posh' -Force | Out-Null"
        "Copy-Item '$(Split-Path $PSScriptRoot)\Cross-Platform\oh-my-posh\*' -Destination '$env:USERPROFILE\Themes\oh-my-posh' -Force"
        "`$cmder_root = (Split-Path (es -i -n 1 -r '\.exe$' 'Cmder.exe'))"
        "`$ohmyposhlua = Get-Content `"`$cmder_root\config\oh-my-posh.lua`""
        "`$ohmyposhlua = `$ohmyposhlua -replace 'theme-path-here', ('$env:USERPROFILE\Themes\oh-my-posh\current.omp.json' -replace '\\', '\\')"
        "`$ohmyposhlua | Set-Content `"`$cmder_root\config\oh-my-posh.lua`" -Force"
    )
    "Command Prompt Aliases" = @(
        "New-Item -ItemType Directory '$env:USERPROFILE\.config\cmd' -Force | Out-Null"
        "`$aliases = Get-Content '$PSScriptRoot\Configs\Command-Prompt\aliases.doskey'"
        "if (Get-Command pwsh -ErrorAction SilentlyContinue) {
            `$aliases = `$aliases -replace 'powershell-path-here', ((Get-Command pwsh).Source)
            `$aliases = `$aliases -replace '[A-Z]:\\Program Files', '%ProgramFiles%'
        } else {
            `$aliases = `$aliases -replace 'powershell-path-here', '%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe'
        }"
        "Set-Content '$env:USERPROFILE\.config\cmd\aliases.doskey' -Value `$aliases"
        "New-Item 'HKCU:\Software\Microsoft\Command Processor' -Force | Out-Null"
        "Set-ItemProperty 'HKCU:\Software\Microsoft\Command Processor' -Name 'AutoRun' -Type String -Value 'doskey /MACROFILE=`"%USERPROFILE%\.config\cmd\aliases.doskey`"' -Force"
    )
    "CreamInstaller" = @(
        "scoop install bergbok/creaminstaller"
    )
    "CUDA" = @(
        "choco install cuda -y"
        "scoop install main/cuda"
        "winget install --id=Nvidia.CUDA --exact --accept-source-agreements --accept-package-agreements"
    )
    "Cyberduck" = @(
        "choco install cyberduck -y"
        "scoop install extras/cyberduck"
        "winget install --id=Iterate.Cyberduck --exact --accept-source-agreements --accept-package-agreements"
    )
    "Cyberpunk Waifus Font" = @(
        "Invoke-WebRequest 'https://dl.dafont.com/dl/?f=cyberpunkwaifus' -OutFile '.\CyberpunkWaifus-Font.zip'"
        "Expand-Archive '.\CyberpunkWaifus-Font.zip' -DestinationPath '.' -Force"
        "Remove-Item '.\CyberpunkWaifus-Font.zip'"
        "script:Install-FontFile (Get-ChildItem '.\CyberpunkWaifus (1).ttf').FullName"
        "Remove-Item '.\CyberpunkWaifus (1).ttf' -Force"
    )
    "DS4Windows" = @(
        "choco install ds4windows -y"
        "scoop install bergbok/ds4windows"
        "winget install --id=Ryochan7.DS4Windows --exact --accept-source-agreements --accept-package-agreements"
        "if (scoop list | Select-String -Pattern 'ds4windows' -SimpleMatch) {
            `$destinationPath = '$env:USERPROFILE\scoop\persist\ds4windows'
        } else {
            `$destinationPath = '$env:APPDATA\DS4Windows'
        }"
        "New-Item -ItemType Directory `$destinationPath -Force | Out-Null"
        "Copy-Item '$PSScriptRoot\Configs\DS4Windows\*' -Destination `$destinationPath -Recurse -Force"
        "Start-Sleep -Seconds 1"
        "`$ds4windows = es -i -n 1 -r '\.exe$' 'DS4Windows.exe'"
        "Start-Process `$ds4windows"
    )
    "Deno" = @(
        "choco install deno -y"
        "scoop install main/deno"
        "winget install --id=DenoLand.Deno --exact --accept-source-agreements --accept-package-agreements"
    )
    "Discord" = @(
        # "choco list | Out-Null; choco install discord -y"
        # "scoop list | Out-Null; scoop install bergbok/discord" # taskbar entry
        "winget list | Out-Null; winget install --id=Discord.Discord --exact --accept-source-agreements --accept-package-agreements"
	"script:Log 'Discord: Get mobile app QR code scanner ready.'"
        "if (`$script:selected -contains 'BetterDiscord') {
            Write-Host 'Please log into Discord, press enter to continue when done.'
            Start-Sleep -Seconds 12
            if (-not (Get-Process -Name 'discord' -ErrorAction SilentlyContinue)) {
                `$discord = es -i -n 1 -r '\.exe$' 'Discord.exe'
                Start-Process powershell -Args `"`$discord`" -WindowStyle Hidden
            }
            Read-Host
        }"
    )
    "Discord OpenAsar" = @(
        "& '$PSScriptRoot\Scripts\Install-Discord-OpenAsar.ps1'"
    )
    "DisplayFusion" = @(
        "Start-Process steam://install/227260"
        "Get-Content '$PSScriptRoot\Configs\DisplayFusion\Settings.reg'"
        "`$settings = Get-Content '$PSScriptRoot\Configs\DisplayFusion\Settings.reg'"
        "`$settings = `$settings -replace 'userprofile-here', ('$env:USERPROFILE' -replace '\\', '\\')"
        "`$settings = `$settings -replace 'computer-name-here', '$env:COMPUTERNAME'"
        "`$settings = `$settings -replace 'taskbarx-path-here', ((es -i -n 1 -r '\.exe$' 'TaskbarX.exe') -replace '\\', '\\')"
        "`$settings | Out-File '.\temp-DisplayFusion-Settings.reg'"
        "reg import '.\temp-DisplayFusion-Settings.reg' 2>`$null"
        "Remove-Item '.\temp-DisplayFusion-Settings.reg' -Force"
    )
    "Docker CLI" = @(
        "choco install docker-cli -y"
        "scoop install main/docker"
        "winget install --id=Docker.DockerCli --exact --accept-source-agreements --accept-package-agreements"
    )
    "Docker Completion" = @(
        "scoop install extras/dockercompletion"
        # "Install-Module -Name DockerCompletion -AcceptLicense"
    )
    "Docker Compose" = @(
        "choco install docker-compose -y"
        "scoop install main/docker-compose"
        "winget install --id=Docker.DockerCompose --exact --accept-source-agreements --accept-package-agreements"
    )
    "Docker Engine" = @(
        "choco install docker-engine -y"
        "scoop install main/docker"
        "winget install --id=Docker.DockerCli --exact --accept-source-agreements --accept-package-agreements"
    )
    "Docker Desktop" = @(
        "choco install docker-desktop -y"
        "scoop install main/docker-desktop"
        "winget install --id=Docker.DockerDesktop --exact --accept-source-agreements --accept-package-agreements"
    )
    "Dolphin" = @(
        "choco install dolphin -y"
        "scoop install games/dolphin"
        "winget install --id=DolphinEmulator.Dolphin --exact --accept-source-agreements --accept-package-agreements"
        "Invoke-WebRequest 'https://gist.github.com/dantheman213/182e1ac17174681996221c31f59f1135/archive/538946df058e315f34fe926eb42f766689bb8ddb.zip' -OutFile 'Dolphin-Xbox-Controller-Profiles.zip'"
        "Expand-Archive '.\Dolphin-Xbox-Controller-Profiles.zip'"
        "Remove-Item '.\Dolphin-Xbox-Controller-Profiles.zip'"
        "if (scoop list | Select-String -Pattern 'dolphin' -SimpleMatch) {
            `$profilePath = '$env:USERPROFILE\scoop\persist\dolphin\User\Config\Profiles'
        } else {
            `$profilePath = '$env:USERPROFILE\Documents\Dolphin Emulator\Config\Profiles'
        }"
        "New-Item -ItemType Directory `"`$profilePath\GCPad`" -Force | Out-Null"
        "Copy-Item '.\Dolphin-Xbox-Controller-Profiles\*\Xbox Controller (GCPad).ini' -Destination `"`$profilePath\GCPad`" -Force"
        "New-Item -ItemType Directory `"`$profilePath\Wiimote`" -Force | Out-Null"
        "Copy-Item '.\Dolphin-Xbox-Controller-Profiles\*\Xbox Controller (Nunchuk+Wiimote).ini' -Destination `"`$profilePath\Wiimote`" -Force"
        "Remove-Item '.\Dolphin-Xbox-Controller-Profiles' -Recurse -Force"
    )
    "DuckStation" = @(
        # "scoop install games/duckstation; scoop install bergbok/ps2-bios" # https://github.com/Calinou/scoop-games/issues/1251
        "winget install --id=Stenzek.DuckStation --exact --accept-source-agreements --accept-package-agreements --ignore-security-hash; scoop install bergbok/ps2-bios"
        "`$biosPath = '$env:USERPROFILE\scoop\apps\ps2-bios\current\BIOS'"
        "if (scoop list | Select-String -Pattern 'duckstation' -SimpleMatch) {
            Remove-Item '$env:USERPROFILE\scoop\apps\duckstation\current\bios'
            New-Item -ItemType SymbolicLink '$env:USERPROFILE\scoop\persist\duckstation\current\bios' -Target `$biosPath -Force
        } else {
            New-Item -ItemType Directory '$env:USERPROFILE\Documents\DuckStation' -Force | Out-Null
            New-Item -ItemType SymbolicLink '$env:USERPROFILE\Documents\DuckStation\bios' -Target `$biosPath -Force
        }"
    )
    "Elden Ring Save Manager" = @(
        "scoop install bergbok/eldenring-save-manager"
        "Copy-Item '$PSScriptRoot\Configs\Elden-Ring-Save-Manager\background.png' -Destination '$env:USERPROFILE\scoop\persist\eldenring-save-manager\data' -Force"
        "Copy-Item '$PSScriptRoot\Configs\Elden-Ring-Save-Manager\config.json' -Destination '$env:USERPROFILE\scoop\persist\eldenring-save-manager\data' -Force"
        "`$config = Get-Content '$env:USERPROFILE\scoop\persist\eldenring-save-manager\data\config.json'"
        "`$config = `$config -replace 'gamedir-here', `"$env:USERPROFILE\AppData\Roaming\EldenRing\`$(`$script:steamID)`""
        "`$config = `$config -replace 'steamID-here', `$script:steamID"
        "`$config = `$config -replace '\\', '/'"
        "`$config | Set-Content '$env:USERPROFILE\scoop\persist\eldenring-save-manager\data\config.json'"
        # https://stackoverflow.com/a/44151771
        "git clone 'https://github.com/Bergbok/Elden-Ring-Saves.git' --depth 1"
        "Push-Location '.\Elden-Ring-Saves'"
        "git fetch --unshallow"
        "Copy-Item '.\save-files\*' -Destination '$env:USERPROFILE\scoop\persist\eldenring-save-manager\data\save-files' -Recurse -Force"
        "Pop-Location"
        "Remove-Item .\Elden-Ring-Saves -Recurse -Force"
    )
    "Epic Games Launcher" = @(
        "choco install epicgameslauncher -y"
        "scoop install games/epic-games-launcher"
        "winget install --id=EpicGames.EpicGamesLauncher --exact --accept-source-agreements --accept-package-agreements"
    )
    "Everything" = @(
        # "choco install everything -y"
        # "scoop install extras/everything" # taskbar entry
        "winget install --id=voidtools.Everything --exact --accept-source-agreements --accept-package-agreements"
        "if (-not (Get-Process -Name 'Everything' -ErrorAction SilentlyContinue)) {
            everything
        }"
        "Stop-Process -Name 'everything' -Force -ErrorAction SilentlyContinue"
        "if (scoop list | Select-String -Pattern 'Name=everything;' -SimpleMatch) {
            Copy-Item '$PSScriptRoot\Configs\Everything\Everything.ini' -Destination '$env:USERPROFILE\scoop\persist\everything' -Force
        } else {
            New-Item -ItemType Directory '$env:APPDATA\Everything' -Force | Out-Null
            Copy-Item '$PSScriptRoot\Configs\Everything\Everything.ini' -Destination '$env:APPDATA\Everything' -Force
        }"
        "if (Get-Command everything -ErrorAction SilentlyContinue) {
            `$everything = 'everything'
        } else {
            `$driveRoots = Get-PSDrive -PSProvider FileSystem |  Select-Object -ExpandProperty Root | Where-Object { `$_ -notlike '*Temp*' }
            foreach (`$driveRoot in `$driveRoots) {
                `$everythingPath = `"`$(`$driveRoot)Program Files\Everything\Everything.exe`"
                if (Test-Path `$everythingPath) {
                    `$everything = `$everythingPath
                    break
                }
            }
        }"
        "Start-Process `$everything -WindowStyle Minimized -Args '-install-service'"
        "Start-Sleep -Seconds 1; Stop-Process -Name 'everything' -Force"
        "Start-Process `$everything -WindowStyle Minimized -Args '-install-client-service'"
        "Start-Sleep -Seconds 1; Stop-Process -Name 'everything' -Force"
        "Start-Process `$everything -WindowStyle Minimized -Args '-install-run-on-system-startup'"
        "Start-Sleep -Seconds 1; Stop-Process -Name 'everything' -Force -ErrorAction SilentlyContinue"
        "Start-Process `$everything -WindowStyle Minimized"
    )
    "Everything CLI" = @(
        "choco install es -y"
        "scoop install main/everything-cli"
        "winget install --id=voidtools.Everything.Cli --exact --accept-source-agreements --accept-package-agreements"
    )
    "Everything PowerToys" = @(
        "choco install everythingpowertoys -y"
        "scoop install extras/everything-powertoys"
        "winget install --id=lin-ycv.EverythingPowerToys --exact --accept-source-agreements --accept-package-agreements"
    )
    "ExplorerPatcher" = @(
        "scoop info | Out-Null"
        "Add-MpPreference -ExclusionPath '$env:PROGRAMFILES\ExplorerPatcher'"
        "Add-MpPreference -ExclusionPath '$env:APPDATA\ExplorerPatcher'"
        "Add-MpPreference -ExclusionPath '$env:WINDIR\dxgi.dll'"
        "Add-MpPreference -ExclusionPath '$env:WINDIR\SystemApps\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy'"
        "Add-MpPreference -ExclusionPath '$env:WINDIR\SystemApps\ShellExperienceHost_cw5n1h2txyewy'"
        "reg import '$PSScriptRoot\Configs\ExplorerPatcher\ExplorerPatcher.reg'"
        "scoop install bergbok/explorer-patcher"
    )
    "f.lux" = @(
        "choco install f.lux.install -y"
        # "scoop install extras/f.lux" # autostart doesn't work
        "winget install --id=flux.flux --exact --accept-source-agreements --accept-package-agreements"
        "Start-Sleep -Seconds 1"
        "`$flux = es -i -n 1 -r '\.exe$' 'flux.exe'"
        "Start-Process `$flux"
        "script:Log `"f.lux: Click the limited color popup, but don't restart!`""
    )
    "Fan Control" = @(
        "scoop install extras/fancontrol"
        "winget install --id=Rem0o.FanControl --exact --accept-source-agreements --accept-package-agreements"
    )
    "FFDec" = @(
        "scoop install extras/ffdec"
        "winget install --id=JPEXS.FFDec -e --accept-source-agreements --accept-package-agreements"
    )
    "ffmpeg" = @(
        "choco install ffmpeg -y"
        "scoop info | Out-Null; if (`$script:selected -contains 'yt-dlp' -or (Get-Command yt-dlp)) { scoop install versions/ffmpeg-yt-dlp } else { scoop install main/ffmpeg }"
        "winget install --id=Gyan.FFmpeg --exact --accept-source-agreements --accept-package-agreements"
    )
    "FileTypesMan" = @(
        "choco install filetypesman -y"
        "scoop install nirsoft/filetypesman"
    )
    "Firefox" = @(
        "choco install firefox -y"
        # "scoop install extras/firefox" # taskbar entry
        "winget install --id=Mozilla.Firefox --exact --accept-source-agreements --accept-package-agreements"
        "Start-Sleep -Seconds 1"
        "if (Get-Command firefox -ErrorAction SilentlyContinue) {
            `$firefox = 'firefox'
        } else {
            `$firefox = es -i -n 1 -r '\.exe$' 'firefox.exe'
        }"
        "Start-Process `$firefox -Args '-setDefaultBrowser'"
        "Start-Sleep -Seconds 4.2"
        "Write-Host 'Setting up Arkenfox...'"
        "`$latestRelease = Invoke-RestMethod -Uri 'https://api.github.com/repos/arkenfox/user.js/releases/latest'"
        "`$zipUrl = `$latestRelease.zipball_url"
        "Invoke-WebRequest `$zipUrl -OutFile '.\Arkenfox.zip'"
        "Expand-Archive '.\Arkenfox.zip' -DestinationPath '.\Arkenfox' -Force"
        "Remove-Item '.\Arkenfox.zip' -Force"
        "Move-Item '.\Arkenfox\arkenfox-user.js*\*' -Destination '.\Arkenfox' -ErrorAction SilentlyContinue"
        "Remove-Item '.\Arkenfox\arkenfox-user.js*' -Recurse -Force"
        "Remove-Item '.\Arkenfox\prefsCleaner.sh'"
        "Remove-Item '.\Arkenfox\updater.sh'"
        "Remove-Item '.\Arkenfox\LICENSE.txt'"
        "Remove-Item '.\Arkenfox\README.md'"
        "Stop-Process -Name 'firefox' -ErrorAction SilentlyContinue"
        "`$profileDirs = @(Get-ChildItem `"$env:APPDATA\Mozilla\Firefox\Profiles`" -Directory)"
        "`$profileFolder = `"$(Split-Path $PSScriptRoot)\Cross-Platform\Firefox`""
        "`$userChrome = Get-Content `"`$profileFolder\chrome\userChrome.css`""
        "`$userChrome = `$userChrome -replace 'phone-hostname-here', `$script:phoneHostname"
        "`$userChrome = `$userChrome -replace 'pi-hostname-here', `$script:piHostname"
        "foreach (`$dir in `$profileDirs) {
            Copy-Item `"`$profileFolder\*`" -Destination `$dir.FullName -Recurse -Force            
            Copy-Item '.\Arkenfox\*' -Destination `$dir.FullName -Recurse -Force
            Set-Location `$dir.FullName
            New-Item -ItemType File '.\chrome\userChrome.css' -ErrorAction SilentlyContinue
            `$userChrome | Set-Content '.\chrome\userChrome.css'
            if ((Test-Path '.\user.js') -and (Test-Path '.\prefs.js')) {
                Start-Process '.\prefsCleaner.bat' -Args '-unattended' -Wait -NoNewWindow 
                Start-Process '.\updater.bat' -Args '-unattended' -Wait -NoNewWindow
            }
            `$host.UI.RawUI.WindowTitle = 'Running setup'
            Set-Location '$PSScriptRoot'
        }"
        "Remove-Item '.\Arkenfox' -Recurse -Force"
        "try {
            Write-Host 'Downloading Bypass Paywalls Clean...'
            `$bypassPaywallsPath = [System.IO.Path]::GetTempPath() + 'Bypass-Paywalls-Clean-Latest.xpi'
            Invoke-WebRequest 'https://gitflic.ru/project/magnolia1234/bpc_uploads/blob/raw?file=bypass_paywalls_clean-latest.xpi&inline=false' -OutFile `$bypassPaywallsPath
        } catch {
            script:Log 'Firefox: Failed to download Bypass Paywalls Clean'
        }"
        "foreach (`$file in (Get-ChildItem '$(Split-Path $PSScriptRoot)\Cross-Platform\Browser-Extensions' -Exclude 'FFZ.json' -Recurse -Attributes !Directory)) {
            `$path = '`"' + 'file://' + `$file.FullName + '`"'
            Write-Verbose `"Opening `$path with Firefox`"
            Start-Process `$firefox -Args `"`-new-tab `$path`"
            Start-Sleep -Seconds 1
        }"
        "Start-Process `$firefox -Args '-new-tab https://store.steampowered.com'"
        "Start-Sleep -Seconds 1"
        "Start-Process `$firefox -Args '-new-tab https://www.twitch.tv/greatsphynx'"
        "Start-Sleep -Seconds 1"
        "Start-Process `$firefox -Args '-new-tab https://adsbypasser.github.io/releases/adsbypasser.full.es7.user.js'"
        "Start-Sleep -Seconds 1"
        "Start-Process `$firefox -Args '-new-tab https://raw.githubusercontent.com/Nuklon/Steam-Economy-Enhancer/master/code.user.js'"
        "Start-Sleep -Seconds 1"
        "Start-Process `$firefox -Args '-new-tab https://github.com/pixeltris/TwitchAdSolutions/raw/refs/heads/master/video-swap-new/video-swap-new.user.js'"
        "Start-Sleep -Seconds 1"
        "Start-Process `$firefox -Args '-new-tab https://codeberg.org/Amm0ni4/bypass-all-shortlinks-debloated/raw/branch/main/Bypass_All_Shortlinks.user.js'"
        "Start-Sleep -Seconds 1"
        "Start-Process `$firefox -Args '-new-tab https://raw.githubusercontent.com/Bergbok/Configs/refs/heads/main/Cross-Platform/Browser-Extensions/FFZ.json'"
        "Start-Sleep -Seconds 1"
        "Start-Process `$firefox -Args '-new-tab https://duckduckgo.com/settings'"
        "Start-Sleep -Seconds 1"
        "Start-Process `$firefox -Args '-new-tab about:profiles'"
        "Start-Sleep -Seconds 1"
        "Start-Process `$firefox -Args '-new-tab about:preferences#search'"
        "Start-Sleep -Seconds 4.2"
        "Start-Process `$firefox -Args `"-new-tab `$bypassPaywallsPath`""
        "if (Get-Command syncthing -ErrorAction SilentlyContinue) {
            `$folderPath = `"`$((Get-ChildItem '$env:APPDATA\Mozilla\Firefox\Profiles' | Select-Object -First 1).FullName)\chrome`"
            syncthing cli config folders add --id 'xhfsq-nqpty' --label 'Firefox CSS' --path `$folderPath --paused
            script:Log 'Syncthing: Double check that the Firefox CSS folder is correct -> about:profiles'
        }"
        "script:Log 'Firefox: Change search engine from Google.'"
        "script:Log 'Firefox: Import DuckDuckGo settings.'"
        "script:Log 'Firefox: Run Checkmarks (Ctrl+H)'"
        "script:Log 'Firefox: Customize toolbar: Remove `"Account`", `"Save to Pocket`" & `"Import bookmarks`". Pin Simple Tab Groups & uBlock Origin.'"
        "script:Log 'Firefox: Configure browser extensions: Augmented Steam, Bypass Paywalls Clean (Disable `"Enable new sites by default`"), Dark Reader, FFZ (manually enable 7TV, BTTV, Inline Tab-Completion & First Message Highlight add-ons), KeePassXC, LibRedirect, uBlock Origin, Violentmonkey.'"
    )
    "Flameshot" = @(
        "choco install flameshot -y"
        "scoop install extras/flameshot"
        "winget install --id=Flameshot.Flameshot --exact --accept-source-agreements --accept-package-agreements"
        "New-Item -ItemType Directory '$env:APPDATA\Flameshot' -Force | Out-Null"
        "Copy-Item '$(Split-Path $PSScriptRoot)\Cross-Platform\Flameshot\Flameshot.ini' -Destination '$env:APPDATA\Flameshot' -Force"
        "`$flameshotini = Get-Content '$env:APPDATA\Flameshot\Flameshot.ini' "
        "`$flameshotini = `$flameshotini -replace 'screenshot-path-here', '$env:USERPROFILE\Pictures\Screenshots'"
        "`$flameshotini = `$flameshotini -replace 'imgur-client-id-here', `$script:imgurClientID"
        "`$flameshotini | Set-Content '$env:APPDATA\flameshot\Flameshot.ini' -Force"
    )
    "Flash-enabled Chromium" = @(
        "choco install ungoogled-chromium --version=87.0.4280.1411 -y"
        "winget install --id=eloston.ungoogled-chromium -v '87.0.4280.67' --exact --accept-source-agreements --accept-package-agreements"
        "`$apiUrl = 'https://gitlab.com/api/v4/projects/cleanflash%2Finstaller/releases'"
        "`$response = Invoke-RestMethod -Uri `$apiUrl"
        "`$latestCleanFlashRelease = `$response | Select-Object -First 1"
        "`$latestCleanFlashDownload = `$latestCleanFlashRelease.assets.links.direct_asset_url"
        "try {
            `$tempPath = [System.IO.Path]::GetTempPath() + 'CleanFlashInstaller.exe'
            Invoke-WebRequest `$latestCleanFlashDownload -OutFile `$tempPath
            Start-Process `$tempPath
        } catch {
            script:Log 'CleanFlash: Failed to download installer, opening download page in browser.'
            `$firefox = es -i -n 1 -r '\.exe$' 'firefox.exe'
            if (`$firefox) {
                Start-Process `$firefox -Args `"-new-tab `$latestCleanFlashDownload`"
            } else {
                Start-Process `$latestCleanFlashDownload 
            }
        }"
    )
    "Flashpoint Infinity" = @(
        # "choco install flashpoint-infinity -y"
        "scoop install games/flashpoint"
    )
    "FlicFlac" = @(
        "choco install flicflac -y"
        "scoop install bergbok/flicflac"
    )
    "FreeTube" = @(
        "choco install freetube --pre -y"
        # "scoop install extras/freetube" # taskbar entry
        "winget install --id=PrestonN.FreeTube --exact --accept-source-agreements --accept-package-agreements"
        "New-Item -ItemType Directory '$env:APPDATA\FreeTube' -Force | Out-Null"
        "Copy-Item '$(Split-Path $PSScriptRoot)\Cross-Platform\FreeTube\settings.db' -Destination '$env:APPDATA\FreeTube' -Force"
        "gdown `$script:freetubeDataGDriveID"
        "script:Expand-7zArchive '.\FreeTube.7z'"
        "Remove-Item '.\FreeTube.7z'"
        "Copy-Item '.\FreeTube\*' -Destination '$env:APPDATA\FreeTube' -Recurse -Force"
        "Remove-Item '.\FreeTube' -Recurse -Force"
        "if (Get-Command syncthing -ErrorAction SilentlyContinue) {
            Set-Content '$env:APPDATA\FreeTube\.stignore' '!/history.db`n!/playlists.db`n!/profiles.db`n!/settings.db`n*'
            syncthing cli config folders add --id 'kqgmu-jazfm' --label 'FreeTube' --path '$env:APPDATA\FreeTube'
        }"
    )
    "FreeTube (Custom)" = @(
        "& `"$PSScriptRoot\Scripts\Build-Themed-FreeTube.ps1`""
        "Set-Location '$PSScriptRoot'"
        "New-Item -ItemType Directory '$env:APPDATA\FreeTube' -Force | Out-Null"
        "Copy-Item '$(Split-Path $PSScriptRoot)\Cross-Platform\FreeTube\settings.db' -Destination '$env:APPDATA\FreeTube' -Force"
        "gdown `$script:freetubeDataGDriveID"
        "script:Expand-7zArchive '.\FreeTube.7z'"
        "Remove-Item '.\FreeTube.7z'"
        "Copy-Item '.\FreeTube\*' -Destination '$env:APPDATA\FreeTube' -Recurse -Force"
        "Remove-Item '.\FreeTube' -Recurse -Force"
        "if (Get-Command syncthing -ErrorAction SilentlyContinue) {
            Set-Content '$env:APPDATA\FreeTube\.stignore' '!/history.db`n!/playlists.db`n!/profiles.db`n!/settings.db`n*'
            syncthing cli config folders add --id 'kqgmu-jazfm' --label 'FreeTube' --path '$env:APPDATA\FreeTube'
        }"
    )
    "G.Skill Trident Z Lighting Control" = @(
        "scoop install bergbok/g.skill-trident-z-lighting-control"
        "Start-Sleep -Seconds 5"
        "Get-Process -Name 'G.SKILL Trident Z Lighting Control *.tmp' -ErrorAction SilentlyContinue | Stop-Process"
        "New-Item -ItemType Directory '$env:USERPROFILE\AppData\Roaming\G.SKILL\Trident Z Lighting Control' -Force | Out-Null"
        "Copy-Item '$PSScriptRoot\Configs\G.Skill-Trident-Z-Lighting-Control\config' -Destination '$env:USERPROFILE\AppData\Roaming\G.SKILL\Trident Z Lighting Control' -Force"
    )
    "gdown" = @(
        "pip install gdown"
    )
    "GifCam" = @(
        "choco install gifcam -y"
        "scoop install extras/gifcam"
    )
    "Gifsicle" = @(
        "choco install gifsicle -y"
        "scoop install main/gifsicle"
    )
    "GIMP" = @(
        "choco install gimp -y"
        "scoop install extras/gimp"
        "winget install --id=GIMP.GIMP --exact --accept-source-agreements --accept-package-agreements"
    )
    "git" = @(
        # "choco install git -y"
        # "scoop install main/git"
        # "winget install --id=Git.Git --exact --accept-source-agreements --accept-package-agreements"
        "git config --global user.email `$script:gitEmail"
        "git config --global user.name `$script:gitName"
        "if (-not (git config --global user.signingKey)) { 
            `$gpg = (Get-Command gpg -ErrorAction SilentlyContinue).Source
            if (-not `$gpg) { `$gpg = es -i -n 1 -r '\.exe$' 'gpg.exe' }
            if (`$gpg) {
                git config --global gpg.program `$gpg
                git config --global commit.gpgSign true
                git config --global tag.gpgSign true
                `$content = `"%echo Generating GPG key...
                    Key-Type: `$gpgKeyType
                    Key-Length: `$gpgKeyLength
                    Key-Curve: `$gpgKeyCurve
                    Subkey-Type: `$gpgSubkeyType
                    Subkey-Length: `$gpgSubkeyLength
                    Subkey-Curve: `$gpgSubkeyCurve
                    Passphrase: `$gpgPassphrase
                    Name-Real: `$gpgNameReal
                    Name-Email: `$gpgNameEmail
                    Expire-Date: `$gpgExpireDate
                    %commit
                    %echo done`"
                New-Item .\gpg.temp -ItemType File -Value `$content -Force | Out-Null
                `$gpgOutput = & `$gpg --batch --generate-key .\gpg.temp 2>&1
                `$gpgOutput = `$gpgOutput -join '`n'
                if (`$gpgOutput -match '([A-Z0-9])+(?=\.rev)') {
                    `$keyFingerprint = `$matches[0]
                    git config --global user.signingkey `$keyFingerprint
                    `$pubkey = & `$gpg --export --armor `$keyFingerprint
                    script:Log `"GPG key:`n`$pubkey`"
                    Set-Clipboard `$pubkey
                    Start-Process 'https://github.com/settings/gpg/new'
                }
                Remove-Item .\gpg.temp -Force
            } else {
                Write-Warning `"gpg.exe not found, couldn't set up git gpg signing`"
            }
        }"
        "if (Get-Command code -ErrorAction SilentlyContinue) {
            git config --global core.editor code
        } else {
            script:Log 'git: Could not set core.editor to VSCode.' 
        }"
    )
    "git filter-repo" = @(
        # "scoop install main/git-filter-repo"
        "pip install git-filter-repo"
    )
    "GitHub CLI" = @(
        "choco install gh -y"
        "scoop install main/gh"
        "winget install --id=GitHub.cli --exact --accept-source-agreements --accept-package-agreements"
    )
    "GitHub Desktop" = @(
        "choco install github-desktop -y"
        "scoop install extras/github"
        "winget install --id=GitHub.GitHubDesktop --exact --accept-source-agreements --accept-package-agreements"
    )
    "Go" = @(
        "choco install go -y"
        "scoop install main/go"
        "winget install --id=GoLang.Go --exact --accept-source-agreements --accept-package-agreements"
    )
    "Godot" = @(
        "choco install godot -y"
        # "scoop install extras/godot" # taskbar entry
        "winget install --id=GodotEngine.GodotEngine --exact --accept-source-agreements --accept-package-agreements"
    )
    "Godot (Mono)" = @(
        "choco install godot-mono -y"
        # "scoop install extras/godot-mono" # taskbar entry
        "winget install --id=GodotEngine.GodotEngine.Mono --exact --accept-source-agreements --accept-package-agreements"
    )
    "Gpg4win" = @(
        "choco install gpg4win -y"
        "scoop install extras/gpg4win; Add-EnvPath '$env:USERPROFILE\scoop\apps\git\current\usr\bin'"
        "winget install --id=GnuPG.Gpg4win --exact --accept-source-agreements --accept-package-agreements"
        "`$gpg = (Get-Command gpg -ErrorAction SilentlyContinue).Source"
        "if (-not `$gpg) { `$gpg = es -i -n 1 -r '\.exe$' 'gpg.exe' }"
        "Start-Process `$gpg -Args '--daemon' -WindowStyle Hidden"
        "`$keyboxd = (Get-Command keyboxd -ErrorAction SilentlyContinue).Source"
        "if (-not `$keyboxd) { `$keyboxd = es -i -n 1 -r '\.exe$' 'keyboxd.exe' }"
        "Start-Process `$keyboxd -Args '--daemon' -WindowStyle Hidden"
    )
    "CPUID HWMonitor" = @(
        "choco install hwmonitor -y"
        "scoop install extras/hwmonitor"
        "winget install --id=CPUID.CPUID HWMonitor --exact --accept-source-agreements --accept-package-agreements"
    )
    "HandBrake" = @(
        "choco install handbrake -y"
        "scoop install extras/handbrake"
        "winget install --id=HandBrake.HandBrake --exact --accept-source-agreements --accept-package-agreements"
    )
    "HeidiSQL" = @(
        "choco install heidisql -y"
        "scoop install extras/heidisql"
        "winget install --id=HeidiSQL.HeidiSQL --exact --accept-source-agreements --accept-package-agreements"
    )
    "HypnOS Cursor" = @(
        "gdown `$script:hypnosCursorGDriveID"
        "script:Expand-7zArchive '.\HypnOS-Cursor.7z'"
        "Remove-Item .\HypnOS-Cursor.7z"
        "script:Install-Cursor (Get-ChildItem '.\HypnOS-Cursor\HypnOS-1x\install.inf').FullName"
        "script:Install-Cursor (Get-ChildItem '.\HypnOS-Cursor\HypnOS-2x\install.inf').FullName"
        "Start-Sleep -Seconds 1"
        "Remove-Item .\HypnOS-Cursor -Recurse"
        "Start-Process 'rundll32.exe' -Args 'shell32.dll,Control_RunDLL main.cpl,,1'"
    )
    "IconsExtract" = @(
        "choco install iconsext -y"
        "scoop install nirsoft/iconsext"
    )
    "iCloud" = @(
        "choco install icloud -y"
        "winget install --id=Apple.iCloud --exact --accept-source-agreements --accept-package-agreements"
        "`$shell = New-Object -ComObject Shell.Application"
        "(`$shell.Namespace('shell:::{679f85cb-0220-4080-b29b-5540cc05aab6}').Items() | Where-Object {`$_.Path -eq '$env:USERPROFILE\iCloudDrive'}).InvokeVerb('unpinfromhome')"
        "(`$shell.Namespace('shell:::{679f85cb-0220-4080-b29b-5540cc05aab6}').Items() | Where-Object {`$_.Name -eq 'iCloud Photos'}).InvokeVerb('unpinfromhome')"
        "Remove-Item 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{F0D63F85-37EC-4097-B30D-61B4A8917118}' -Force"
        "script:Log 'iCloud: If you get `"Your computer is missing Media features.`" even though it is installed you may need to use Orca to modify iCloud64.msi (remove the `"Installed OR MS_MEDIAFEATUREPACK_INSTALLED OR IGNORE_MEDIAFEATUREPACK`" condition from the LaunchCondition table). You can find iCloud64.msi in TEMP while the installer is running.'"
    )
    "iCUE" = @(
        "choco install icue -y"
        "winget install --id=Corsair.iCUE.5 --exact --accept-source-agreements --accept-package-agreements"
        "`$tempPath = [System.IO.Path]::GetTempPath()"
        "Copy-Item '$PSScriptRoot\Configs\iCUE\*' -Destination `$tempPath -Force"
        "`$defaultProfile = Get-Content `"`$tempPath\Default.cueprofile`""
        "`$defaultProfile = `$defaultProfile -replace 'userprofile-here', '$env:USERPROFILE'"
        "`$defaultProfile = `$defaultProfile -replace 'windir-here', '$env:WINDIR'"
        "`$defaultProfile | Set-Content `"`$tempPath\Default.cueprofile`""
        "script:Log `"iCUE: Import profiles from `$tempPath`""
    )
    "ImageGlass" = @(
        # "choco install imageglass -y"
        # "scoop install extras/imageglass; script:Log `"ImageGlass: If this app doesn't work maybe you need to clean '$env:USERPROFILE\scoop\apps\imageglass\current\igconfig.json' and reinstall '$env:USERPROFILE\scoop\apps\imageglass\current\Themes'`"" # doesn't show an option in ms-settings:defaultapps
        "winget install --id=DuongDieuPhap.ImageGlass --exact --accept-source-agreements --accept-package-agreements"
        "script:Log 'ImageGlass: Set as default photo viewer in settings -> ms-settings:defaultapps'"
        "Start-Process ms-settings:defaultapps"
    )
    "itch" = @(
        "choco install itch -y"
        "scoop install games/itch"
        "winget install --id=ItchIo.Itch --exact --accept-source-agreements --accept-package-agreements"
    )
    "iTunes" = @(
        "choco install itunes -y"
        "winget install --id=Apple.iTunes --exact --accept-source-agreements --accept-package-agreements"
    )
    "JDownloader" = @(
        "choco install jdownloader -y"
        "scoop install versions/jdownloader"
        "winget install --id=AppWork.JDownloader --exact --accept-source-agreements --accept-package-agreements"
    )
    "Jitterbugpair" = @(
        "scoop install bergbok/jitterbugpair"
    )
    "KDE Connect" = @(
        "choco install kdeconnect-kde -y"
        "scoop install extras/kdeconnect"
        "winget install --id=KDE.KDEConnect --exact --accept-source-agreements --accept-package-agreements"
    )
    "KeePassXC" = @(
        "choco install keepassxc -y"
        # "scoop install extras/keepassxc" # taskbar entry
        "winget install --id=KeePassXCTeam.KeePassXC --exact --accept-source-agreements --accept-package-agreements"
        "Start-Sleep -Seconds 1"
        "`$keepassxc = es -i -n 1 -r '\.exe$' 'KeePassXC.exe'"
        "Start-Process `$keepassxc"
        "New-Item -ItemType Directory '$env:USERPROFILE\Documents\KeePass' -Force | Out-Null"
        "if (Get-Command syncthing -ErrorAction SilentlyContinue) {
            Set-Content '$env:USERPROFILE\Documents\KeePass\.stignore' 'desktop.ini'
            syncthing cli config folders add --id 'fxxre-9vvua' --label 'KeePass' --path '$env:USERPROFILE\Documents\KeePass'
        }"
        "script:Log 'KeePassXC: Enable auto startup, browser integration, and pair with browser extension.'"
    )
    "khinsider.py" = @(
        "git clone 'https://github.com/obskyr/khinsider.git' '$env:USERPROFILE\Code\Scripts\Python\khinsiderdl'"
        "Remove-Item '$env:USERPROFILE\Code\Scripts\Python\khinsiderdl\.gitignore' -ErrorAction SilentlyContinue"
        "Remove-Item '$env:USERPROFILE\Code\Scripts\Python\khinsiderdl\README.md' -ErrorAction SilentlyContinue"
    )
    "Legendary" = @(
        "choco install legendary -y"
        "scoop install games/legendary"
        "winget install --id=derrod.legendary --exact --accept-source-agreements --accept-package-agreements"
    )
    "LibreHardwareMonitor" = @(
        "choco install librehardwaremonitor -y"
        "scoop install extras/librehardwaremonitor"
        "winget install --id=LibreHardwareMonitor.LibreHardwareMonitor --exact --accept-source-agreements --accept-package-agreements"
    )
    "LibreOffice" = @(
        "choco install libreoffice-fresh -y"
        "scoop install extras/libreoffice"
        "winget install --id=TheDocumentFoundation.LibreOffice --exact --accept-source-agreements --accept-package-agreements"
    )
    "Lightshot" = @(
        "choco install lightshot.install -y"
        "scoop install versions/lightshot"
        "winget install --id=Skillbrains.Lightshot --exact --accept-source-agreements --accept-package-agreements"
    )
    "Lime3DS" = @(
        "scoop install games/lime3ds"
    )
    "Logitech G HUB" = @(
        # "choco install lghub -y" # floods terminal with output until the installer finishes
        "winget install --id=Logitech.GHUB --exact --accept-source-agreements --accept-package-agreements"
    )
    "Lumafly" = @(
        "scoop install bergbok/lumafly"
        "Start-Process '$env:USERPROFILE\scoop\apps\lumafly\current\Lumafly.exe' -Args 'scarab://modpack/mPP6enEq'"
    )
    "Majora's Mask" = @(
        "scoop install bergbok/zelda64recompiled"
    )
    "Media Feature Pack" = @(
        "Add-WindowsCapability -Online -Name Media.MediaFeaturePack"
    )
    "melonDS" = @( 
        # "scoop install games/melonds"
        "winget install --id=melonDS.melonDS --exact --accept-source-agreements --accept-package-agreements"
    )
    "Microsoft Activation Scripts" = @(
        "Start-Process powershell -WindowStyle Hidden -Args `"Invoke-RestMethod 'https://get.activated.win' | Invoke-Expression`""
        "script:Log 'MAS: Use option 1, keep window open if you selected Microsoft Office.'"
    )
    "Microsoft Office" = @(
        # "scoop install nonportable/office-365-apps-minimal-np"
        "Invoke-WebRequest 'https://officecdn.microsoft.com/pr/wsus/setup.exe' -OutFile '.\setup.exe'"
        "Start-Process '.\setup.exe' -Args '/configure `"$PSScriptRoot\Configs\Microsoft-Office\Configuration.xml`"' -Wait"
        "Remove-Item '.\setup.exe'"
    )
    "Minecraft Font" = @(
        "Invoke-WebRequest 'https://dl.dafont.com/dl/?f=minecraft' -OutFile '.\Minecraft-Font.zip'"
        "Expand-Archive '.\Minecraft-Font.zip' -DestinationPath '.' -Force"
        "Remove-Item '.\Minecraft-Font.zip'"
        "script:Install-FontFile (Get-ChildItem '.\Minecraft.ttf').FullName"
        "Remove-Item '.\Minecraft.ttf' -Force"
    )
    "Minecraft Launcher" = @(
        "choco install minecraft-launcher -y"
        "scoop install games/minecraft"
        "winget install --id=Mojang.MinecraftLauncher --exact --accept-source-agreements --accept-package-agreements"
    )
    "MegaBasterd" = @(
        "scoop install extras/megabasterd; scoop install java/openjdk"
    )
    "Meslo Nerd Font" = @(
        "scoop install nerd-fonts/Meslo-NF"
    )
    "Mp3tag" = @(
        "choco install mp3tag -y"
        # "scoop install extras/mp3tag; script:Log 'Mp3tag: Enable context menu with: start regsvr32 -Verb RunAs -Args @(`"$env:USERPROFILE\scoop\apps\mp3tag\current\Mp3tagShell.dll`" `"/s`")'; script:Log 'Mp3tag: Disable context menu with: start regsvr32 -Verb RunAs -Args @(`"/u`", `"$env:USERPROFILE\scoop\apps\mp3tag\current\Mp3tagShell.dll`", `"/s`")'" # taskbar entry
        "winget install --id=FlorianHeidenreich.Mp3tag --exact --accept-source-agreements --accept-package-agreements"
        "gdown `$script:mp3tagConfigGDriveID"
        "script:Expand-7zArchive '.\Mp3tag.7z'"
        "Remove-Item '.\Mp3tag.7z'"
        "if (scoop list | Select-String -Pattern 'mp3tag' -SimpleMatch) {
            Copy-Item '.\Mp3tag\*' -Destination '$env:USERPROFILE\scoop\persist\mp3tag' -Recurse -Force
            Remove-Item '$env:USERPROFILE\scoop\apps\mp3tag\current\data\actions\*'
            Copy-Item '$PSScriptRoot\Configs\Mp3tag\*' -Destination '$env:USERPROFILE\scoop\apps\mp3tag\current' -Recurse -Force
        } else {
            New-Item -ItemType Directory '$env:APPDATA\Mp3tag' -Force | Out-Null
            Copy-Item '.\Mp3tag\*' -Destination '$env:APPDATA\Mp3tag' -Recurse -Force
            Copy-Item '$PSScriptRoot\Configs\Mp3tag\*' -Destination '$env:APPDATA\Mp3tag' -Recurse -Force
        }"
        "Remove-Item '.\Mp3tag' -Recurse -Force"
    )
    "mpv" = @(
        "choco install mpv -y"
        "scoop install extras/mpv; script:Log 'mpv: You can use Icaros (nonportable/icaros-np) to enable thumbnails for all media types.'"
        "winget install --id=mpv.net --exact --accept-source-agreements --accept-package-agreements"
    )
    "MultiMonitorTool" = @(
        "choco install multimonitortool -y"
        "scoop install nirsoft/multimonitortool"
    )
    "NAPS2" = @(
        "choco install naps2 -y"
        "scoop install extras/naps2"
        "winget install --id=Cyanfish.NAPS2 --exact --accept-source-agreements --accept-package-agreements"
    )
    "Neofetch" = @(
        "scoop install main/neofetch"
        "winget install --id=nepnep.neofetch-win --exact --accept-source-agreements --accept-package-agreements"
    )
    "Network Sharing" = @(
        "Set-NetFirewallRule -DisplayGroup 'Network Discovery' -Enabled True"
        "Set-NetFirewallRule -DisplayGroup 'File and Printer Sharing' -Enabled True"
        "shrpubw"
    )
    "Nicotine+" = @(
        "choco install nicotine-plus -y"
        # "scoop install extras/nicotine-plus" # taskbar entry
        "winget install --id=Nicotine+.Nicotine+ --exact --accept-source-agreements --accept-package-agreements"
    )
    "NirCmd" = @(
        "choco install nircmd -y"
        "scoop install main/nircmd"
        "winget install --id=NirSoft.NirCmd --exact --accept-source-agreements --accept-package-agreements"
    )
    "Node.js" = @(
        "choco install nodejs -y"
        "scoop install main/nodejs"
        "winget install --id=OpenJS.NodeJS --exact --accept-source-agreements --accept-package-agreements"
    )
    "NoPayStation" = @(
        "scoop install bergbok/nopaystation; scoop install bergbok/pkg2zip"
        "Copy-Item '$PSScriptRoot\Configs\NoPayStation\npsSettings.dat' -Destination '$env:USERPROFILE\scoop\persist\nopaystation'"
        "script:Log `"NoPayStation: You need to manually set download location and pkg2zip path to '`$(scoop prefix pkg2zip)\pkg2zip.exe' in settings.`""
    )
    "Notepad++" = @(
        "choco install notepadplusplus.install -y"
        # "scoop install extras/notepadplusplus" # taskbar entry
        "winget install --id=Notepad++.Notepad++ --exact --accept-source-agreements --accept-package-agreements"
        "New-Item -ItemType Directory '$env:USERPROFILE\scoop\persist\notepadplusplus\cloud' -Force | Out-Null"
        "Copy-Item '$PSScriptRoot\Configs\Notepad++\*' -Destination '$env:USERPROFILE\scoop\persist\notepadplusplus\cloud' -Force -Recurse"
        "script:Log 'Notepad++: You need to manually import settings by going to Settings -> Preferences -> Cloud & Link and setting the path to: `"$env:USERPROFILE\scoop\persist\notepadplusplus\cloud`" and set up file associations (launch as admin).'"
    )
    "NVIDIA Drivers" = @(
        "Start-Process 'https://www.nvidia.com/en-us/drivers'"
    )
    "NZXT CAM" = @(
        "choco install nzxt-cam -y"
        "winget install --id=NZXT.CAM --exact --accept-source-agreements --accept-package-agreements"
    )
    "OBS Studio" = @(
        "choco install obs-studio.install -y"
        "scoop install extras/obs-studio; Start-Process '$env:USERPROFILE\scoop\apps\obs-studio\current\data\obs-plugins\win-dshow\virtualcam-install.bat'"
        "winget install --id=OBSProject.OBSStudio --exact --accept-source-agreements --accept-package-agreements"
        "if (scoop list | Select-String -Pattern 'obs-studio') {
            `$confPath = '$env:USERPROFILE\scoop\persist\obs-studio\config\obs-studio'
        } else {
            `$confPath = '$env:APPDATA\obs-studio'
        }"
        "New-Item -ItemType Directory -Path `$confPath -Force | Out-Null"
        "New-Item -ItemType Directory -Path `"`$confPath\basic`" -Force | Out-Null"
        "New-Item -ItemType Directory -Path `"`$confPath\scripts`" -Force | Out-Null"
        "Invoke-Webrequest 'https://gitlab.com/albinou/obs-scripts/raw/master/datetime.lua' -OutFile `"`$confPath\scripts\datetime-digital-clock.lua`""
        "Invoke-Webrequest 'https://github.com/cg2121/obs-advanced-timer/releases/latest/download/advanced-timer.lua' -OutFile `"`$confPath\scripts\advanced-timer.lua`""
        "Invoke-Webrequest 'https://obsproject.com/forum/resources/obsplay-nvidia-shadowplay-alternative.1326/download' -OutFile `"`$confPath\scripts\OBSPlay.lua`""
        "Invoke-Webrequest 'https://raw.githubusercontent.com/obsproject/obs-studio/refs/heads/master/UI/frontend-plugins/frontend-tools/data/scripts/instant-replay.lua' -OutFile `"`$confPath\scripts\instant-replay.lua`""
        "Copy-Item '$(Split-Path $PSScriptRoot)\Cross-Platform\OBS-Studio\*' -Destination `"`$confPath\basic`" -Recurse -Force"
        "`$scenes = Get-Content `"`$confPath\basic\scenes\Main.json`""
        "`$scenes = `$scenes -replace 'advanced-timer-script-path-here', (`"`$confPath\scripts\advanced-timer.lua`" -replace '\\', '/')"
        "`$scenes = `$scenes -replace 'datetime-script-path-here', (`"`$confPath\scripts\datetime-digital-clock.lua`" -replace '\\', '/')"
        "`$scenes = `$scenes -replace 'obsplay-script-path-here', (`"`$confPath\scripts\OBSPlay.lua`" -replace '\\', '/')"
        "`$scenes = `$scenes -replace 'instant-replay-script-path-here', (`"`$confPath\scripts\instant-replay.lua`" -replace '\\', '/')"
        "`$scenes = `$scenes -replace 'save-path-here', '$("$env:USERPROFILE\Videos" -replace '\\', '/')'"
        "`$scenes | Set-Content `"`$confPath\basic\scenes\Main.json`""
        "`$basic = Get-Content `"`$confPath\basic\profiles\Main\basic.ini`""
        "`$basic = `$basic -replace 'save-path-here', '$("$env:USERPROFILE\Videos" -replace '\\', '/')'"
        "`$basic | Set-Content `"`$confPath\basic\profiles\Main\basic.ini`""
    )
    "Obsidian" = @(
        "choco install obsidian -y"
        # "scoop install extras/obsidian" # taskbar entry
        "winget install --id=Obsidian.Obsidian --exact --accept-source-agreements --accept-package-agreements"
        "New-Item -ItemType Directory '$env:USERPROFILE\Documents\Obsidian' -Force | Out-Null"
        "Start-Process 'https://github.com/Bergbok/Obsidian-Vault'"
        "if (Get-Command syncthing -ErrorAction SilentlyContinue) {
            syncthing cli config folders add --id 'd4xqu-hqmrt' --label 'Obsidian' --path '$env:USERPROFILE\Documents\Obsidian'
        }"
    )
    "oh-my-posh" = @(
        "choco install oh-my-posh -y"
        "scoop install main/oh-my-posh"
        "winget install --id=JanDeDobbeleer.OhMyPosh --exact --accept-source-agreements --accept-package-agreements"
        "New-Item -ItemType Directory '$env:USERPROFILE\Themes\oh-my-posh' -Force | Out-Null"
        "Copy-Item '$(Split-Path $PSScriptRoot)\Cross-Platform\oh-my-posh\*' -Destination '$env:USERPROFILE\Themes\oh-my-posh' -Force"
    )
    "onefetch" = @(
        "choco install onefetch -y"
        "scoop install extras/onefetch"
        "winget install --id=o2sh.onefetch --exact --accept-source-agreements --accept-package-agreements"
    )
    "Open-Shell" = @(
        "choco install open-shell -y"
        "scoop install nonportable/open-shell-np"
        "winget install --id=Open-Shell.Open-Shell-Menu --exact --accept-source-agreements --accept-package-agreements"
        "New-Item -ItemType Directory '$env:APPDATA\OpenShell\Pinned' -Force | Out-Null"
        "`$shortcuts = @{
            'calibre.lnk' = @{ target = 'calibre.exe'; scoopName = 'calibre' }
            'DS4Windows.lnk' = @{ target = 'DS4Windows.exe'; scoopName = 'ds4windows-maintained' }
            'Emulators\ares.lnk' = @{ target = 'ares.exe'; scoopName = 'ares' }
            'Emulators\CEMU.lnk' = @{ target = 'Cemu.exe'; scoopName = 'cemu' }
            'Emulators\Dolphin.lnk' = @{ target = 'Dolphin.exe'; scoopName = 'dolphin' }
            'Emulators\DuckStation.lnk' = @{ target = 'duckstation*.exe'; scoopName = 'duckstation' }
            'Emulators\Lime3DS.lnk' = @{ target = 'lime3ds.exe'; scoopName = 'lime3ds' }
            'Emulators\melonDS.lnk' = @{ target = 'melonDS.exe'; scoopName = 'melonds' }
            'Emulators\PCSX2.lnk' = @{ target = 'pcsx2-qt.exe'; scoopName = 'pcsx2' }
            'Emulators\PPSSPP.lnk' = @{ target = 'PPSSPPWindows64.exe'; scoopName = 'ppsspp' }
            'Emulators\RPCS3.lnk' = @{ target = 'rpcs3.exe'; scoopName = 'rpcs3' }
            'Emulators\Ruffle.lnk' = @{ target = 'ruffle.exe'; scoopName = 'ruffle' }
            'Emulators\Ryujinx.lnk' = @{ target = 'Ryujinx.exe'; scoopName = 'ryujinx' }
            'Emulators\SameBoy.lnk' = @{ target = 'sameboy.exe'; scoopName = 'sameboy' }
            'Emulators\Vita3K.lnk' = @{ target = 'Vita3K.exe'; scoopName = 'vita3k' }
            'ER Save Manager.lnk' = @{ target = 'SaveManager.exe'; scoopName = 'secureuxtheme' }
            'f.lux.lnk' = @{ target = 'flux.exe'; scoopName = 'f.lux' }
            'GIF Cam.lnk' = @{ target = 'GifCam.exe'; scoopName = 'gifcam' }
            'HWMonitor.lnk' = @{ target = 'HWMonitor.exe'; scoopName = 'hwmonitor' }
            'Libre HWMonitor.lnk' = @{ target = 'LibreHardwareMonitor.exe'; scoopName = 'librehardwaremonitor' }
            'Open Shell\Classic Explorer Settings.lnk' = @{ target = 'ClassicExplorerSettings.exe' }
            'Open Shell\Start Menu Settings.lnk' = @{ target = 'StartMenu.exe'; args = '-settings' }
            'PowerToys.lnk' = @{ target = 'PowerToys.Settings.exe'; scoopName = 'powertoys' }
            'SecureUxTheme.lnk' = @{ target = 'ThemeTool.exe'; scoopName = 'secureuxtheme' }
            'Task Scheduler.lnk' = @{ target = '$env:WINDIR\system32\taskschd.msc'; args = '/s' }
            'TaskbarX.lnk' = @{ target = 'TaskbarX.exe'; scoopName = 'taskbarx' }
        }"
        "foreach (`$entry in `$shortcuts.Keys) {
            `$shortcut = `$shortcuts[`$entry]
            `$targetPath = script:Get-ShortcutPath `$shortcut.target -scoopName `$shortcut.scoopName
            script:New-Shortcut -linkPath `"$env:APPDATA\OpenShell\Pinned\`$entry`" -targetPath `$targetPath -arguments `$shortcut.args
        }"
        "Invoke-WebRequest 'https://i.imgur.com/Dc7ljTj.png' -OutFile '$env:USERPROFILE\Pictures\Transparent.png'"
        "Start-Process (es -i -n 1 -r '\.exe$' 'ClassicExplorerSettings.exe') -Args '-xml `"$PSScriptRoot\Configs\Open-Shell\Explorer Settings.xml`"'"
        "Start-Process (es -i -n 1 -r '\.exe$' 'StartMenu.exe') -Args '-xml `"$PSScriptRoot\Configs\Open-Shell\Menu Settings.xml`"'"
    )
    "OpenRGB" = @(
        "choco install openrgb -y"
        "scoop install extras/openrgb"
        "winget install --id=CalcProgrammer1.OpenRGB --exact --accept-source-agreements --accept-package-agreements"
    )
    "OpenWithView" = @(
        "choco install openwithview -y"
        "scoop install nirsoft/openwithview"
    )
    "Orca" = @(
        "choco install orca -y"
        "scoop install extras/orca"
    )
    "osu!" = @(
        "choco install osu -y"
        "scoop install games/osulazer"
        "winget install --id=ppy.osu --exact --accept-source-agreements --accept-package-agreements"
    )
    "PCSX2" = @(
        "choco install pcsx2 -y; scoop install bergbok/ps2-bios"
        "scoop install games/pcsx2; scoop install bergbok/ps2-bios"
        "winget install --id=PCSX2Team.PCSX2 --exact --accept-source-agreements --accept-package-agreements' scoop install bergbok/ps2-bios"
        "if (scoop list | Select-String -Pattern 'pcsx2' -SimpleMatch) {
            `$biosPath = '$env:USERPROFILE\scoop\apps\ps2-bios\current\BIOS'
            `$destinationPath = '$env:USERPROFILE\scoop\persist\pcsx2\bios'
            Remove-Item `$destinationPath -Recurse -Force
            New-Item -ItemType SymbolicLink `$destinationPath -Target `$biosPath -Force
        }"
    )
    "PeaZip" = @(
        "choco install peazip -y"
        "scoop install extras/peazip"
        "winget install --id=Giorgiotani.Peazip --exact --accept-source-agreements --accept-package-agreements"
        "`$conf = '$(Split-Path $PSScriptRoot)\Cross-Platform\Configs\PeaZip\conf.txt'"
        "if (scoop list | Select-String -Pattern 'peazip' -SimpleMatch) {
            `$destinationPath = '$env:USERPROFILE\scoop\persist\peazip\res\conf' 
        } else {
            `$destinationPath = '$env:APPDATA\PeaZip'
        }"
        "New-Item -ItemType Directory `$destinationPath -Force | Out-Null"
        "Copy-Item `$conf -Destination `$destinationPath -Recurse -Force"
        "script:Log 'PeaZip: Set extended mode for `"Browse path with PeaZip`" with ShellMenuView.'"
    )
    "Photoshop" = @(
        "Start-Process `$script:adobePhotoshopURL"
        "script:Log 'Photoshop: Be sure to disable CCXProcess in Task Manager -> Startup.'"
        "script:Log 'Photoshop: Alt+Shift+Ctrl+K -> File -> Quick Export as PNG'"
    )
    "PowerShell Update" = @(
        "winget install --id=Microsoft.PowerShell -e --accept-source-agreements --accept-package-agreements"
        "Start-Process powershell -Args 'Update-Help'"
    )
    "PowerShell Profile" = @(
        "if (!(Test-Path '$PROFILE')) {
            New-Item -ItemType File '$PROFILE' -Force | Out-Null
        }"
        "Copy-Item '$PSScriptRoot\Configs\PowerShell\Microsoft.PowerShell_profile.ps1' -Destination '$PROFILE' -Force"
        "New-Item -ItemType Directory '$env:USERPROFILE\Themes\oh-my-posh' -Force | Out-Null"
        "Copy-Item '$(Split-Path $PSScriptRoot)\Cross-Platform\oh-my-posh\*' -Destination '$env:USERPROFILE\Themes\oh-my-posh' -Force"
        "`$profileContent = Get-Content '$PROFILE'"
        "`$modifiedContent = `$profileContent -replace 'theme-path-here', '$env:USERPROFILE\Themes\oh-my-posh\current.omp.json'"
        "`$pwshVersion = Get-Command pwsh -ErrorAction SilentlyContinue | Select-Object -Property Version"
        "if (`$pwshVersion.Version.Major -ge 7) {
            if (!(Test-Path '$env:USERPROFILE\Documents\PowerShell\Microsoft.PowerShell_profile.ps1')) {
                New-Item -ItemType File '$env:USERPROFILE\Documents\PowerShell\Microsoft.PowerShell_profile.ps1' -Force | Out-Null
            }
            `$modifiedContent = `$modifiedContent -replace 'powershell-here', 'pwsh.exe'
            `$modifiedContent | Set-Content '$env:USERPROFILE\Documents\PowerShell\Microsoft.PowerShell_profile.ps1'
            `$modifiedContent | Set-Content '$env:USERPROFILE\Documents\PowerShell\Microsoft.VSCode_profile.ps1'
        } else {
            `$modifiedContent = `$modifiedContent -replace 'powershell-here', 'powershell.exe'
        }"
        "`$modifiedContent | Set-Content '$PROFILE' -Force"
        "`$modifiedContent | Set-Content '$(Split-Path $PROFILE)\Microsoft.VSCode_profile.ps1' -Force"
    )
    "PowerToys" = @(
        "choco install powertoys -y"
        # https://github.com/microsoft/PowerToys/issues/636
        "scoop install nonportable/powertoys-np"
        "winget install --id=Microsoft.PowerToys --exact --accept-source-agreements --accept-package-agreements"
        "New-Item -ItemType Directory '$env:LOCALAPPDATA\Microsoft\PowerToys' -Force | Out-Null"
        "Copy-Item '$PSScriptRoot\Configs\PowerToys\*' -Destination '$env:LOCALAPPDATA\Microsoft\PowerToys' -Recurse -Force"
        "`$runsettings = Get-Content '$PSScriptRoot\Configs\PowerToys\PowerToys Run\settings.json'"
        "`$runsettings = `$runsettings -replace 'runplugins-here', ((es -i -n 1 -r 'RunPlugins$' /ad 'PowerToys\RunPlugins') -replace '\\', '\\')"
        "`$runsettings | Set-Content '$env:LOCALAPPDATA\Microsoft\PowerToys\PowerToys Run\settings.json'"
    )
    "PPSSPP" = @(
        "choco install ppsspp -y"
        "scoop install games/ppsspp"
        "winget install --id=PPSSPPTeam.PPSSPP --exact --accept-source-agreements --accept-package-agreements"
    )
    "Premiere Pro" = @(
        "Start-Process `$script:adobePremiereProURL"
        "script:Log 'Photoshop: Be sure to disable CCXProcess in Task Manager -> Startup.'"
    )
    "Process Explorer" = @(
        "choco install procexp -y"
        "scoop install sysinternals/process-explorer"
        "winget install --id=Microsoft.Sysinternals.ProcessExplorer --exact --accept-source-agreements --accept-package-agreements"
    )
    "Process Monitor" = @(
        "choco install procmon -y"
        "scoop install sysinternals/procmon"
        "winget install --id=Microsoft.Sysinternals.ProcessMonitor --exact --accept-source-agreements --accept-package-agreements"
    )
    "Project 64" = @(
        "choco install project64 -y"
        "scoop install games/project64"
        "winget install --id=Project64.Project64 --exact --accept-source-agreements --accept-package-agreements"
    )
    "ps2exe" = @(
        "scoop install bergbok/ps2exe"
        # "Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted -SourceLocation 'https://www.powershellgallery.com/api/v2'"
        # "Install-Module -Name ps2exe -AcceptLicense"
        "New-Item -ItemType Directory '$env:USERPROFILE\Code\Scripts\ps2exe' -Force | Out-Null"
        "Add-MpPreference -ExclusionPath '$env:USERPROFILE\Code\Scripts\ps2exe'"
    )
    "PsShutdown" = @(
        "choco install psshutdown -y"
        "scoop install sysinternals/psshutdown"
    )
    "Python" = @(
        # "choco install python -y" # hangs at 'Restricting write permissions to Administrators...'
        # "scoop install main/python"//
        "winget install --id=Python.Python.3.13 --exact --accept-source-agreements --accept-package-agreements"
	"script:Update-EnvPath"
        "python -m ensurepip --upgrade"
        "python -m pip install --upgrade pip"
    )
    "qBittorrent" = @(
        "choco install qbittorrent -y"
        # "scoop install extras/qbittorrent" # taskbar entry
        "winget install --id=qbittorrent.qBittorrent --exact --accept-source-agreements --accept-package-agreements"
        "script:Log 'qBittorrent: Disable `"Check for program updates`" in settings.'"
    )
    "qBittorrent Enhanced" = @(
        "choco install qbittorrent-enhanced -y"
        # "scoop install extras/qbittorrent-enhanced" # taskbar entry
        "winget install --id=c0re100.qBittorrent-Enhanced-Edition --exact --accept-source-agreements --accept-package-agreements"
        "script:Log 'qBittorrent: Disable `"Check for program updates`" in settings.'"
    )
    "QTTabBar" = @(
        # "scoop install nonportable/qttabbar-indiff-np" # restarts PC
        "winget install --id=indiff.QTTabBar --exact --accept-source-agreements --accept-package-agreements"
        "Enable-WindowsOptionalFeature -Online -FeatureName 'NetFx3' -NoRestart"
        "Copy-Item '$PSScriptRoot\Configs\QTTabBar\QTTabBarTab.png' '$env:USERPROFILE\Pictures\System' -Force"
        "`$settings = Get-Content '$PSScriptRoot\Configs\QTTabBar\QTTabBarSettings.reg'"
        "`$settings = `$settings -replace 'tab-image-here', ('$env:USERPROFILE\Pictures\System\QTTabBarTab.png' -replace '\\', '\\')"
        "`$settings = `$settings -replace 'userprofile-here', ('$env:USERPROFILE' -replace '\\', '\\')"
        "`$plugins = @(
            'QTWindowManager',
            'TurnOffRepeat',
            'CreateNewItem',
            'QTFileTools',
            'QTQuick',
            'Memo',
            'QTClock',
            'ShowStatusBar',
            'QTViewModeButton',
            'FolderTreeButton',
            'MigemoLoader',
            'ActivateByMouseHover'
        )"
        "`$foundPluginPaths = @()"
        "foreach (`$plugin in `$plugins) {
            `$pluginPath = es -i -n 1 -r '\.dll$' `"`$plugin.dll`"
            if (`$pluginPath) {
                `$foundPluginPaths += `$pluginPath
            }
        }"
        "for (`$i = 0; `$i -lt `$foundPluginPaths.Count; `$i++) {
            `$settings += '`"' + `"`$i`" + '`"=`"' + (`$foundPluginPaths[`$i] -replace '\\', '\\') + '`"'
        }"
        "`$settings | Out-File '.\temp-QTTabBar-Settings.reg'"
        "reg import '.\temp-QTTabBar-Settings.reg' 2>`$null"
        "Remove-Item '.\temp-QTTabBar-Settings.reg'"
        "script:Log 'QTTabBar: If appearance is off, go to Options -> Appearance and set tab image to `"$env:USERPROFILE\Pictures\System\QTTabBarTab.png`", disable `"Solid color`" under Toolbar Background and change text color/font.'"
    )
    "r2modman" = @(
        "scoop install games/r2modman"
        "winget install --id=ebkr.r2modman --exact --accept-source-agreements --accept-package-agreements"
    )
    "Rainmeter" = @(
        "choco install rainmeter -y"
        "scoop install extras/rainmeter"
        "winget install --id=Rainmeter.Rainmeter --exact --accept-source-agreements --accept-package-agreements"
        "git clone 'https://github.com/JoeSiu/RainmeterAutoLayout.git'"
        "`$autolayoutVars = Get-Content .\RainmeterAutoLayout\AutoLayout\@Resources\Variables.inc"
        "`$autolayoutVars = `$autolayoutVars -replace 'LayoutMap=`".*`"', 'LayoutMap=`"4695x3324=Custom|3840x2160=CustomTV|3840x3240=CustomTV|3840x1182=CustomCENTER_DELL+LEFT_SAMSUNG|3840x1245=CustomTV_DISABLED|`"'"
        "`$autolayoutVars | Set-Content .\RainmeterAutoLayout\AutoLayout\@Resources\Variables.inc"
        "New-Item -ItemType Directory '$env:USERPROFILE\Themes\Rainmeter' -Force | Out-Null"
        "Copy-Item '.\RainmeterAutoLayout\AutoLayout' -Destination '$env:USERPROFILE\Themes\Rainmeter' -Recurse -Force"
        "Remove-Item '.\RainmeterAutoLayout' -Recurse -Force"
        "`$tempPath = [System.IO.Path]::GetTempPath() + 'Rainmeter'"
        "Copy-Item '$PSScriptRoot\Configs\Rainmeter' -Destination (Split-Path `$tempPath) -Exclude 'README.md, Skins' -Recurse -Force"
        "`$inis = Get-ChildItem `"`$tempPath`" -Name 'Rainmeter.ini' -Recurse"
        "foreach (`$ini in `$inis) {
            `$iniContent = Get-Content `"`$tempPath\`$ini`"
            `$iniContent = `$iniContent -replace 'skin-path-here', '$env:USERPROFILE\Themes\Rainmeter'
            `$iniContent = `$iniContent -replace 'skin-path-here', ((es -i -n 1 -r '\.exe$' 'Code.exe') -replace 'vscode\\[\d\.]+', 'vscode\current')
            `$iniContent | Set-Content `"`$tempPath\`$ini`" -Force
        }"
        "Invoke-WebRequest 'https://github.com/keifufu/WebNowPlaying-Rainmeter/releases/latest/download/WebNowPlaying-x64.dll' -OutFile '.\WebNowPlaying.dll' "
        "if (Test-Path '$env:APPDATA\Rainmeter') {
            Copy-Item `"`$tempPath\Rainmeter.ini`" -Destination '$env:APPDATA\Rainmeter' -Force
            New-Item -ItemType Directory '$env:APPDATA\Rainmeter\Plugins' -Force | Out-Null
            Copy-Item '.\WebNowPlaying.dll' -Destination '$env:APPDATA\Rainmeter\Plugins' -Force
            Copy-Item `"`$tempPath\Layouts`" -Destination '$env:APPDATA\Rainmeter' -Recurse -Force
        }"
        "if (scoop list | Select-String -Pattern 'rainmeter' -SimpleMatch) {
            Copy-Item `"`$tempPath\Rainmeter.ini`" -Destination '$env:USERPROFILE\scoop\persist\rainmeter' -Force
            Copy-Item '.\WebNowPlaying.dll' -Destination '$env:USERPROFILE\scoop\persist\rainmeter\Plugins' -Force
            Copy-Item `"`$tempPath\Layouts`" -Destination '$env:USERPROFILE\scoop\persist\rainmeter' -Recurse -Force
        }"
        "Remove-Item '.\WebNowPlaying.dll'"
        "Remove-Item `$tempPath -Recurse -Force"
        "Copy-Item '$PSScriptRoot\Configs\Rainmeter\Skins\*' -Destination '$env:USERPROFILE\Themes\Rainmeter' -Recurse -Force"
        "`$weatherConfPath = '$env:USERPROFILE\Themes\Rainmeter\ASTROWeather\@Resources\Variables.inc'"
        "`$weathersettings = (Get-Content `$weatherConfPath) -replace 'api-key-here', `$script:rainmeterWeatherAPIKey"
        "`$weathersettings | Set-Content `$weatherConfPath"
        "script:Log `"Rainmeter: Set latitude and longitude in `$weatherConfPath using https://www.mapcoordinates.net`""
        "Start-Process notepad `$weatherConfPath"
        "Start-Process 'https://www.mapcoordinates.net'"
        "Start-Process 'https://in-the-sky.org/data/planets.php'"
    )
    "RPCS3" = @(
        "choco install rpcs3 --pre -y; scoop install games/ps3-system-software"
        "scoop install games/rpcs3; scoop install games/ps3-system-software"
        "winget install --id=RPCS3.RPCS3 --exact --accept-source-agreements --accept-package-agreements; scoop install games/ps3-system-software"
        "gdown `$script:ps3SavesGDriveID"
        "script:Expand-7zArchive '.\PS3.7z'"
        "Remove-Item '.\PS3.7z'"
        "if (scoop list | Select-String -Pattern 'rpcs3' -SimpleMatch) {
            `$savePath = '$env:USERPROFILE\scoop\persist\rpcs3\dev_hdd0\home\00000001\savedata'
            New-Item -ItemType Directory `$savePath -Force | Out-Null
            Copy-Item '.\PS3\*' -Destination `$savePath -Recurse -Force
            if (Get-Command syncthing -ErrorAction SilentlyContinue) {
                syncthing cli config folders add --id 'pacu9-xjxpf' --label 'RPSC3' --path `$savePath
            }
        } else {
            `$rpcs3_path = es -i -n 1 -r '\.exe$' 'rpcs3.exe'
            `$savePath = `"`$(Split-Path `$rpcs3_path)\dev_hdd0\home\00000001\savedata`"
            New-Item -ItemType Directory `$savePath -Force | Out-Null
            Copy-Item '.\PS3\*' -Destination `"`$savePath`" -Recurse -Force
            if (Get-Command syncthing -ErrorAction SilentlyContinue) {
                syncthing cli config folders add --id 'pacu9-xjxpf' --label 'RPSC3' --path `$savePath
            }
        }"
        "Remove-Item '.\PS3' -Recurse -Force"
        "script:Log 'RPCS3: File -> Install Firmware -> `"$env:USERPROFILE\scoop\apps\ps3-system-software\current\PS3UPDAT.PUP`"'"
        "script:Log 'RPSC3: Disable shader compiling popups -> Config -> Emulator -> Show * compilation hint'"
    )
    "Ruby" = @(
        "choco install ruby -y"
        "scoop install main/ruby; scoop install msys2; Start-Process powershell -Args `"msys2 -c 'exit'`" -Wait; ridk install 3"
        "winget install --id=RubyInstallerTeam.RubyWithDevKit.3.1 --exact --accept-source-agreements --accept-package-agreements"
    )
    "Ruffle" = @(
        "scoop install versions/ruffle-nightly"
    )
    "Rufus" = @(
        "choco install rufus -y"
        "scoop install extras/rufus"
        "winget install --id=Rufus.Rufus --exact --accept-source-agreements --accept-package-agreements"
    )
    "Rust" = @(
        "choco install rust -y"
        "scoop install main/rust"
        "winget install --id=Rustlang.Rust.GNU --exact --accept-source-agreements --accept-package-agreements"
    )
    "RustDesk" = @(
        "choco install rustdesk -y"
        "scoop install extras/rustdesk"
        "winget install --id=RustDesk.RustDesk --exact --accept-source-agreements --accept-package-agreements"
    )
    "Rusty PSN CLI" = @(
        "scoop install bergbok/rusty-psn-cli"
    )
    "Rusty PSN GUI" = @(
        "scoop install bergbok/rusty-psn"
    )
    "Ryujinx" = @(
        # "choco install ryujinx -y"
        # "scoop install games/ryujinx"
        # "winget install --id=Ryujinx.Ryujinx --exact --accept-source-agreements --accept-package-agreements"
        "scoop install bergbok/ryujinx-mirror"
        "gdown `$script:switchFilesGDriveID"
        "script:Expand-7zArchive '.\Switch.7z'"
        "Remove-Item '.\Switch.7z'"
        "`$jsonFiles = Get-ChildItem -Path '.\Switch' -Filter '*.json' -Recurse"
        "foreach (`$file in `$jsonFiles) {
            `$fileContent = Get-Content `$file.FullName
            `$fileContent = `$fileContent -replace 'roms-path-here', '$($env:USERPROFILE -replace '\\', '\\')\\Games\\ROMs\\Switch'
            `$fileContent | Set-Content `$file.FullName
        }"
        "if (scoop list | Select-String -Pattern 'ryujinx' -SimpleMatch) {
            `$confPath = '$env:USERPROFILE\scoop\persist\ryujinx\portable'
            New-Item -ItemType Directory -Path '$env:USERPROFILE\scoop\persist\ryujinx-mirror' -Force | Out-Null
            New-Item -ItemType Directory -Path '$env:USERPROFILE\scoop\persist\ryujinx-greemdev' -Force | Out-Null
            New-Item -ItemType SymbolicLink '$env:USERPROFILE\scoop\persist\ryujinx-mirror\portable' -Target `$confPath -Force | Out-Null
            New-Item -ItemType SymbolicLink '$env:USERPROFILE\scoop\persist\ryujinx-greemdev\portable' -Target `$confPath -Force | Out-Null
        } else {
            `$confPath = '$env:APPDATA\Ryujinx'
        }"
        "New-Item -ItemType Directory `$confPath -Force | Out-Null"
        "Copy-Item '.\Switch\*' -Destination `$confPath -Recurse -Force"
        "Remove-Item '.\Switch' -Recurse -Force"
        "Copy-Item '$(Split-Path $PSScriptRoot)\Cross-Platform\Ryujinx\*' -Destination `$confPath -Force"
        "`$config = Get-Content `"`$confPath\Config.json`""
        "`$config = `$config -replace 'roms-path-here', '$($env:USERPROFILE -replace '\\', '\\')\\Games\\ROMs\\Switch'"
        "`$config | Set-Content `"`$confPath\Config.json`""
        "if (Get-Command syncthing -ErrorAction SilentlyContinue) {
           Set-Content `"`$confPath\.stignore`" 'Config.json`ngames/*/cache'
            syncthing cli config folders add --id 'z3qjr-yw9j5' --label 'Ryujinx' --path `$confPath
        }"
    )
    "SameBoy" = @(
        "choco install sameboy -y"
        "scoop install games/sameboy"
        "winget install --id=LIJI32.SameBoy --exact --accept-source-agreements --accept-package-agreements"
    )
    "scdl" = @(
        "pip install scdl"
        "New-Item -ItemType Directory '$env:USERPROFILE\Downloads\Audio\SoundCloud' -Force | Out-Null"
        "New-Item -ItemType Directory '$env:USERPROFILE\.config\scdl' -Force | Out-Null"
        "Copy-Item '$(Split-Path $PSScriptRoot)\Cross-Platform\scdl\scdl.cfg' -Destination '$env:USERPROFILE\.config\scdl' -Force"
        "(Get-Content '$env:USERPROFILE\.config\scdl\scdl.cfg') -replace 'path-here', '$env:USERPROFILE\Downloads\Audio\Soundcloud' | Set-Content '$env:USERPROFILE\.config\scdl\scdl.cfg'"
    )
    "SecureUxTheme" = @(
        "scoop install extras/secureuxtheme"
        "winget install --id=namazso.SecureUXTheme --exact --accept-source-agreements --accept-package-agreements"
    )
    "Sekiro" = @(
        "Write-Host 'Downloading Sekiro...'"
        "gdown `$script:sekiroGDriveID"
        "script:Expand-7zArchive '.\Sekiro.7z'"
        "Remove-Item '.\Sekiro.7z'"
        "Copy-Item '.\Sekiro' -Destination '$env:USERPROFILE\Games\Sekiro Shadows Die Twice GOTY Edition' -Recurse -Force"
        "Remove-Item '.\Sekiro' -Recurse -Force"
        "script:Log 'Sekiro: For autostarting unlocker with game ensure `'Local Policies/Audit Policy/Audit process tracking`' is set to `'Success`''"
    )
    "SGDBoop" = @(
        "scoop install bergbok/sgdboop"
        "Start-Process '$env:USERPROFILE\scoop\apps\sgdboop\current\SGDBoop.exe'"
        "Start-Sleep -Seconds 1"
        "Stop-Process -Name SGDBoop"
        
    )
    "ShellExView" = @(
        "choco install shexview.portable -y"
        "scoop install nirsoft/shexview"
        "winget install --id=NirSoft.ShellExView --exact --accept-source-agreements --accept-package-agreements"
        "script:Log 'ShellExView: Disable GpgEx shell extension.'"
    )
    "ShellMenuNew" = @(
        "choco install shellmenunew -y"
        "scoop install nirsoft/shellmenunew"
    )
    "ShellMenuView" = @(
        "choco install shmnview -y"
        "scoop install nirsoft/shmnview"
        "script:Log 'ShellMenuView: Set extended mode for: Take Ownership'"
    )
    "Ship of Harkinian" = @(
        "scoop install games/shipwright"
        "gdown `$script:sohGDriveID"
        "script:Expand-7zArchive '.\SoH.7z'"
        "Remove-Item '.\SoH.7z'"
        "Copy-Item '.\SoH\*' -Destination '$env:USERPROFILE\scoop\persist\shipwright' -Recurse -ErrorAction SilentlyContinue"
        "Remove-Item '.\SoH' -Recurse -Force"
    )
    "Sophia Script" = @(
        "Write-Host 'Running Sophia Script...'"
	"`$preSophiaWindowTitle = `$host.UI.RawUI.WindowTitle"
        "`$latestRelease = Invoke-RestMethod -Uri 'https://api.github.com/repos/farag2/Sophia-Script-for-Windows/releases/latest'"
        "if (`$PSVersionTable.PSVersion.Major -ge 7 -and `$PSVersionTable.PSVersion.Minor -ge 3) { 
            `$asset = `$latestRelease.assets | Where-Object { `$_.name -like 'Sophia.Script.for.Windows.10.PowerShell.7*.zip' }
        } else {
            `$asset = `$latestRelease.assets | Where-Object { `$_.name -like 'Sophia.Script.for.Windows.10.v*.zip' }
        }"
        "if (`$null -ne `$asset) {
            Invoke-WebRequest `$asset.browser_download_url -OutFile '.\SophiaScript.zip'
        } else {
            Write-Warning 'Could not download Sophia Script.'
            return
        }"
        "Expand-Archive '.\SophiaScript.zip' -DestinationPath '.\Sophia'"
        "Remove-Item '.\SophiaScript.zip'"
        "Get-ChildItem '.\Sophia' -Filter '*.psm1' -Recurse | ForEach-Object {
            `$module = Get-Content `$_.FullName
            `$module = `$module -replace '\[Windows\.UI\.Notifications\.ToastNotificationManager\]::CreateToastNotifier', '# [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier'
            `$module | Set-Content `$_.FullName
        }"
        "if (`$PSVersionTable.PSVersion.Major -ge 7 -and `$PSVersionTable.PSVersion.Minor -ge 3) { 
            Move-Item '.\Sophia\Sophia_Script_for_Windows_10_PowerShell_7_v*\*' -Destination '.\Sophia'
            Remove-Item '.\Sophia\Sophia_Script_for_Windows_10_PowerShell_7_v*'
        } else {
            Move-Item '.\Sophia\Sophia_Script_for_Windows_10_v*\*' -Destination '.\Sophia'
            Remove-Item '.\Sophia\Sophia_Script_for_Windows_10_v*'
        }"
        ". '.\Sophia\Functions.ps1'"
        # Could probably be done faster by passing all functions at once, however I kinda like the brief respite while it runs.
        "Sophia -Functions 'CreateRestorePoint'"
        "Sophia -Functions 'ActiveHours -Manually'"
        "Sophia -Functions 'AdminApprovalMode -Default'"  # UAC? off = -Never
        "Sophia -Functions 'AdvertisingID -Disable'"
        "Sophia -Functions 'AeroShaking -Disable'"
        "Sophia -Functions 'AppsLanguageSwitch -Disable'"
        "Sophia -Functions 'AppsSilentInstalling -Disable'"
        "Sophia -Functions 'AppsSmartScreen -Disable'"
        "Sophia -Functions 'AppSuggestions -Hide'"
        "Sophia -Functions 'Autoplay -Disable'"
        "Sophia -Functions 'BackgroundUWPApps -Disable'"  # Might mess with WSL
        "Sophia -Functions 'BingSearch -Disable'"
        "Sophia -Functions 'BitmapImageNewContext -Hide'"
        "Sophia -Functions 'BSoDStopError -Enable'"
        "Sophia -Functions 'CABInstallContext -Hide'"
        "Sophia -Functions 'CastToDeviceContext -Hide'"
        "Sophia -Functions 'CompressedFolderNewContext -Hide'"
        "Sophia -Functions 'CopilotButton -Hide'"
        "Sophia -Functions 'CortanaAutostart -Disable'"
        "Sophia -Functions 'CortanaButton -Hide'"
        "Sophia -Functions 'DefenderSandbox -Enable'"
        "Sophia -Functions 'DeliveryOptimization -Disable'"
        "Sophia -Functions 'DiagnosticDataLevel -Minimal'"
        "Sophia -Functions 'DiagTrackService -Disable'"
        "Sophia -Functions 'DismissMSAccount'"
        "Sophia -Functions 'DismissSmartScreenFilter'"
        "Sophia -Functions 'EditWithPaint3DContext -Hide'"
        "Sophia -Functions 'ErrorReporting -Disable'"
        "Sophia -Functions 'EventViewerCustomView -Enable'"
        "Sophia -Functions 'F1HelpPage -Disable'"
        "Sophia -Functions 'FeedbackFrequency -Never'"
        "Sophia -Functions 'FileTransferDialog -Detailed'"
        "Sophia -Functions 'FirstLogonAnimation -Disable'"
        "Sophia -Functions 'FolderGroupBy -None'"
        "Sophia -Functions 'GPUScheduling -Enable'"
        "Sophia -Functions 'HEVC -Install'"
        "Sophia -Functions 'HiddenItems -Enable'"
        "Sophia -Functions 'IncludeInLibraryContext -Hide'"
        "Sophia -Functions 'JPEGWallpapersQuality -Max'"
        "Sophia -Functions 'LanguageListAccess -Disable'"
        "Sophia -Functions 'MappedDrivesAppElevatedAccess -Enable'"
        "Sophia -Functions 'MeetNow -Hide'"
        "Sophia -Functions 'MergeConflicts -Show'"
        "Sophia -Functions 'MSIExtractContext -Hide'"
        "Sophia -Functions 'MultipleInvokeContext -Disable'"
        "Sophia -Functions 'NetworkDiscovery -Enable'"
        "Sophia -Functions 'NetworkProtection -Enable'"
        "Sophia -Functions 'NewAppInstalledNotification -Hide'"
        "Sophia -Functions 'NewsInterests -Disable'"
        "Sophia -Functions 'OneDrive -Uninstall'"
        "Sophia -Functions 'OneDriveFileExplorerAd -Hide'"
        "Sophia -Functions 'OpenFileExplorerTo -ThisPC'"
        "Sophia -Functions 'PeopleTaskbar -Hide'"
        "Sophia -Functions 'PreventEdgeShortcutCreation -Channels Stable, Beta, Dev, Canary'"
        "Sophia -Functions 'PrintCMDContext -Hide'"
        "Sophia -Functions 'PrtScnSnippingTool -Disable'"
        "Sophia -Functions 'PUAppsDetection -Enable'"
        "Sophia -Functions 'QuickAccessFrequentFolders -Hide'"
        "Sophia -Functions 'QuickAccessRecentFiles -Hide'"
        "Sophia -Functions 'RecentlyAddedApps -Hide'"
        "Sophia -Functions 'RecycleBinDeleteConfirmation -Enable'"
        "Sophia -Functions 'ReservedStorage -Disable'"
        "Sophia -Functions 'RestartNotification -Hide'"
        "Sophia -Functions 'RichTextDocumentNewContext -Hide'"
        "Sophia -Functions 'SATADrivesRemovableMedia -Disable'"
        "Sophia -Functions 'SaveRestartableApps -Disable'"
        "Sophia -Functions 'SaveZoneInformation -Disable'"
        "Sophia -Functions 'ScheduledTasks -Disable'"
        "Sophia -Functions 'SearchHighlights -Hide'"
        "Sophia -Functions 'SecondsInSystemClock -Hide'"
        "Sophia -Functions 'SettingsSuggestedContent -Hide'"
        "Sophia -Functions 'ShareContext -Hide'"
        "Sophia -Functions 'ShortcutsSuffix -Disable'"
        "Sophia -Functions 'SigninInfo -Disable'"
        "Sophia -Functions 'SnapAssist -Enable'"
        "Sophia -Functions 'StartAccountNotifications -Hide'"
        "Sophia -Functions 'StickyShift -Disable'"
        "Sophia -Functions 'StorageSense -Enable'"
        "Sophia -Functions 'StorageSenseTempFiles -Enable'"
        "Sophia -Functions 'TailoredExperiences -Disable'"
        "Sophia -Functions 'TaskbarSearch -Hide'"
        "Sophia -Functions 'TaskManagerWindow -Expanded'"
        "Sophia -Functions 'TaskViewButton -Hide'"
        "Sophia -Functions 'ThisPC -Hide'"
        "Sophia -Functions 'ThumbnailCacheRemoval -Disable'"
        "Sophia -Functions 'UninstallPCHealthCheck'"
        "Sophia -Functions 'UnpinTaskbarShortcuts -Shortcuts Edge, Store, Mail'"
        "Sophia -Functions 'UpdateMicrosoftProducts -Disable'"
        "Sophia -Functions 'UserFolders -ThreeDObjects Hide -Desktop Hide -Documents Hide -Downloads Hide -Music Hide -Pictures Hide -Videos Hide'"
        "Sophia -Functions 'UseStoreOpenWith -Hide'"
        "Sophia -Functions 'WhatsNewInWindows -Disable'"
        "Sophia -Functions 'Win32LongPathLimit -Disable'"
        "Sophia -Functions 'WindowsInkWorkspace -Hide'"
        "Sophia -Functions 'WindowsLatestUpdate -Disable'"
        "Sophia -Functions 'WindowsManageDefaultPrinter -Disable'"
        "Sophia -Functions 'WindowsSandbox -Enable'"
        "Sophia -Functions 'WindowsTips -Disable'"
        "Sophia -Functions 'WindowsWelcomeExperience -Hide'"
        "Sophia -Functions 'XboxGameBar -Disable'"
        "Sophia -Functions 'XboxGameTips -Disable'"
        "if (-not `$script:isLaptop) {
            Sophia -Functions 'Hibernation -Disable'
            Sophia -Functions 'PowerPlan -High'
        }"
        "Remove-Item '.\Sophia' -Recurse -Force"
	"`$host.UI.RawUI.WindowTitle = `$preSophiaWindowTitle"
    )
    "SoS Optimize Harden Debloat" = @(
        # I don't recommend running this on home PCs.
        "Write-Host 'Running SoS Windows Optimize Harden Debloat...'"
        "Set-Location '$PSScriptRoot'"
        "git clone 'https://github.com/simeononsecurity/Windows-Optimize-Harden-Debloat.git'"
        "`$parameters = @{
            cleargpos = `$false
            installupdates = `$false
            adobe = `$false
            firefox = `$false
            chrome = `$false
            IE11 = `$false
            edge = `$false
            dotnet = `$false
            office = `$false
            onedrive = `$false
            java = `$false
            windows = `$true                 # https://github.com/search?q=repo%3Asimeononsecurity%2FWindows-Optimize-Harden-Debloat+if+%28%24windows+-eq+%24true%29+%7B&type=code
            defender = `$false
            firewall = `$false
            mitigations = `$false
            defenderHardening = `$false
            pshardening = `$false
            sslhardening = `$false
            smbhardening = `$true            # https://github.com/search?q=repo%3Asimeononsecurity%2FWindows-Optimize-Harden-Debloat+%24smbhardening&type=code
            applockerhardening = `$false
            bitlockerhardening = `$false
            removebloatware = `$true         # https://github.com/search?q=repo%3Asimeononsecurity%2FWindows-Optimize-Harden-Debloat+%24removebloatware&type=code
            disabletelemetry = `$true        # https://github.com/search?q=repo%3Asimeononsecurity%2FWindows-Optimize-Harden-Debloat+%24disabletelemetry&type=code
            privacy = `$true                 # https://github.com/search?q=repo%3Asimeononsecurity%2FWindows-Optimize-Harden-Debloat+%24privacy&type=code
            imagecleanup = `$true            # https://github.com/search?q=repo%3Asimeononsecurity%2FWindows-Optimize-Harden-Debloat+%24imagecleanup&type=code
            nessusPID = `$false
            sysmon = `$false
            diskcompression = `$false
            emet = `$false
            updatemanagement = `$false
            deviceguard = `$false
            sosbrowsers = `$false
        }"
        "`$scriptContent = Get-Content .\Windows-Optimize-Harden-Debloat\sos-optimize-windows.ps1"
        "`$scriptContent -replace 'Import-GPOs -gposdir `"\.\\Files\\GPOs\\DoD\\Windows`"', '# Import-GPOs -gposdir `".\Files\GPOs\DoD\Windows`"'"
        "`$scriptContent | Set-Content .\Windows-Optimize-Harden-Debloat\sos-optimize-windows.ps1"
        "& '.\Windows-Optimize-Harden-Debloat\sos-optimize-windows.ps1' `$parameters['cleargpos'] `$parameters['installupdates'] `$parameters['adobe'] `$parameters['firefox'] `$parameters['chrome'] `$parameters['IE11'] `$parameters['edge'] `$parameters['dotnet'] `$parameters['office'] `$parameters['onedrive'] `$parameters['java'] `$parameters['windows'] `$parameters['defender'] `$parameters['firewall'] `$parameters['mitigations'] `$parameters['defenderHardening'] `$parameters['pshardening'] `$parameters['sslhardening'] `$parameters['smbhardening'] `$parameters['applockerhardening'] `$parameters['bitlockerhardening'] `$parameters['removebloatware'] `$parameters['disabletelemetry'] `$parameters['privacy'] `$parameters['imagecleanup'] `$parameters['nessusPID'] `$parameters['sysmon'] `$parameters['diskcompression'] `$parameters['emet'] `$parameters['updatemanagement'] `$parameters['deviceguard'] `$parameters['sosbrowsers']"
        "Set-Location '$PSScriptRoot'"
        "Remove-Item '.\Windows-Optimize-Harden-Debloat' -Recurse -Force"
        "Set-Location '$PSScriptRoot'"
        # reenable Explorer preview pane
        "Set-ItemProperty 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Name 'NoReadingPane' -Type 'DWORD' -Value 0 -Force"
        "New-Item 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Force | Out-Null"
        "Set-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Name 'NoReadingPane' -Type 'DWORD' -Value 0 -Force"
        # reenable Clipboard history
        "Set-ItemProperty 'HKCU:\Software\Microsoft\Clipboard' -Name 'EnableClipboardHistory' -Type 'DWORD' -Value 1 -Force"
        # reenable Run history
        "Set-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'Start_TrackProgs' -Type 'DWORD' -Value 1 -Force"
        # disable lock screen requiring Ctrl+Alt+Del
        "Set-ItemProperty 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System' -Name 'DisableCAD' -Type 'DWORD' -Value 1 -Force"
        # reenable lock screen username preview
        "Set-ItemProperty 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System' -Name 'DontDisplayLastUsername' -Type 'DWORD' -Value 0 -Force"
    )
    "SoulseekQt" = @(
        "scoop install extras/soulseekqt"
    )
    "SoundVolumeView" = @(
        "choco install soundvolumeview -y"
        "scoop install nirsoft/soundvolumeview"
        "winget install --id=NirSoft.SoundVolumeView --exact --accept-source-agreements --accept-package-agreements"
    )
    "Spicetify" = @(
        "choco install spicetify-cli -y"
        "scoop install main/spicetify-cli"
        "winget install --id=Spicetify.Spicetify --exact --accept-source-agreements --accept-package-agreements"
        # Invoke-WebRequest -UseBasicParsing https://raw.githubusercontent.com/spicetify/cli/main/install.ps1 | Invoke-Expression
        "& '$PSScriptRoot\Scripts\Initialize-Spicetify.ps1' -Full"
        "Start-Process 'spotify:marketplace'"
        "Start-Process 'https://raw.githubusercontent.com/Bergbok/Configs/refs/heads/main/Cross-Platform/Spicetify/marketplace.json'"
        "Start-Process 'https://gist.githubusercontent.com/Bergbok/c7503bcb7ba2699ae10830b5aacbf333/raw/excluding-%255Bcontains-local-files%255D'"
        "Start-Process 'https://gist.githubusercontent.com/Bergbok/c7503bcb7ba2699ae10830b5aacbf333/raw/including-%255Bcontains-local-files%255D'"
    )
    "Spotify" = @(
        # Latest:
        # "choco install spotify -y; choco pin add -n=spotify"
        # # "scoop install extras/spotify; scoop hold spotify" # https://github.com/ScoopInstaller/Extras/issues/12429, also taskbar entry
        # "winget install --id=Spotify.Spotify --exact --accept-source-agreements --accept-package-agreements; winget pin add --id=Spotify.Spotify"
        # v1.2.45.454:
        # "choco install spotify -y --version=1.2.45.454 --ignore-checksums; choco pin add -n=spotify"
        # # "scoop install bergbok/spotify; scoop hold spotify" # https://github.com/ScoopInstaller/Extras/issues/12429, also taskbar entry
        "winget install --id=Spotify.Spotify -v '1.2.45.454.gc16ec9f6' --exact --accept-source-agreements --accept-package-agreements; winget pin add --id=Spotify.Spotify"
        "if (`$script:selected -contains 'Spicetify') {
            Write-Host 'Please log into Spotify, press enter to continue when done.'
            Start-Sleep -Seconds 2
            `$spotify = es -r '\.exe$' 'Spotify.exe' | Where-Object { `$_ -notmatch 'Minimize-' } | Select-Object -First 1
            Start-Process `$spotify
            Read-Host
        }"
        "script:Log 'Spotify: Set local files location.'"
    )
    "ssh" = @(
        "choco install openssh -y"
        "scoop install main/openssh"
        "if (scoop list | Select-String 'openssh' -SimpleMatch) {
            & '$env:USERPROFILE\scoop\apps\openssh\current\install-sshd.ps1'
        }"
        "if (-not (scoop list | Select-String 'openssh' -SimpleMatch)  -and (-not (choco list openssh) -contains '0 packages installed.')) { 
            Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0
            Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
        }"
        "Start-Service sshd"
        "Set-Service -Name 'sshd' -StartupType 'Automatic'"
        "Start-Service ssh-agent"
        "Set-Service -Name 'ssh-agent' -StartupType 'Automatic'"
        "if (Get-Command ssh-keygen -ErrorAction SilentlyContinue) {
            Start-Process powershell -Args 'ssh-keygen'
        } else {
            script:Log 'ssh: Could not generate ssh key, ssh-keygen not found.' 
        }"
        "New-Item -Path '$env:USERPROFILE\.ssh' -ItemType Directory -Force | Out-Null"
        "New-Item -Path '$env:SYSTEMDRIVE\ProgramData\ssh' -ItemType Directory -Force | Out-Null"
        "Add-Content '$env:USERPROFILE\.ssh\authorized_keys', '$env:SYSTEMDRIVE\ProgramData\ssh\administrators_authorized_keys' -Value (`$script:authorizedSshPubkeys -split ',')"
    )
    "Steam" = @(
        "choco install steam -y"
        "scoop install bergbok/steam"
        "winget install --id=Valve.Steam --exact --accept-source-agreements --accept-package-agreements"
        "script:Log 'Steam: Get mobile app QR code scanner ready.'"
        "Start-Sleep -Seconds 1"
        "`$steam = es -i -n 1 -r '\.exe$' 'steam.exe'"
        "Start-Process `$steam"
        "if (`$script:selected -contains 'DisplayFusion' -or `$script:selected -contains 'Wallpaper Engine') {
            Write-Host 'Please log into Steam, press enter to continue when done.'
            Read-Host
        }"
        "Stop-Process -Name 'steam' -ErrorAction SilentlyContinue"
        "`$steamInstallDriveLetter = `$steam.Substring(0, 1)"
        "`$newLibraryPath =  `"`$(`$steamInstallDriveLetter):\SteamLibrary\steamapps`""
        "New-Item -ItemType Directory -Path `"`$newLibraryPath\common`" -Force | Out-Null"
        "New-Item -ItemType SymbolicLink `"$env:USERPROFILE\Games\Steam Libraries\`$steamInstallDriveLetter`" -Target `"`$newLibraryPath\common`" -Force | Out-Null"
        "if (scoop list | Select-String -Pattern 'steam' -SimpleMatch) {
            Remove-Item '$env:USERPROFILE\scoop\persist\steam\steamapps' -Recurse -Force
            New-Item -ItemType SymbolicLink '$env:USERPROFILE\scoop\persist\steam\steamapps' -Target `$newLibraryPath | Out-Null
        } else {
            Remove-Item '${env:ProgramFiles(x86)}\Steam\steamapps' -Recurse -Force
            New-Item -ItemType SymbolicLink '${env:ProgramFiles(x86)}\Steam\steamapps' -Target `$newLibraryPath | Out-Null
        }"
        "Set-Location '$(Split-Path $PSScriptRoot)\Cross-Platform\Steam'"
        "python -m venv venv"
        ".\venv\Scripts\Activate.ps1"
        "pip install -r requirements.txt"
        "`$steampath = Split-Path `$steam"
        "python Steam-Config.py `"`$steampath`""
        "deactivate"
        "Remove-Item '.\venv' -Recurse -Force"
        "Set-Location '$PSScriptRoot'"
        "Start-Sleep -Seconds 2"
        "Start-Process `$steam"
        "script:Log 'Steam: Add additional drives in settings -> Storage.'"
    )
    "Steam Achievement Manager" = @(
        # "choco install steamachievementmanager -y"
        # "scoop install games/steam-achievement-manager"
        "scoop install games/steam-achievement-manager-syntaxtm"
    )
    "Steam ROM Manager" = @(
        "choco install steam-rom-manager -y"
        "scoop install games/steam-rom-manager"
        "winget install --id=SteamGridDB.RomManager --exact --accept-source-agreements --accept-package-agreements"
        "if (scoop list | Select-String -Pattern 'steam-rom-manager') {
            `$configPath = '$env:USERPROFILE\scoop\persist\steam-rom-manager\userData'
        } else {
            `$configPath = '$env:APPDATA\steam-rom-manager\userData'
        }"
        "Copy-Item '$(Split-Path $PSScriptRoot)\Cross-Platform\Steam-ROM-Manager\*' -Destination `$configPath -Recurse -Force"
        "`$steam = es -i -n 1 -r '\.exe$' 'steam.exe'"
        "`$steamPath = Split-Path `$steam"
        "`$userConfigurations = Get-Content `"`$configPath\userConfigurations.json`""
        "`$replacements = @{
            'steam-account-name-here' = `$script:steamAccountName
            'steam-path-here' = (`$steamPath -replace '\\', '\\')
            'roms-path-here' = ('$env:USERPROFILE\Games\ROMs' -replace '\\', '\\')
            'ares-executable-path-here' = ((es -i -n 1 -r '\.exe$' 'ares.exe') -replace 'ares\\\d+', 'ares\current' -replace '\\', '\\')
            'cemu-executable-path-here' = ((es -i -n 1 -r '\.exe$' 'Cemu.exe') -replace 'cemu\\\d+', 'cemu\current' -replace '\\', '\\')
            'cemu-path-here' = ((es -i -n 1 -r '\.exe$' 'Cemu.exe') -replace 'cemu\\\d+', 'cemu\current' -replace '\\\\Cemu\.exe', '' -replace '\\', '\\')
            'dolphin-executable-path-here' = ((es -i -n 1 -r '\.exe$' 'Dolphin.exe') -replace 'dolphin\\\d+', 'dolphin\current' -replace '\\', '\\')
            'duckstation-executable-path-here' = ((es -i -n 1 -r '\.exe$' 'duckstation*.exe') -replace 'duckstation\\[a-z\d-]+', 'duckstation\current' -replace '\\', '\\')
            'lime3ds-executable-path-here' = ((es -i -n 1 -r '\.exe$' 'lime3ds.exe') -replace 'lime3ds\\[\d\.]+', 'lime3ds\current' -replace '\\', '\\')
            'melonds-executable-path-here' = ((es -i -n 1 -r '\.exe$' 'melonDS.exe') -replace 'melonDS\\\d+', 'melonDS\current' -replace '\\', '\\')
            'pcsx2-executable-path-here' = ((es -i -n 2 -r '\.exe$' 'pcsx2*.exe') -replace 'pcsx2\\[\d\.]+', 'pcsx2\current' -replace '\\', '\\')
            'ppsspp-executable-path-here' = ((es -i -n 1 -r '\.exe$' 'PPSSPPWindows64.exe') -replace 'ppsspp\\[\d\.]+', 'ppsspp\current' -replace '\\', '\\')
            'rpcs3-executable-path-here' = ((es -i -n 1 -r '\.exe$' 'rpcs3.exe') -replace 'rpcs3\\[\d\.-]+', 'rpcs3\current' -replace '\\', '\\')
            'ryujinx-executable-path-here' = ((es -i -n 1 -r '\.exe$' 'Ryujinx.exe') -replace '\\', '\\')
            'sameboy-executable-path-here' = ((es -i -n 1 -r '\.exe$' 'sameboy.exe') -replace 'sameboy\\[\d\.]+', 'sameboy\current' -replace '\\', '\\')
            'windows-non-steam-games-path-here' = ('$env:USERPROFILE\Games\Windows' -replace '\\', '\\')
        }"
        "foreach (`$key in `$replacements.Keys) {
            `$userConfigurations = `$userConfigurations -replace `$key, `$replacements[`$key]
        }"
        "`$userConfigurations | Set-Content `"`$configPath\userConfigurations.json`""
        "`$userSettings = Get-Content `"`$configPath\userSettings.json`""
        "`$userSettings = `$userSettings -replace 'steam-account-name-here', `$script:steamAccountName"
        "`$userSettings = `$userSettings -replace 'steam-path-here', (`$steamPath -replace '\\', '\\')"
        "`$userSettings | Set-Content `"`$configPath\userSettings.json`""
        "Write-Host 'Downloading local Steam images...'"
        "gdown `$script:steamGridImagesGDriveID"
        "script:Expand-7zArchive '.\steam-grid-images.7z'"
        "Remove-Item '.\steam-grid-images.7z'"
        "`$steamGridImagesPath = `$steamPath + '\userdata\' + `$script:steamID3 + '\config\grid'"
        "New-Item -ItemType Directory `$steamGridImagesPath -Force | Out-Null"
        "Stop-Process -Name 'steam' -ErrorAction SilentlyContinue"
        "Copy-Item '.\steam-grid-images\*' -Destination `$steamGridImagesPath -Force"
        "Remove-Item '.\steam-grid-images' -Recurse -Force"
        "Start-Process `$steam"
        "Write-Host 'Downloading Steam ROM Manager (Steam parser) image choices...'"
        "gdown `$script:steamParserSrmImagesGDriveID"
        "script:Expand-7zArchive '.\steam-srm-image-choices.7z'"
        "Remove-Item '.\steam-srm-image-choices.7z'"
        "New-Item -ItemType Directory '$env:USERPROFILE\Pictures\Steam ROM Manager\Steam Parser Exports\$(Get-Date -Format "dd-MM-yyyy")' -Force | Out-Null"
        "Copy-Item '.\steam-srm-image-choices\*' -Destination '$env:USERPROFILE\Pictures\Steam ROM Manager\Steam Parser Exports\$(Get-Date -Format "dd-MM-yyyy")' -Force"
        "Remove-Item '.\steam-srm-image-choices' -Recurse -Force"
        "Write-Host 'Downloading Steam ROM Manager (non-Steam parser) image choices...'"
        "gdown `$script:nonSteamParserSrmImagesGDriveID"
        "script:Expand-7zArchive '.\non-steam-srm-image-choices.7z'"
        "Remove-Item '.\non-steam-srm-image-choices.7z'"
        "New-Item -ItemType Directory '$env:USERPROFILE\Pictures\Steam ROM Manager\Non-Steam Parser Exports\$(Get-Date -Format "dd-MM-yyyy")' -Force | Out-Null"
        "Copy-Item '.\non-steam-srm-image-choices\*' -Destination '$env:USERPROFILE\Pictures\Steam ROM Manager\Non-Steam Parser Exports\$(Get-Date -Format "dd-MM-yyyy")' -Force"
        "Remove-Item '.\non-steam-srm-image-choices' -Recurse -Force"
        "script:Log 'Steam ROM Manager: Double check parsers/exceptions before adding games.'"
        "script:Log 'Steam ROM Manager: You might need to manually select artwork & set up exceptions for the Windows Non-Steam parser. Or just disable it.'"
    )
    "Streamlink Twitch GUI" = @(
        "choco install streamlink-twitch-gui -y"
        "scoop install extras/streamlink-twitch-gui"
        "winget install --id=Streamlink.Streamlink.TwitchGui --exact --accept-source-agreements --accept-package-agreements"
    )
    "Stremio" = @(
        "choco install stremio -y"
        "scoop install extras/stremio; reg import '$env:USERPROFILE\scoop\apps\stremio\current\install-context.reg' 2>`$null"
        "winget install --id=Stremio.Stremio --exact --accept-source-agreements --accept-package-agreements"
        "Start-Process 'https://stremio-addons.netlify.app'"
    )
    "gsudo" = @(
        "choco install gsudo -y"
        "scoop install main/gsudo"
        "winget install --id=gerardog.gsudo --exact --accept-source-agreements --accept-package-agreements"
        "gsudo config CacheMode Auto"
    )
    "Syncthing" = @(
        "choco install syncthing -y"
        # "scoop install main/syncthing" # https://github.com/ScoopInstaller/Main/issues/5888
        "winget install --id=Syncthing.Syncthing --exact --accept-source-agreements --accept-package-agreements"
        "syncthing generate --no-default-folder"
        "Start-Process powershell -Args 'syncthing --no-browser --no-console'"
    )
    "Syncthing Tray" = @(
        "choco install syncthingtray -y"
        "scoop install extras/syncthingtray"
        "winget install --id=Martchus.syncthingtray --exact --accept-source-agreements --accept-package-agreements"
        "Start-Sleep -Seconds 2"
        "Stop-Process -Name 'syncthingtray*' -ErrorAction SilentlyContinue"
        # won't work unless it's already been configured :/
        "`$syncthingtrayiniPath = es -i -n 1 -r '\.ini$' 'syncthingtray.ini'"
        "`$syncthingtrayini = Get-Content `$syncthingtrayiniPath"
        "`$syncthingtrayini = `$syncthingtrayini -replace 'syncthingAutostart=true', 'syncthingAutostart=false'"
        "`$syncthingtrayini = `$syncthingtrayini -replace 'notifyOnDisconnect=true', 'notifyOnDisconnect=false'"
        "`$syncthingtrayini = `$syncthingtrayini -replace 'stopOnMetered=false', 'stopOnMetered=true'"
        "`$syncthingtrayini | Set-Content `"`$syncthingtrayiniPath`""
        "script:Log 'SyncthingTray: Set syncthingAutostart=false, notifyOnDisconnect=false, stopOnMetered=true.'"
    )
    "TaskbarX" = @(
        "choco install taskbarx -y"
        "scoop install extras/taskbarx"
        "Start-Sleep -Seconds 2"
        "`$taskbarxConfigurator = es -i -n 1 -r '\.exe$' 'TaskbarX Configurator.exe'"
        "runas.exe /trustlevel:0x20000 `"powershell -Command Start-Process `$taskbarxConfigurator`""
    )
    "TeraCopy" = @(
        "choco install teracopy -y"
        "scoop install nonportable/teracopy-np"
        "winget install --id=CodeSector.TeraCopy --exact --accept-source-agreements --accept-package-agreements"
    )
    "Terraria Font" = @(
        "Invoke-WebRequest 'https://www.ffonts.net/Andy-Bold.font.zip' -OutFile '.\Terraria-Font.zip'"
        "Expand-Archive '.\Terraria-Font.zip' -DestinationPath '.\Terraria-Font' -Force"
        "Remove-Item '.\Terraria-Font.zip'"
        "script:Install-FontFile (Get-ChildItem '.\Terraria-Font\ANDYB.TTF').FullName"
        "Remove-Item '.\Terraria-Font' -Recurse -Force"
    )
    "Twitch Downloader CLI" = @(
        "choco install twitchdownloader-cli -y"
        "scoop install main/twitchdownloader-cli"
    )
    "Twitch Downloader" = @(
        "choco install twitchdownloader-gui -y"
        "scoop install extras/twitchdownloader"
    )
    "Twitch Emote Downloader" = @(
        "scoop install bergbok/twitch-emote-downloader"
    )
    "UniGetUI" = @(
        "choco install wingetui; scoop install main/scoop-search"
        "scoop install extras/unigetui; scoop install main/scoop-search"
        "winget install --id MartiCliment.UniGetUI --exact --accept-source-agreements --accept-package-agreements; scoop install main/scoop-search"
    )
    "Uninstall Edge" = @(
        # https://github.com/ChrisTitusTech/winutil/issues/2672
        # "Invoke-WebRequest 'https://raw.githubusercontent.com/ChrisTitusTech/winutil/refs/heads/main/functions/private/Uninstall-WinUtilEdgeBrowser.ps1' -OutFile '.\Uninstall-WinUtilEdgeBrowser.ps1'"
        # ". '.\Uninstall-WinUtilEdgeBrowser.ps1'"
        # "Uninstall-WinUtilEdgeBrowser uninstall"
        # "Remove-Item '.\Uninstall-WinUtilEdgeBrowser.ps1'"
        "Invoke-WebRequest 'https://gist.githubusercontent.com/ave9858/c3451d9f452389ac7607c99d45edecc6/raw/8575efeef94236dfb36e8fb37d83945d3b108f21/UninstallEdge.ps1' -OutFile '.\UninstallEdge.ps1'"
        "`$script = Get-Content '.\UninstallEdge.ps1'"
        "`$script = `$script -replace '\`$ErrorActionPreference = `"Stop`"', '`$ErrorActionPreference = `"SilentlyContinue`"'"
        "`$script | Set-Content '.\UninstallEdge.ps1'"
        ".\UninstallEdge.ps1"
        "Remove-Item .\UninstallEdge.ps1"
    )
    "Uninstall OneDrive" = @(
        # modified from: https://github.com/ChrisTitusTech/winutil/blob/main/docs/dev/tweaks/z--Advanced-Tweaks---CAUTION/RemoveOnedrive.md
        # not currently using this, but keeping here in case Sophia's implementation fails
        " Write-Host 'Uninstalling OneDrive...'
        `$OneDrivePath = `$env:OneDrive
        `$regPath = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\OneDriveSetup.exe'
        if (Test-Path `$regPath -ErrorAction SilentlyContinue) {
            `$OneDriveUninstallString = Get-ItemPropertyValue `"`$regPath`" -Name 'UninstallString'
            `$OneDriveExe, `$OneDriveArgs = `$OneDriveUninstallString.Split(' ')
            Start-Process `$OneDriveExe -Args `"`$OneDriveArgs /silent`" -NoNewWindow -Wait
        } else {
            return
        }
        if (-not (Test-Path `$regPath -ErrorAction SilentlyContinue)) {
            Remove-Item -Recurse -Force -ErrorAction SilentlyContinue `"$env:LOCALAPPDATA\Microsoft\OneDrive`"
            Remove-Item -Recurse -Force -ErrorAction SilentlyContinue `"$env:LOCALAPPDATA\OneDrive`"
            Remove-Item -Recurse -Force -ErrorAction SilentlyContinue `"$env:PROGRAMDATA\Microsoft OneDrive`"
            Remove-Item -Recurse -Force -ErrorAction SilentlyContinue `"$env:SYSTEMDRIVE\OneDriveTemp`"
            Remove-Item -Recurse -Force -ErrorAction SilentlyContinue `"`$OneDrivePath`"
            reg delete 'HKEY_CURRENT_USER\Software\Microsoft\OneDrive' -f
            if ((Get-ChildItem `"`$OneDrivePath`" -Recurse | Measure-Object).Count -eq 0) {
                Remove-Item -Recurse -Force -ErrorAction SilentlyContinue `"`$OneDrivePath`"
            }
            Set-ItemProperty 'HKCR:\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}' -Name 'System.IsPinnedToNameSpaceTree' -Value 0
            Set-ItemProperty 'HKCR:\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}' -Name 'System.IsPinnedToNameSpaceTree' -Value 0
            reg load 'hku\Default' '$env:HOMEDRIVE\Users\Default\NTUSER.DAT'
            reg delete 'HKEY_USERS\Default\Software\Microsoft\Windows\CurrentVersion\Run' /v 'OneDriveSetup' /f
            reg unload 'hku\Default'
            Remove-Item -Force -ErrorAction SilentlyContinue `"$env:USERPROFILE\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\OneDrive.lnk`"
            Get-ScheduledTask -TaskPath '\' -TaskName 'OneDrive*' -ea SilentlyContinue | Unregister-ScheduledTask -Confirm:$false
            Set-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders' -Name 'AppData' -Value `"$env:USERPROFILE\AppData\Roaming`" -Type ExpandString
            Set-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders' -Name 'Cache' -Value `"$env:USERPROFILE\AppData\Local\Microsoft\Windows\INetCache`" -Type ExpandString
            Set-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders' -Name 'Cookies' -Value `"$env:USERPROFILE\AppData\Local\Microsoft\Windows\INetCookies`" -Type ExpandString
            Set-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders' -Name 'Favorites' -Value `"$env:USERPROFILE\Favorites`" -Type ExpandString
            Set-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders' -Name 'History' -Value `"$env:USERPROFILE\AppData\Local\Microsoft\Windows\History`" -Type ExpandString
            Set-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders' -Name 'Local AppData' -Value `"$env:USERPROFILE\AppData\Local`" -Type ExpandString
            Set-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders' -Name 'My Music' -Value `"$env:USERPROFILE\Music`" -Type ExpandString
            Set-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders' -Name 'My Video' -Value `"$env:USERPROFILE\Videos`" -Type ExpandString
            Set-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders' -Name 'NetHood' -Value `"$env:USERPROFILE\AppData\Roaming\Microsoft\Windows\Network Shortcuts`" -Type ExpandString
            Set-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders' -Name 'PrintHood' -Value `"$env:USERPROFILE\AppData\Roaming\Microsoft\Windows\Printer Shortcuts`" -Type ExpandString
            Set-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders' -Name 'Programs' -Value `"$env:USERPROFILE\AppData\Roaming\Microsoft\Windows\Start Menu\Programs`" -Type ExpandString
            Set-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders' -Name 'Recent' -Value `"$env:USERPROFILE\AppData\Roaming\Microsoft\Windows\Recent`" -Type ExpandString
            Set-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders' -Name 'SendTo' -Value `"$env:USERPROFILE\AppData\Roaming\Microsoft\Windows\SendTo`" -Type ExpandString
            Set-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders' -Name 'Start Menu' -Value `"$env:USERPROFILE\AppData\Roaming\Microsoft\Windows\Start Menu`" -Type ExpandString
            Set-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders' -Name 'Startup' -Value `"$env:USERPROFILE\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup`" -Type ExpandString
            Set-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders' -Name 'Templates' -Value `"$env:USERPROFILE\AppData\Roaming\Microsoft\Windows\Templates`" -Type ExpandString
            Set-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders' -Name '{374DE290-123F-4565-9164-39C4925E467B}' -Value `"$env:USERPROFILE\Downloads`" -Type ExpandString
            Set-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders' -Name 'Desktop' -Value `"$env:USERPROFILE\Desktop`" -Type ExpandString
            Set-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders' -Name 'My Pictures' -Value `"$env:USERPROFILE\Pictures`" -Type ExpandString
            Set-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders' -Name 'Personal' -Value `"$env:USERPROFILE\Documents`" -Type ExpandString
            Set-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders' -Name '{F42EE2D3-909F-4907-8871-4C22FC0BF756}' -Value `"$env:USERPROFILE\Documents`" -Type ExpandString
            Set-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders' -Name '{0DDD015D-B06C-45D5-8C4C-F59713854639}' -Value `"$env:USERPROFILE\Pictures`" -Type ExpandString
            Stop-Process -Name 'explorer'
            if (-not (Get-Process 'explorer' -ErrorAction SilentlyContinue)) {
                Start-Process 'explorer'
            }
            Start-Process 'explorer.exe'
            Start-Process 'explorer.exe'
        } else {
            Write-Host 'Something went wrong during the unistallation of OneDrive' -ForegroundColor Red
        }"
    )
    "USBHelper" = @(
        "`$tempPath = [System.IO.Path]::GetTempPath() + 'USBHelperInstaller.exe'"
        "Invoke-WebRequest 'https://github.com/FailedShack/USBHelperInstaller/releases/latest/download/USBHelperInstaller.exe' -OutFile `$tempPath"
        "Start-Process `$tempPath"
        "Set-Clipboard 'titlekeys.ovh'"
        "script:Log 'USBHelper: Set title key site to titlekeys.ovh'"
    )
    "veadotube mini" = @( 
        "Start-Process 'https://olmewe.itch.io/veadotube-mini/purchase'"
        "Copy-Item '$(Split-Path $PSScriptRoot)\Cross-Platform\veadotube-mini\*' -Destination '$env:USERPROFILE\Pictures\pngtubers' -Recurse -Force"
        "script:Log 'veadotube mini: pngtubers have been copied to `"$env:USERPROFILE\Pictures\pngtubers`"'"
    )
    "Ventoy" = @(
        "choco install ventoy -y"
        "scoop install extras/ventoy"
        "winget install --id=Ventoy.Ventoy --exact --accept-source-agreements --accept-package-agreements"
    )
    "VirtualBox" = @(
        # "choco install virtualbox -y" # floods terminal
        # "scoop install nonportable/virtualbox-np" # install script doesn't use erroraction silentlycontinue
        "winget install --id=Oracle.VirtualBox --exact --accept-source-agreements --accept-package-agreements"
        "Enable-WindowsOptionalFeature -Online -FeatureName HypervisorPlatform -NoRestart"
    )
    "Visual C++ Redistributable" = @(
        # "choco install vcredist140"
        "scoop install extras/vcredist"
        # "winget install --id=Microsoft.VCRedist.2015+.x64 --exact --accept-source-agreements --accept-package-agreements"
    )
    "Visual Studio Code" = @(
        "choco install vscode -y"
        # "scoop install extras/vscode; script:Log 'VSCode: Optionally: reg import `"$env:USERPROFILE\scoop\apps\vscode\current\install-context.reg`"; reg import `"$env:USERPROFILE\scoop\apps\vscode\current\install-associations.reg`"'" # taskbar entry
        "winget install --id=Microsoft.VisualStudioCode --exact --accept-source-agreements --accept-package-agreements"
        "if (Get-Command code -ErrorAction SilentlyContinue) {
            gsudo --integrity Medium -- code
        } else {
            `$code = es -i -n 1 -r '\.exe$' 'Code.exe'
            gsudo --integrity Medium -- Start-Process `$code 
        }"
        "script:Log 'VSCode: Change git.defaultCloneDirectory to $($env:USERPROFILE -replace '\\', '\\')\\Code'"
    )
    "Vita3K" = @(
        "scoop install games/vita3k --skip-hash-check" # https://github.com/Calinou/scoop-games/issues?q=vita3k%40
        "winget install --id=Vita3K.Vita3K --exact --accept-source-agreements --accept-package-agreements"
    )
    "VLC" = @(
        "choco install vlc -y"
        # "scoop install extras/vlc" # doesn't show an option in ms-settings:defaultapps
        "winget install --id=VideoLAN.VLC --exact --accept-source-agreements --accept-package-agreements"
    )
    "Voicemod" = @(
        # "choco install voicemod -y"
        "scoop install bergbok/voicemod"
        "script:Log 'Voicemod: Disable auto startup in Task Manager'"
    )
    "Wallpaper" = @(
        "Write-Host 'Setting wallpaper...'"
        "Invoke-WebRequest `$script:wallpaperUrl -OutFile `"$env:USERPROFILE\Pictures\Wallpapers\`$script:wallpaperFilename`""
        "New-Item -ItemType SymbolicLink '$env:USERPROFILE\Pictures\Wallpapers\Current' -Target `"$env:USERPROFILE\Pictures\Wallpapers\`$script:wallpaperFilename`" -Force"
        "Set-ItemProperty 'HKCU:\Control Panel\Desktop' -Name 'WallpaperStyle' -Value 10 -Type String"
        # from: https://gist.github.com/s7ephen/714023?permalink_comment_id=3611772#gistcomment-3611772
        "Add-Type -TypeDefinition 'using System.Runtime.InteropServices; public class Wallpaper { public const int SetDesktopWallpaper = 20; public const int UpdateIniFile = 0x01; public const int SendWinIniChange = 0x02; [DllImport(`"user32.dll`", SetLastError = true, CharSet = CharSet.Auto)] private static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni); public static void SetWallpaper(string path) { SystemParametersInfo(SetDesktopWallpaper, 0, path, UpdateIniFile | SendWinIniChange); } }'"
        "[Wallpaper]::SetWallpaper('$env:USERPROFILE\Pictures\Wallpapers\Current')"
        # couldn't manage to change the lock screen programmatically, tried changing registry keys and even overwriting the files in $env:WINDIR\Web\Screen
    )
    "Wallpaper Engine" = @(
        "Start-Process steam://install/431960"
        "script:Log 'Wallpaper Engine: Open before script ends to set it up.'"
    )
    "webp2gif" = @(
        "scoop install bergbok/webp2gif"
    )
    "whois" = @(
        "choco install whois -y"
        "scoop install sysinternals/whois"
    )
    "WinAero Tweaker" = @(
        "choco install winaero-tweaker.portable -y"
        "scoop install extras/winaero-tweaker"
        "winget install --id=winaero.tweaker --exact --accept-source-agreements --accept-package-agreements"
        "`$winaerotweaker = es -i -n 1 -r '\.exe$' 'WinaeroTweaker.exe'"
        "`$winaerotweakerini = Get-Content '$PSScriptRoot\Configs\Winaero-Tweaker\Winaero Tweaker.ini'"
        "`$winaerotweakerini = `$winaerotweakerini -replace 'lockscreenimage-here', '$env:USERPROFILE\Pictures\Wallpapers\Current'"
        "`$winaerotweakerini | Set-Content `"`$(Split-Path `$winaerotweaker)\Winaero Tweaker.ini`" -Force"
        "Invoke-WebRequest `$script:wallpaperUrl -OutFile `"$env:USERPROFILE\Pictures\Wallpapers\`$script:wallpaperFilename`""
        "New-Item -ItemType SymbolicLink '$env:USERPROFILE\Pictures\Wallpapers\Current' -Target `"$env:USERPROFILE\Pictures\Wallpapers\`$script:wallpaperFilename`" -Force"
        "script:Log `"Winaero Tweaker: You need to manually import tweaks from: '`$(Split-Path `$winaerotweaker)\Winaero Tweaker.ini'`""
        "Set-Clipboard `"`$(Split-Path `$winaerotweaker)\Winaero Tweaker.ini`""
        "Start-Process `$winaerotweaker"
    )
    "Windows Terminal" = @(
        "choco install microsoft-windows-terminal -y"
        # "scoop install extras/windows-terminal; script:Log 'Windows Terminal: Optionally run reg import $env:USERPROFILE\scoop\apps\windows-terminal\install-context.reg'" # taskbar entry
        "winget install --id=Microsoft.WindowsTerminal --exact --accept-source-agreements --accept-package-agreements"
        "if (Get-Command wt -ErrorAction SilentlyContinue) {
            wt
        } else {
            Start-Process (es -i -n 1 -r '\.exe$' 'wt.exe')
        }"
        "Start-Sleep -Seconds 0.25"
        "Stop-Process -Name 'WindowsTerminal' -ErrorAction SilentlyContinue"
        "`$config = Get-Content '$PSScriptRoot\Configs\Windows-Terminal\settings.json'"
        "`$config = `$config -replace 'windir-here', ('$env:WINDIR' -replace '\\', '\\')"
        "`$config = `$config -replace 'userprofile-here', ('$env:USERPROFILE' -replace '\\', '\\')"
        "`$config = `$config -replace 'nerdfont-here', 'MesloLGM Nerd Font'"
        "`$config = `$config -replace 'pi-hostname-here', `$script:piHostname"
        "`$config = `$config -replace 'laptop-hostname-here', `$script:laptopHostname"
        "`$pwshVersion = Get-Command pwsh -ErrorAction SilentlyContinue | Select-Object -Property Version"
        "if (`$pwshVersion.Version.Major -ge 7) {
            `$config = `$config -replace 'pwsh-path-here', (((Get-Command pwsh).Source) -replace '\\', '\\')
            `$config = `$config -replace 'true, // unhide if pwsh7', 'false,'
            `$config = `$config -replace 'false, // hide if pwsh7', 'true,' 
        }"
        "if (scoop list | Select-String -Pattern 'windows-terminal' -SimpleMatch) {
            `$destinationPath = '$env:USERPROFILE\scoop\persist\windows-terminal\settings'
        } else {
            `$destinationPath = `"`$((Get-ChildItem '$env:LOCALAPPDATA\Packages' -Filter 'Microsoft.WindowsTerminal*').FullName)\LocalState`"
        }"
        "New-Item -ItemType Directory `$destinationPath -Force | Out-Null"
        "Set-Content `"`$destinationPath\settings.json`" -Value `$config -Force | Out-Null"
    )
    "WinRAR" = @(
        "choco install winrar -y"
        "scoop install extras/winrar; script:Log 'WinRAR: Set up context menu within settings window'"
        "winget install --id=RARLab.WinRAR --exact --accept-source-agreements --accept-package-agreements"
        "Invoke-WebRequest 'https://github.com/bitcookies/winrar-keygen/releases/latest/download/winrar-keygen-x64.exe' -OutFile '.\winrar-keygen.exe'"
        ".\winrar-keygen.exe 'Bergbok' 'Anti-Nagware License' | Out-File -Encoding ascii rarreg.key"
        "if (scoop list | Select-String -Pattern 'winrar' -SimpleMatch) {
            Copy-Item '.\rarreg.key' -Destination '$env:USERPROFILE\scoop\persist\winrar' -Force
        }
        if (Test-Path '$env:APPDATA\WinRAR') {
            Copy-Item '.\rarreg.key' -Destination '$env:APPDATA\WinRAR' -Force
        }"
        "Remove-Item '.\winrar-keygen.exe'"
        "Remove-Item '.\rarreg.key'"
        "Invoke-WebRequest 'https://www.rarlab.com/themes/Bitcrushed_24x24.theme.rar' -OutFile '.\Bitcrushed.theme.rar'"
        "`$WinRAR = es -i -n 1 -r '\.exe$' 'WinRAR.exe'"
        "New-Item -ItemType Directory '.\WinRAR-Bitcrushed' -Force | Out-Null"
        "Start-Process `$WinRAR -Args 'x `".\Bitcrushed.theme.rar`" `".\WinRAR-Bitcrushed`"'"
        "Start-Sleep -Seconds 1"
        "Remove-Item .\Bitcrushed.theme.rar"
        "Copy-Item '.\WinRAR-Bitcrushed' -Destination '$env:USERPROFILE\Themes\WinRAR' -Recurse -Force"
        "Remove-Item '.\WinRAR-Bitcrushed' -Recurse -Force"
        "`$settingsRegContent = Get-Content '$PSScriptRoot\Configs\WinRAR\Settings.reg'"  
        "`$updatedSettingsRegContent = `$settingsRegContent -replace 'home-here', ('$env:USERPROFILE' -replace '\\', '\\')"
        "`$updatedSettingsRegContent = `$updatedSettingsRegContent -replace 'theme-path-here', ('$env:USERPROFILE\Themes\WinRAR' -replace '\\', '\\')"
        "`$updatedSettingsRegContent = `$updatedSettingsRegContent -replace 'winrar-path-here', ((es -i -n 1 -r '\.exe$' 'WinRAR.exe') -replace '\\', '\\')"
        "`$updatedSettingsRegContent | Set-Content '.\temp-WinRAR-Settings.reg'"
        "reg import '.\temp-WinRAR-Settings.reg' 2>`$null"
        "Remove-Item '.\temp-WinRAR-Settings.reg'"
    )
    "WinSCP" = @(
        "choco install winscp -y"
        "scoop install extras/winscp"
        "winget install --id=WinSCP.WinSCP --exact --accept-source-agreements --accept-package-agreements"
    )
    "WinSetView" = @(
        "scoop install bergbok/winsetview"
        "reg import '$PSScriptRoot\Configs\WinSetView\WinViewBak.reg' 2>`$null"
    )
    "WizTree" = @(
        "choco install wiztree -y"
        "scoop install extras/wiztree"
        "winget install --id=AntibodySoftware.WizTree --exact --accept-source-agreements --accept-package-agreements"
        "if (scoop list | Select-String -Pattern 'wiztree' -SimpleMatch) {
            `$destinationPath = '$env:USERPROFILE\scoop\persist\wiztree'
        } else {
            `$destinationPath = '$env:APPDATA\WizTree3'
        }"
        "New-Item -ItemType Directory `$destinationPath -Force | Out-Null"
        "Copy-Item '$PSScriptRoot\Configs\WizTree\WizTree3.ini' -Destination `$destinationPath -Force"
        "script:Log 'WizTree: Set context menu extended mode with ShellMenuView.'"
    )
    "WSL" = @(
        "choco install wsl2 -y"
        "winget install --id=Microsoft.WSL --exact --accept-source-agreements --accept-package-agreements"
        "wsl --install --no-distribution --no-launch --web-download"
        "wsl --update"
        "wsl --unregister Ubuntu"
    )
    "WSL - Arch" = @(
        "choco install wsl-archlinux -y"
        # "scoop install extras/archwsl"
    )
    "WSL - Debian" = @(
        "wsl --install --no-launch --distribution Debian"
    )
    "Yarn" = @(
        "choco install yarn -y"
        "scoop install main/yarn"
        "winget install --id=Yarn.Yarn --exact --accept-source-agreements --accept-package-agreements"
    )
    "yt-dlp" = @(
        "choco install yt-dlp -y"
        "scoop install versions/yt-dlp-master"
        "winget install --id=yt-dlp.yt-dlp --exact --accept-source-agreements --accept-package-agreements"
    )
    "Xtreme Download Manager" = @(
        "choco install xdm -y"
        "scoop install extras/xdman"
        "winget install --id=subhra74.XtremeDownloadManager --exact --accept-source-agreements --accept-package-agreements"
    )
}

$script:ordering = @{
    "Microsoft Activation Scripts" = 1
    "Uninstall Edge" = 2
    "Everything" = 3
    "Everything CLI" = 4
    "Wallpaper" = 5
    "Visual C++ Redistributable" = 6
    "Syncthing" = 6
    "KeePassXC" = 8
    "Firefox" = 9
    "f.lux" = 10
    "Python" = 11
    "Steam" = 12
    "Sophia Script" = 13
    "SoS Optimize Harden Debloat" = 14
    "gsudo" = 15
    "Spotify" = 101
    "Discord" = 102
    "Visual Studio Code" = 103
    "Gpg4win" = 104
    "git" = 105
    "gdown" = 106
    "SecureUxTheme" = 107
    "ps2exe" = 108
    "WSL" = 109
    "LibreOffice" = 110
    "Microsoft Office" = 111
    ".NET 8.0 Desktop Runtime" = 112
    "VLC" = 113
    "PowerShell Update" = 114
    "oh-my-posh" = 115
    "Node.js" = 116
    "yarn" = 117
    "bun" = 118
    "Ares" = 201
    "CEMU" = 202
    "Dolhpin" = 203
    "Duckstation" = 204
    "Lime3DS" = 205
    "melonDS" = 206
    "PCSX2" = 207
    "PPSSPP" = 208
    "RPCS3" = 209
    "Ruffle" = 210
    "Ryujinx" = 211
    "SameBoy" = 212
    "Vita3K" = 213
    "calibre" = 301
    "DS4Windows" = 302
    "Flashpoint Infinity" = 303
    "Elden Ring Save Manager" = 304
    "GifCam" = 305
    "CPUID HWMonitor" = 306
    "LibreHardwareMonitor" = 307
    "PowerToys" = 308
    "TaskbarX" = 309
    "qBitTorrent" = 310
    "qBitTorrent Enhanced" = 311
}

$script:preselected = @(
    ".NET 8.0 Desktop Runtime"
    "After Dark CC Theme"
    "Ares"
    "Audacity"
    "AudioDeviceCmdlets"
    "AutoHotkey"
    "Autologon"
    "AutoRuns"
    "BCUninstaller"
    "BetterDiscord"
    "BFG Repo-Cleaner"
    "Bun"
    "Calibre"
    "CEMU"
    "Chatterino2"
    "Cheat Engine"
    "Cmder"
    "Command Prompt Aliases"
    "CreamInstaller"
    "Cyberpunk Waifus Font"
    "Deno"
    "Discord"
    "Discord OpenAsar"
    "DisplayFusion"
    "Docker CLI"
    "Docker Completion"
    "Docker Compose"
    "Docker Engine"
    "Dolphin"
    "DS4Windows"
    "DuckStation"
    "Elden Ring Save Manager"
    "Everything PowerToys"
    "ExplorerPatcher"
    "f.lux"
    "ffmpeg"
    "FileTypesMan"
    "Firefox"
    "Flameshot"
    "Flash-enabled Chromium"
    "FlicFlac"
    "FreeTube"
    "GifCam"
    "Gifsicle"
    "GitHub CLI"
    "GitHub Desktop"
    "Godot (Mono)"
    "Gpg4win"
    "gsudo"
    "HandBrake"
    "HeidiSQL"
    "HypnOS Cursor"
    "IconsExtract"
    "ImageGlass"
    "KeePassXC"
    "KDE Connect"
    "khinsider.py"
    "Legendary"
    "LibreHardwareMonitor"
    "LibreOffice"
    "Lime3DS"
    "Lumafly"
    "Majora's Mask"
    "melonDS"
    "MegaBasterd"
    "Meslo Nerd Font"
    "Microsoft Activation Scripts"
    "Minecraft Font"
    "Minecraft Launcher"
    "Mp3tag"
    "MultiMonitorTool"
    "NAPS2"
    "Neofetch"
    "Network Sharing"
    "Nicotine+"
    "Node.js"
    "NoPayStation"
    "Notepad++"
    "NVIDIA Drivers"
    "OBS Studio"
    "Obsidian"
    "oh-my-posh"
    "OpenRGB"
    "Open-Shell"
    "OpenWithView"
    "PCSX2"
    "PeaZip"
    "Photoshop"
    "PowerShell Update"
    "PowerShell Profile"
    "PowerToys"
    "PPSSPP"
    "Premiere Pro"
    "Process Explorer"
    "Process Monitor"
    "PsShutdown"
    "qBittorrent Enhanced"
    "QTTabBar"
    "r2modman"
    "RPCS3"
    "Ruffle"
    "Rufus"
    "RustDesk"
    "Rusty PSN GUI"
    "Ryujinx"
    "SameBoy"
    "scdl"
    "SecureUxTheme"
    "SGDBoop"
    "ShellExView"
    "ShellMenuNew"
    "ShellMenuView"
    "Ship of Harkinian"
    "Sophia Script"
    "SoundVolumeView"
    "Spicetify"
    "Spotify"
    "ssh"
    "Steam"
    "Steam Achievement Manager"
    "Steam ROM Manager"
    "Streamlink Twitch GUI"
    "Syncthing Tray"
    "Syncthing"
    "TaskbarX"
    "Terraria Font"
    "Twitch Downloader CLI"
    "Twitch Downloader"
    "Twitch Emote Downloader"
    "UniGetUI"
    "Uninstall Edge"
    "USBHelper"
    "veadotube mini"
    "Ventoy"
    "VirtualBox"
    "Visual C++ Redistributable"
    "Visual Studio Code"
    "VLC"
    "Voicemod"
    "Wallpaper"
    "Wallpaper Engine"
    "webp2gif"
    "whois"
    "WinAero Tweaker"
    "Windows Terminal"
    "WinSetView"
    "WizTree"
    "WSL"
    "WSL - Arch"
    "WSL - Debian"
    "Xtreme Download Manager"
    "yarn"
    "yt-dlp"
)

$script:required = @(
    "7z"
    "Everything"
    "Everything CLI"
    "gdown"
    "Python"
    "git"
    "NirCmd"
    "ps2exe"
)

$script:selection = @{
    # The categorization could use some work but doesn't really matter.
    "Misc." = @(
        ".NET 8.0 Desktop Runtime"
        "Audacity"
        "AutoHotkey"
        "BCUninstaller"
        "Everything"
        "Everything PowerToys"
        "f.lux"
        "Firefox"
        "Flameshot"
        "GIMP"
        "Jitterbugpair"
        "KeePassXC"
        "KDE Connect"
        "LibreOffice"
        "Media Feature Pack"
        "Mp3tag"
        "NAPS2"
        "Network Sharing"
        "Notepad++"
        "NVIDIA Drivers"
        "Obsidian"
        "Photoshop"
        "PowerToys"
        "Premiere Pro"
        "RustDesk"
        "Spotify"
        "Syncthing"
        "TeraCopy"
        "UniGetUI"
        "WizTree"
    )
    "Compression" = @(
        "7z"
        "PeaZip"
        "WinRAR"
    )
    "Convertors | Decompilers" = @(
        "FFDec"
        "ffmpeg"
        "FlicFlac"
        "Gifsicle"
        "HandBrake"
        "webp2gif"
    )
    "Dev" = @(
        "AudioDeviceCmdlets"
        "BFG Repo-Cleaner"
        "Bun"
        "Cmder"
        "Command Prompt Aliases"
        "CUDA"
        "Deno"
        "Docker CLI"
        "Docker Completion"
        "Docker Compose"
        "Docker Desktop"
        "Docker Engine"
        "Everything CLI"
        "git"
        "git filter-repo"
        "GitHub CLI"
        "GitHub Desktop"
        "Go"
        "Godot"
        "Godot (Mono)"
        "Gpg4win"
        "gsudo"
        "HeidiSQL"
        "Neofetch"
        "Node.js"
        "Orca"
        "oh-my-posh"
        "onefetch"
        "PowerShell Update"
        "PowerShell Profile"
        "ps2exe"
        "Python"
        "Ruby"
        "Rufus"
        "Rust"
        "ssh"
        "Ventoy"
        "VirtualBox"
        "Visual C++ Redistributable"
        "Visual Studio Code"
        "Windows Terminal"
        "WSL"
        "WSL - Arch"
        "WSL - Debian"
        "Yarn"
    )
    "Downloaders" = @(
        "Cyberduck"
        "gdown"
        "JDownloader"
        "khinsider.py"
        "MegaBasterd"
        "Nicotine+"
        "NoPayStation"
        "qBittorrent"
        "qBittorrent Enhanced"
        "Rusty PSN CLI"
        "Rusty PSN GUI"
        "scdl"
        "Twitch Downloader CLI"
        "Twitch Downloader"
        "Twitch Emote Downloader"
        "USBHelper"
        "WinSCP"
        "Xtreme Download Manager"
        "yt-dlp"
    )
    "Fonts" = @(
        "Cyberpunk Waifus Font"
        "Meslo Nerd Font"
        "Minecraft Font"
        "Terraria Font"
    )
    "Game" = @(
        "Epic Games Launcher"
        "Flash-enabled Chromium"
        "Flashpoint Infinity"
        "itch"
        "Legendary"
        "Minecraft Launcher"
        "osu!"
        "Sekiro"
        "Steam"
    )
    "Game Emulators" = @(
        "Ares"
        "CEMU"
        "Dolphin"
        "DuckStation"
        "Lime3DS"
        "melonDS"
        "PCSX2"
        "PPSSPP"
        "RPCS3"
        "Ruffle"
        "Ryujinx"
        "SameBoy"
        "Vita3K"
    )
    "Game Recompilations" = @(
        "Ship of Harkinian"
        "Majora's Mask"
    )
    "Game Tools" = @(
        "Cheat Engine"
        "CreamInstaller"
        "Elden Ring Save Manager"
        "Lumafly"
        "r2modman"
        "Steam Achievement Manager"
        "Steam ROM Manager"
    )
    "Hardware" = @(
        "AltServer"
        "CPUID HWMonitor"
        "DS4Windows"
        "DisplayFusion"
        "Fan Control"
        "G.Skill Trident Z Lighting Control"
        "iCloud"
        "iCUE"
        "iTunes"
        "Logitech G HUB"
        "LibreHardwareMonitor"
        "NZXT CAM"
        "OpenRGB"
    )
    "NirSoft" = @(
        "FileTypesMan"
        "IconsExtract"
        "MultiMonitorTool"
        "NirCmd"
        "ShellMenuView"
        "ShellExView"
        "ShellMenuNew"
        "OpenWithView"
        "SoundVolumeView"
    )
    "Rice" = @(
        "After Dark CC Theme"
        "BetterDiscord"
        "ExplorerPatcher"
        "Discord OpenAsar"
        "HypnOS Cursor"
        "Open-Shell"
        "QTTabBar"
        "Rainmeter"
        "SecureUxTheme"
        "SGDBoop"
        "Spicetify"
        "Syncthing Tray"
        "TaskbarX"
        "Wallpaper"
        "Wallpaper Engine"
        "WinAero Tweaker"
        "WinSetView"
    )
    "Social" = @(
        "Chatterino2"
        "Discord"
    )
    "Sysinternals" = @(
        "Autologon"
        "AutoRuns"
        "PsShutdown"
        "Process Explorer"
        "Process Monitor"
        "whois"
    )
    "Tweaks" = @(
        "Microsoft Activation Scripts"
        "Sophia Script"
        "SoS Optimize Harden Debloat"
        "Uninstall Edge"
    )
    "Viewers" = @(
        "Calibre"
        "FreeTube"
        "FreeTube (Custom)"
        "ImageGlass"
        "mpv"
        "Streamlink Twitch GUI"
        "Stremio"
        "VLC"
    )
    "Recording" = @(
        "GifCam"
        "OBS Studio"
        "veadotube mini"
        "Voicemod"
    )
}

if (-not $script:keyString) {
    Write-Host "No key provided, some commands might fail." -ForegroundColor Red
    Start-Sleep -Seconds 5
}

# TLS 1.2
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072

# TLS 1.3
# [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 12288
#endregion

#region Script Scope Functions
function script:Add-EnvPath {
    # from: https://stackoverflow.com/a/69239861
    param(
        [Parameter(Mandatory, Position=0)]
        [string] $LiteralPath,
        [ValidateSet('User', 'CurrentUser', 'Machine', 'LocalMachine')]
        [string] $Scope 
    )

    Set-StrictMode -Version 1;

    $isMachineLevel = $Scope -in 'Machine', 'LocalMachine'

    $regPath = 'registry::' + ('HKEY_CURRENT_USER\Environment', 'HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment')[$isMachineLevel]

    $currDirs = (Get-Item -LiteralPath $regPath).GetValue('Path', '', 'DoNotExpandEnvironmentNames') -split ';' -ne ''

    $newValue = ($currDirs + $LiteralPath) -join ';'

    Set-ItemProperty -Type ExpandString -LiteralPath $regPath Path $newValue

    $dummyName = [guid]::NewGuid().ToString()
    [Environment]::SetEnvironmentVariable($dummyName, 'foo', 'User')
    [Environment]::SetEnvironmentVariable($dummyName, [NullString]::value, 'User')

    $env:Path = ($env:Path -replace ';$') + ';' + $LiteralPath
}

function script:Expand-7zArchive {
    param (
        [string]$archivePath
    )

    if (Get-Command 7z -ErrorAction SilentlyContinue) {
        $7z = "7z"
    } else {
        $7z = es -i -n 1 -r "\.exe$" "7z.exe"
    }
    
    $archiveName = [System.IO.Path]::GetFileNameWithoutExtension($archivePath)
    $destinationPath = Join-Path (Split-Path $archivePath) -ChildPath $archiveName

    & $7z x "$archivePath" -o"$destinationPath" -p"$script:keyString" -y
}

function script:Install-Cursor {
    param (
        [string]$infFile
    )

    gsudo -- rundll32.exe setupapi.dll,InstallHinfSection DefaultInstall 128 $infFile
}

function script:Install-FontFile {
    param (
        [string]$fontPath
    )

    if (-not $fontPath) {
        script:Log "Install-FontFile: '$fontPath' does not exist."
        return
    }

    $fontShellApp = (New-Object -ComObject shell.application).NameSpace(0x14)
    $fontShellApp.CopyHere($fontPath)
}

function script:Get-ShortcutPath {
    param(
        [string]$targetExe,
        [string]$scoopName = ""
    )

    if ((Get-Command $targetExe -ErrorAction SilentlyContinue) -and ((Get-Command $targetExe).Source -notmatch "\\shims\\")) {
        $exePath = (Get-Command $targetExe).Source | Select-Object -First 1
    } else {
        $exePaths = es -r "\.exe$" $targetExe | Where-Object { $_ -notmatch "Recycle\.Bin" -and $_ -notmatch "ps2exe" }
        #region Overrides
        if ($targetExe -eq "FreeTube.exe") {
            $exePaths = $exePaths | Where-Object { $_ -notmatch "win-unpacked" -and $_ -notmatch "Uninstall FreeTube.exe" -and $_ -notmatch "\\old-install\\" -and $_ -notmatch "\\7z-out\\" }
        }
        if ($targetExe -eq "Spotify.exe") {
            $exePaths = $exePaths | Where-Object { $_ -notmatch "Minimize-" }
        }
        #endregion
        $exePath = $exePaths | Select-Object -First 1
        if ($exePath -match "scoop") {
            $exePath = $exePath -replace "$scoopName\\[\d.\-beta]+", "$scoopName\current"
        }
    }
    if (-not $exePath) {
        script:Log "Taskbar: No path found for $targetExe"
        return "$env:WINDIR\explorer.exe"
    }
    return $exePath
}

function script:Log {
    param (
        [string]$message,
        [switch]$Verbose
    )
    
    $time = $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
    Add-Content $script:logFilePath -Value "$time $message"
    if ($Verbose) {
        Write-Verbose "$($time): $message"
    } else {
        Write-Host $time -ForegroundColor Green -NoNewline
        Write-Host " $message" -ForegroundColor DarkCyan
    }
}

function script:New-Shortcut {
    # from: https://stackoverflow.com/a/21967566/22410757
    param(
        [Parameter(ValueFromPipelineByPropertyName=$true)]
        $LinkPath,
        $Hotkey,
        $IconLocation,
        $Arguments,
        $TargetPath
    )

    begin {
        $shell = New-Object -ComObject WScript.Shell
    }
    
    process {
        $link = $shell.CreateShortcut($LinkPath)

        $PSCmdlet.MyInvocation.BoundParameters.GetEnumerator() |
        Where-Object { $_.key -ne "LinkPath" } |
        ForEach-Object { Write-Verbose "Shortcuts: Asigning $_ = $LinkPath"; $link.$($_.key) = $_.value } | Out-Null

        New-Item -ItemType Directory (Split-Path $LinkPath) -Force | Out-Null

        $link.Save()
    }
}

function script:Unprotect-String {
    # no longer in use, but keeping it around for reference
    param (
        [string]$encryptedString
    )

    if (-not $script:keyString) {
        Write-Warning "No key provided, cannot decrypt string."
        return
    }

    $keyBytes = [System.Text.Encoding]::UTF8.GetBytes($script:keyString)

    $patternIndex = 0
    $patternArray = $script:KeyPaddingPattern.ToCharArray()
    while ($keyBytes.Length -lt 32) {
        $keyBytes += [System.Text.Encoding]::UTF8.GetBytes($patternArray[$patternIndex])
        $patternIndex = ($patternIndex + 1) % $patternArray.Length
    }

    $secureString = ConvertTo-SecureString -String $encryptedString -Key $keyBytes
    $decryptedString = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secureString))
    return $decryptedString
}

function script:Update-EnvPath {
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
}
#endregion

#region Argument Printing
foreach ($arg in $MyInvocation.BoundParameters.keys) {
    switch -regex ($arg) {
        "encryptString|keyString" { 
            $value = "[REDACTED]"
            break
        }
        default {
            $value = (Get-Variable $arg).Value 
        }
    }
    $arglist += "-$arg $value "
}

if ($arglist) {
    script:Log "Run with: $arglist" -Verbose
} else {
    script:Log "Run with no arguments." -Verbose
}
#endregion

#region Encryption
function Protect-String {
    # initially I was encrypting values in .env with this
    # didn't like how ugly it was, plus it made it harder to edit
    # opted to simply not post the filled out .env file publicly
    # keeping this, along with Unprotect-String around for reference
    param (
        [string]$string
    )

    if (-not $script:keyString) {
        Write-Warning "No key provided, cannot encrypt string."
        return
    }

    $keyBytes = [System.Text.Encoding]::UTF8.GetBytes($script:keyString)

    $patternIndex = 0
    $patternArray = $script:KeyPaddingPattern.ToCharArray()
    while ($keyBytes.Length -lt 32) {
        $keyBytes += [System.Text.Encoding]::UTF8.GetBytes($patternArray[$patternIndex])
        $patternIndex = ($patternIndex + 1) % $patternArray.Length
    }

    $secureString = ConvertTo-SecureString $string -AsPlainText -Force
    $encryptedString = ConvertFrom-SecureString -SecureString $secureString -Key $keyBytes
    return $encryptedString
}

if ($script:encryptString) {
    Protect-String $script:encryptString
    Exit 0
}
#endregion

#region GUI
function Show-WinForm {
    $host.UI.RawUI.WindowTitle = "Waiting for selection"
    Add-Type -AssemblyName System.Windows.Forms

    function Show-GroupBoxes {
        function Show-GroupBox {
            param (
                [string]$categoryName,
                [array]$categoryEntries,
                [int]$top
            )
        
            $groupBox = New-Object System.Windows.Forms.GroupBox
            $groupBox.Text = $categoryName
            $groupBox.Size = New-Object System.Drawing.Size(360, 200)
            $groupBox.Location = New-Object System.Drawing.Point(10, $top)
            $groupBox.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#212121")
            $groupBox.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#c8c8c8")
        
            $checkedListBox = New-Object System.Windows.Forms.CheckedListBox
            $checkedListBox.Width = 340
            $checkedListBox.Location = New-Object System.Drawing.Point(10, 20)
            $checkedListBox.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#191919")
            $checkedListBox.BorderStyle = [System.Windows.Forms.BorderStyle]::None
            $checkedListBox.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#c8c8c8")
        
            foreach ($entry in $categoryEntries) {
                $index = $checkedListBox.Items.Add($entry)
                if ($script:required -contains $entry) {
                    $checkedListBox.SetItemChecked($index, $true)
                    $checkedListBox.SetItemCheckState($index, [System.Windows.Forms.CheckState]::Indeterminate)
                    $checkedListBox.Add_ItemCheck({
                        param($changeSender, $e)
                        $entry = $changeSender.Items[$e.Index]
                        if ($script:required -contains $entry) {
                            $e.NewValue = [System.Windows.Forms.CheckState]::Indeterminate
                        }
                    })
                } elseif ($script:preselected -contains $entry) {
                    $checkedListBox.SetItemChecked($index, $true)
                }
            }

            $itemHeight = 16.75
            $checkedListBox.Height = $categoryEntries.Length * $itemHeight
            $groupBox.Height = $checkedListBox.Height + 40
            $groupBox.Controls.Add($checkedListBox)

            return $groupBox, $checkedListBox
        }
    
        $panel = New-Object System.Windows.Forms.Panel
        $panel.AutoScroll = $true
        $panel.Dock = [System.Windows.Forms.DockStyle]::Fill
        $panel.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#212121")
    
        $top = 0
        $checkedListBoxes = @()
        foreach ($category in $script:selection.Keys | Sort-Object) {
            $groupBox, $checkedListBox = Show-GroupBox -categoryName $category -categoryEntries $script:selection[$category] -top $top
            $checkedListBoxes += $checkedListBox
            $panel.Controls.Add($groupBox)
            $top += $groupBox.Height + 10
        }
    
        return $panel, $checkedListBoxes
    }

    function Show-SelectButtons {
        param (
            [array]$checkedListBoxes
        )
    
        $panel = New-Object System.Windows.Forms.Panel
        $panel.Dock = [System.Windows.Forms.DockStyle]::Fill
        $panel.Height = 0
    
        $selectAllButton = New-Object System.Windows.Forms.Button
        $selectAllButton.Text = "Select All"
        $selectAllButton.Width = 170
        $selectAllButton.Location = New-Object System.Drawing.Point(10, 0)
        $selectAllButton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
        $selectAllButton.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#191919")
        $selectAllButton.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#c8c8c8")

        $deselectAllButton = New-Object System.Windows.Forms.Button
        $deselectAllButton.Text = "Deselect All"
        $deselectAllButton.Width = 170
        $deselectAllButton.Location = New-Object System.Drawing.Point(200, 0)
        $deselectAllButton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
        $deselectAllButton.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#191919")
        $deselectAllButton.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#c8c8c8")
    
        $selectAllButton.Add_Click({
            foreach ($checkedListBox in $checkedListBoxes) {
                for ($i = 0; $i -lt $checkedListBox.Items.Count; $i++) {
                    if ($checkedListBox.GetItemCheckState($i) -ne [System.Windows.Forms.CheckState]::Indeterminate) {
                        $checkedListBox.SetItemChecked($i, $true)
                    }
                }
            }
        })
    
        $deselectAllButton.Add_Click({
            foreach ($checkedListBox in $checkedListBoxes) {
                for ($i = 0; $i -lt $checkedListBox.Items.Count; $i++) {
                    if ($checkedListBox.GetItemCheckState($i) -ne [System.Windows.Forms.CheckState]::Indeterminate) {
                        $checkedListBox.SetItemChecked($i, $false)
                    }
                }
            }
        })
    
        $panel.Controls.Add($selectAllButton)
        $panel.Controls.Add($deselectAllButton)
    
        return $panel
    }

    function Show-ProceedButton {
        param (
            [System.Windows.Forms.Form]$form,
            [array]$checkedListBoxes
        )
    
        $button = New-Object System.Windows.Forms.Button
        $button.Text = "Proceed"
        $button.Dock = [System.Windows.Forms.DockStyle]::Fill
        $button.Height = 40
        $button.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
        $button.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#191919")
        $button.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#c8c8c8")
    
        $button.Add_Click({
            $script:selected = @()
            foreach ($checkedListBox in $checkedListBoxes) {
                $script:selected += $checkedListBox.CheckedItems
            }
            $form.Hide()
            Invoke-Setup
            $form.Close()
        })
    
        return $button
    }

    $form = New-Object System.Windows.Forms.Form
    $form.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#212121")
    $form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog 
    $form.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon("$PSScriptRoot\Icons\Transparent.ico")
    $form.MaximizeBox = $false
    $form.Size = New-Object System.Drawing.Size(420, 690)
    $form.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen
    $form.Text = ""

    $tableLayoutPanel = New-Object System.Windows.Forms.TableLayoutPanel
    $tableLayoutPanel.Dock = [System.Windows.Forms.DockStyle]::Fill
    $tableLayoutPanel.RowCount = 3
    $tableLayoutPanel.ColumnCount = 1
    $tableLayoutPanel.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent, 5)))
    $tableLayoutPanel.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent, 85)))
    $tableLayoutPanel.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent, 10)))

    $groupboxPanel, $checkedListBoxes = Show-GroupBoxes

    foreach ($checkedListBox in $checkedListBoxes) {
        $checkedListBox.Add_MouseWheel({
            param($source, $e)
            $currentPosition = $groupboxPanel.VerticalScroll.Value
            $newY = [System.Math]::Max([System.Math]::Min($currentPosition - $e.Delta, $groupboxPanel.VerticalScroll.Maximum), $groupboxPanel.VerticalScroll.Minimum)
            $groupboxPanel.VerticalScroll.Value = $newY
            $groupboxPanel.PerformLayout()
        })
    }

    $selectButtonsPanel = Show-SelectButtons -checkedListBoxes $checkedListBoxes
    $proceedButton = Show-ProceedButton -form $form -checkedListBoxes $checkedListBoxes
    $tableLayoutPanel.Controls.Add($selectButtonsPanel, 0, 0)
    $tableLayoutPanel.Controls.Add($groupboxPanel, 0, 1)
    $tableLayoutPanel.Controls.Add($proceedButton, 0, 2)

    $form.Controls.Add($tableLayoutPanel)

    $form.Add_Shown({
        if ($groupboxPanel.Controls.Count -gt 0) {
            $groupboxPanel.Controls[0].Focus()
        }
    })

    $form.ShowDialog() | Out-Null
}
#endregion

#region Setup
function Invoke-Setup {
    begin {
        # $host.UI.RawUI.BackgroundColor = "Black"
        $host.UI.RawUI.WindowTitle = "Running pre-setup"

        function Copy-Icons {
            Write-Host "Copying icons..."
            New-Item -ItemType Directory "$env:USERPROFILE\Pictures\Icons" -Force | Out-Null
            New-Item -ItemType Directory "$env:USERPROFILE\Pictures\System" -Force | Out-Null
            Copy-Item "$PSScriptRoot\Icons\*" -Destination "$env:USERPROFILE\Pictures\System" -Force
            Get-ChildItem -Path "$env:USERPROFILE\Pictures\System" | ForEach-Object {
                $sourcePath = $_.FullName
                $linkPath = Join-Path -Path "$env:USERPROFILE\Pictures\Icons" -ChildPath $_.Name
                New-Item -ItemType SymbolicLink $linkPath -Target $sourcePath -Force | Out-Null
            }
        }

        function Edit-EntryOrder {
            $defaultOrderValue = 9001
        
            $script:selected = $script:selected | Sort-Object {
                $entry = $_
                if ($script:ordering.ContainsKey($entry)) {
                    return $script:ordering[$entry]
                } else {
                    return $defaultOrderValue
                }
            }
        }

        function Enable-DarkMode {
            Write-Host "Enabling dark mode..."
            Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "AppsUseLightTheme" -Value 0
            Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "SystemUsesLightTheme" -Value 0
        }

        function Enable-SmallTaskbarIcons {
            Write-Host "Enabling small taskbar icons..."
            Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarSmallIcons" -Value 1 -Type DWORD
        }

        function Disable-LanguageSwitchHotkeys {
            Write-Host "Disabling language switch hotkeys..."
            New-Item "HKCU:\Keyboard Layout\Toggle" -Force | Out-Null
            Set-ItemProperty "HKCU:\Keyboard Layout\Toggle" -Name "Hotkey" -Value 3 -Type String
            Set-ItemProperty "HKCU:\Keyboard Layout\Toggle" -Name "Language Hotkey" -Value 3 -Type String
            Set-ItemProperty "HKCU:\Keyboard Layout\Toggle" -Name "Layout Hotkey" -Value 3 -Type String
        }

        function Disable-MicrosoftAccounts {
            Write-Host "Disabling Microsoft accounts..."
            reg import "$PSScriptRoot\Configs\Regedits\Microsoft-Accounts\Cant-add-or-sign-in-with-Microsoft-accounts.reg" 2>$null
        }

        function Disable-MouseAcceleration {
            Write-Host "Disabling mouse acceleration..."
            Set-ItemProperty "HKCU:\Control Panel\Mouse" -Name "MouseSpeed" -Value 0
            Set-ItemProperty "HKCU:\Control Panel\Mouse" -Name "MouseThreshold1" -Value 0
            Set-ItemProperty "HKCU:\Control Panel\Mouse" -Name "MouseThreshold2" -Value 0
        }

        function Hide-DriveSpaceIndicators {
            Write-Host "Hiding drive space indicators..."
            reg import "$PSScriptRoot\Configs\Regedits\Drive-Space-Indicator-Bar\Remove-Drive-Space-Indicator-Bar.reg" 2>$null
        }

        function Initialize-PackageManagers {
            function Initialize-Choco {
                if (-not (Get-Command "choco" -ErrorAction SilentlyContinue)) {
                    Write-Host "Initializing chocolatey..."
                    Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1')
                }
            }

            function Initialize-Scoop {
                if (-not (Get-Command "scoop" -ErrorAction SilentlyContinue)) {
                    Write-Host "Initializing scoop..."
                    Start-Process powershell -WindowStyle Hidden "runas /trustlevel:0x20000 'powershell Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression'" -Wait
                    $freshScoop = $true
                }

                script:Update-EnvPath

                if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
                    scoop install git
                }

                if ($freshScoop) {
                    scoop bucket rm main
                    Write-Host "Adding main bucket to scoop..."
                    Start-Process powershell -WindowStyle Hidden -Args "runas /trustlevel:0x20000 'powershell -WindowStyle Hidden scoop bucket add main'" -Wait
                }

                # https://github.com/ScoopInstaller/Scoop/blob/master/buckets.json
                $targetBuckets = @(
                    "extras",
                    "games",
                    "java",
                    "main",
                    "nerd-fonts",
                    "nirsoft",
                    "nonportable",
                    "sysinternals",
                    "versions",
                    "bergbok = https://github.com/Bergbok/Scoop-Bucket.git"
                )

                foreach ($bucket in $targetBuckets) {
                    $bucketInfo = $bucket -split " = "
                    $bucketName = $bucketInfo[0]
                    $bucketUrl = $bucketInfo[1]
                    while (-not (scoop bucket list | Select-String -Pattern $bucketName -SimpleMatch)) {
                        Write-Host "Adding $bucketName bucket to scoop..."
                        Start-Process powershell -WindowStyle Hidden -Args "runas /trustlevel:0x20000 'powershell -WindowStyle Hidden scoop bucket add $bucketName $bucketUrl'" -Wait
                    }
                }

                if (-not (scoop alias list -like "*force-update*")) {
                    scoop alias add force-update "scoop unhold `$args[0]; scoop update `$args[0]; scoop hold `$args[0]"
                }

                git config --global --add safe.directory "$env:USERPROFILE\scoop\apps\scoop\current"
            }

             function Initialize-WinGet {
                if (-not (Get-Command "winget" -ErrorAction SilentlyContinue)) {
                    Write-Host "Initializing winget..."
                    if ($script:packageManagerPreference -match "^choco") {
                        choco install winget-cli -y
                    } else {
                        scoop install main/winget
                        scoop install extras/vcredist
                    }
                }
                winget source remove msstore
                winget settings --enable InstallerHashOverride
            }

            Write-Host "Initializing package managers..."
            Initialize-Choco
            Initialize-Scoop
            Initialize-WinGet
        }

        function Invoke-Everything {
            if (Get-Command "everything" -ErrorAction SilentlyContinue) {
                Start-Process "everything" -WindowStyle Minimized
            } else {
                $driveRoots = Get-PSDrive -PSProvider FileSystem |  Select-Object -ExpandProperty Root | Where-Object { $_ -notlike "*Temp*" }
                foreach ($driveRoot in $driveRoots) {
                    $everythingPath = "$($driveRoot)Program Files\Everything\Everything.exe"
                    if (Test-Path $everythingPath) {
                        Start-Process $everythingPath -WindowStyle Minimized
                        break
                    }
                }
            }
        }

        function New-EssentialFolders {
            Write-Host "Creating essential folders..."

            $essentialFolders = @(
                "$env:USERPROFILE\Audio"
                "$env:USERPROFILE\Audio\SFX"
                "$env:USERPROFILE\Audio\Music"
                "$env:USERPROFILE\Code"
                "$env:USERPROFILE\Code\Scripts"
                "$env:USERPROFILE\Code\Scripts\ps2exe"
                "$env:USERPROFILE\Downloads\Audio"
                "$env:USERPROFILE\Games"
                "$env:USERPROFILE\Games\ROMs"
                "$env:USERPROFILE\Games\Steam Libraries"
                "$env:USERPROFILE\Pictures\Screenshots"
                "$env:USERPROFILE\Pictures\Wallpapers"
                "$env:WINDIR\God Mode.{ED7BA470-8E54-465E-825C-99712043E01C}"
            )

            foreach ($folder in $essentialFolders) {
                New-Item -ItemType Directory $folder -Force | Out-Null
                # (Get-Item $folder).CreationTime = Get-Date "1640-04-20 04:20:00"
            }

            New-Item -ItemType SymbolicLink "$env:USERPROFILE\Audio\Music" -Target "$env:USERPROFILE\Music" -Force | Out-Null
            New-Item -ItemType SymbolicLink "$env:USERPROFILE\Audio\Downloads" -Target "$env:USERPROFILE\Downloads\Audio" -Force | Out-Null
        }

        function Update-CursorSize {
            param (
                [int]$size = 64
            )

            Write-Host "Updating cursor size..."

            [SystemParametersInfo.WinAPICall]::SystemParametersInfo(0x2029, $null, $size, 0x01);
        }

        function Update-ScrollLineCount {
            param (
                [int]$lines = 4
            )

            Write-Host "Updating scroll line count..."
            
            [SystemParametersInfo.WinAPICall]::SystemParametersInfo(0x0069, $lines, $null, $null)
        }

        function Set-AccentColor {
            reg import "$PSScriptRoot\Configs\Regedits\Accent-Color\Gray.reg" 2>$null
            Stop-Process -Name "explorer"
            if (-not (Get-Process "explorer" -ErrorAction SilentlyContinue)) {
                Start-Process "explorer"
            }
        }

        function Set-ExplorerStartupLocation {
            Write-Host "Setting Explorer startup location..."
            reg import "$PSScriptRoot\Configs\Regedits\Explorer-Startup-Location\Open-File-Explorer-to-This-PC.reg" 2>$null
        }

        function Show-ExplorerFileExtensions {
            Write-Host "Showing file extensions..."
            Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Value 0
        }

        function Sync-Time {
            Write-Host "Syncing time..."
            Set-TimeZone $script:timezoneID
            & "$PSScriptRoot\Scripts\Startup\Sync-Time.ps1" *>$null
        }

        function Show-HiddenFilesAndFolders {
            Write-Host "Showing hidden files and folders..."
            Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Hidden" -Value 1
        }
        
        function Show-HiddenSystemFilesAndFolders {
            Write-Host "Showing hidden system files and folders..."
            Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowSuperHidden" -Value 1
        }

        Add-Type -MemberDefinition "[DllImport(`"user32.dll`", EntryPoint = `"SystemParametersInfo`")] public static extern bool SystemParametersInfo(uint uiAction, uint uiParam, uint pvParam, uint fWinIni);" -Name WinAPICall -Namespace SystemParametersInfo -PassThru

        Copy-Icons
        Edit-EntryOrder
        Enable-DarkMode
        Enable-SmallTaskbarIcons
        Disable-LanguageSwitchHotkeys
        Disable-MicrosoftAccounts
        Disable-MouseAcceleration
        Hide-DriveSpaceIndicators
        Initialize-PackageManagers
        Invoke-Everything
        New-EssentialFolders
        Update-CursorSize
        Update-ScrollLineCount
        Set-AccentColor
        Set-ExplorerStartupLocation
        Show-ExplorerFileExtensions
        Sync-Time
        Show-HiddenFilesAndFolders
        Show-HiddenSystemFilesAndFolders

        if (-not (Get-Command 7z -ErrorAction SilentlyContinue)) {
            scoop install main/7zip
        }

        $selectedString = $script:selected -join ", "
        $selectedString = $selectedString.TrimEnd(", ")

        script:Log "Selected: $selectedString" -Verbose
    }

    process {
        $host.UI.RawUI.WindowTitle = "Running setup"

        $preferences = $script:packageManagerPreference -split ","

        function Get-WingetElevationRequirement {
            param (
                [string]$installCommand
            )
        
            Write-Verbose "Checking winget package elevation requirement..."

            if ($installCommand -match '--id=([^\s]+)') {
                $id = $matches[1]
            }
        
            if ($installCommand -match "(?:-v|--version)\s+(?:[`"']?)([^`"']+)(?:[`"']?)") {
                $version = $matches[1]
            }
        
            $deconstructedID = $id.Split('.')
            $owner = $deconstructedID[0]
            $ownerInitial = $owner.Substring(0, 1).ToLower()
            $name = $deconstructedID[1]
        
            if (-not $version) {
                $apiUrl = "https://api.github.com/repos/microsoft/winget-pkgs/commits?path=manifests/$ownerInitial/$owner/$name"
                $commits = @()
                while ($commits.Length -eq 0) {
                    Write-Verbose "Checking commits at $apiUrl"
                    try {
                        $commits = Invoke-RestMethod $apiUrl
                    } catch {
                        Write-Verbose "Could not retrieve commits, possibly rate limited."
                        return $false
                    }
                }
                $index = 0
                while (-not ($matched)) {
                    $commitMessage = ($commits | Select-Object -Index $index).commit.message
                    if ($null -eq $commitMessage) {
                        Write-Verbose "Could not determine package elevation requirement."
                        return $false
                    }
                    if ($commitMessage -match "(?<=Automatic update of|New version:|ReleaseNotes:) $owner\.$name (?:from .* to |version )?(.*?)(?= \()") {
                        $version = $matches[1]
                        $matched = $true
                        Write-Verbose "Latest version is $version"
                    }
                    $index++
                }
            }
        
            $manifestUrl = "https://raw.githubusercontent.com/microsoft/winget-pkgs/refs/heads/master/manifests/$ownerInitial/$owner/$name/$version/$owner.$name.installer.yaml"
            Write-Verbose "Checking manifest at $manifestUrl"
            $manifest = Invoke-RestMethod -Uri $manifestUrl

            Write-Verbose "Finished checking winget package elevation requirement..."
        
            if ($manifest -match "ElevationRequirement:\s*elevationProhibited") {
                return $true
            } else {
                return $false
            }
        }

        foreach ($entry in $script:selected) {
            if (-not $script:commands.ContainsKey($entry) -and ($entry -ne "7z")) {
                script:Log "No setup commands found for '$entry'."
                continue
            }

            $commands = $script:commands[$entry]
            $executedPackageManager = $false
    
            foreach ($pref in $preferences) {
                foreach ($command in $commands) {
                    if ($command -match "^$pref") {
                        # Read-Host
                        Write-Verbose "`nSetting up $entry with $pref`n"
                        if ($command -match "^choco|^winget") {
                            if ($command -match "^winget" -and ($command -match "--ignore-security-hash" -or (Get-WingetElevationRequirement $command))) {
                                Write-Verbose "Executing: gsudo --integrity Medium -- $command`n"
                                gsudo --integrity Medium -- $command
                            } else {
                                Write-Verbose "Executing: $command`n"
                                Start-Process powershell -Args $command -Wait -NoNewWindow
                            }
                        } else {
                            Write-Verbose "Executing: $command`n"
                            Invoke-Expression $command
                        }
                        $executedPackageManager = $true
                        break
                    }
                }
                if ($executedPackageManager) { 
                    break 
                }
            }
    
            foreach ($command in $commands) {
                if ($command -notmatch "^(choco|scoop|winget)") {
                    Write-Verbose "Executing command: $command`n"
                    # Read-Host
                    Invoke-Expression $command
                }
            }
        }
    }

    end {
        $host.UI.RawUI.WindowTitle = "Running post-setup"

        function Add-QuickAccessPins {
            $shell = New-Object -ComObject Shell.Application
            $shell.Namespace($env:USERPROFILE).Self.InvokeVerb("pintohome")
            $shell.Namespace("$env:USERPROFILE\AppData").Self.InvokeVerb("pintohome")
            $shell.Namespace("$env:USERPROFILE\Audio").Self.InvokeVerb("pintohome")
            $shell.Namespace("$env:USERPROFILE\scoop").Self.InvokeVerb("pintohome")
            $shell.Namespace("$env:USERPROFILE\Videos").Self.InvokeVerb("pintohome")
            $shell.Namespace("$env:SYSTEMDRIVE\`$Recycle.Bin\$((Get-LocalUser -Name $env:USERNAME).SID.Value)").Self.InvokeVerb("pintohome")
        }

        function Confirm-SysinternalsEula {
            if ($script:selected | Where-Object { $script:selection["Sysinternals"] -contains $_ }) {
                Write-Host "Accepting Sysinternals EULA..."
                if (-not (Test-Path "HKCU:\Software\Sysinternals")) { 
                    New-Item "HKCU:\Software\Sysinternals" -Force | Out-Null 
                }
                Set-ItemProperty "HKCU:\Software\Sysinternals" -Name "EulaAccepted" -Value 1 -Force
            }
        }

        function Copy-Scripts {
            Write-Host "Copying scripts..."
            New-Item -ItemType Directory "$env:USERPROFILE\Code\Scripts" -Force | Out-Null
            Copy-Item "$PSScriptRoot\Scripts\*" -Exclude "Startup", "Close-SekiroFpsUnlockAndMore.ps1", "Install-Discord-OpenAsar.ps1", "ps2exe-exe2ps.ps1", "Sophia-Script-Uninstall-Bloat.ps1", "Open-Volume-Mixer.ps1", "Refresh-Rainmeter.ps1" -Destination "$env:USERPROFILE\Code\Scripts" -Force
        }

        function Edit-Icons {
            Write-Host "Editing icons..."
            function Out-IniFile {
                # modified from: https://devblogs.microsoft.com/scripting/use-powershell-to-work-with-any-ini-file/
                param (
                    [hashtable]$inputObject,
                    [string]$filePath
                )
                $outFile = New-Item -ItemType File -Path $filepath -Force
                foreach ($i in $inputObject.keys) {
                    if (!(($inputObject[$i].GetType().Name) -eq "Hashtable")) {
                    #No Sections
                    Add-Content -Path $outFile -Value "$i=$($inputObject[$i])"
                    } else {
                    #Sections
                    Add-Content -Path $outFile -Value "[$i]"
                    foreach ($j in ($inputObject[$i].keys | Sort-Object)) {
                        if ($j -match "^Comment[\d]+") {
                        Add-Content -Path $outFile -Value "$($inputObject[$i][$j])"
                        } else {
                        Add-Content -Path $outFile -Value "$j=$($inputObject[$i][$j])"
                        }
                    }
                    }
                }
            }

            $desktopInis = @{
                "Home" = @{
                    "Path" = $env:USERPROFILE
                    "ini" = @{
                        ".ShellClassInfo" = @{
                            "IconResource" = "$env:WINDIR\System32\imageres.dll,74"
                        }
                    }
                }
                "Home - Audio" = @{
                    "Path" = "$env:USERPROFILE\Audio"
                    "ini" = @{
                        ".ShellClassInfo" = @{
                            "IconResource" = "$env:WINDIR\System32\imageres.dll,77"
                        }
                    }
                }
                "Home - Code" = @{
                    "Path" = "$env:USERPROFILE\Code"
                    "ini" = @{
                        ".ShellClassInfo" = @{
                            "IconResource" = "$env:USERPROFILE\Pictures\System\Chevron-Brackets-File.ico,0"
                        }
                    }
                }
                "Home - Games" = @{
                    "Path" = "$env:USERPROFILE\Games"
                    "ini" = @{
                        ".ShellClassInfo" = @{
                            "IconResource" = "$env:WINDIR\System32\imageres.dll,10"
                        }
                    }
                }
                "Home - scoop" = @{
                    "Path" = "$env:USERPROFILE\scoop"
                    "ini" = @{
                        ".ShellClassInfo" = @{
                            "IconResource" = "$env:USERPROFILE\Pictures\System\Scoop.ico,0"
                        }
                    }
                }
                "Home - Videos" = @{
                    "Path" = "$env:USERPROFILE\Videos"
                    "ini" = @{
                        ".ShellClassInfo" = @{
                            "LocalizedResourceName" = "@%SystemRoot%\system32\shell32.dll,-21791"
                            "InfoTip" = "@%SystemRoot%\system32\shell32.dll,-12690"
                            "IconResource" = "%SystemRoot%\system32\imageres.dll,-189"
                            "IconFile" = "%SystemRoot%\system32\shell32.dll"
                            "IconIndex" = "-238"
                        }
                    }
                }
                "Documents - Adobe" = @{
                    "Path" = "$env:USERPROFILE\Documents\Adobe"
                    "ini" = @{
                        ".ShellClassInfo" = @{
                            "IconResource" = "$env:USERPROFILE\Pictures\System\Adobe.ico,0"
                        }
                    }
                }
                "Documents - Aseprite" = @{
                    "Path" = "$env:USERPROFILE\Documents\Aseprite"
                    "ini" = @{
                        ".ShellClassInfo" = @{
                            "IconResource" = "$env:USERPROFILE\Pictures\System\Aseprite.ico,0"
                        }
                    }
                }
                "Documents - Books" = @{
                    "Path" = "$env:USERPROFILE\Documents\Books"
                    "ini" = @{
                        ".ShellClassInfo" = @{
                            "IconResource" = "$env:USERPROFILE\Pictures\System\Calibre.ico,0"
                        }
                    }
                }
                "Documents - Cheat Engine Tables" = @{
                    "Path" = "$env:USERPROFILE\Documents\Cheat Engine Tables"
                    "ini" = @{
                        ".ShellClassInfo" = @{
                            "IconResource" = "$env:USERPROFILE\Pictures\System\Cheat-Engine.ico,0"
                        }
                    }
                }
                "Documents - Dolphin" = @{
                    "Path" = "$env:USERPROFILE\Documents\Dolphin Emulator"
                    "ini" = @{
                        ".ShellClassInfo" = @{
                            "IconResource" = "$env:WINDIR\System32\imageres.dll,10"
                        }
                    }
                }
                "Documents - FromSoftware" = @{
                    "Path" = "$env:USERPROFILE\Documents\FromSoftware"
                    "ini" = @{
                        ".ShellClassInfo" = @{
                            "IconResource" = "$env:WINDIR\System32\imageres.dll,10"
                            "InfoTip" = "YOU DIED"
                        }
                    }
                }
                "Documents - Fonts" = @{
                    "Path" = "$env:USERPROFILE\Documents\Fonts"
                    "ini" = @{
                        ".ShellClassInfo" = @{
                            "IconResource" = "$env:WINDIR\System32\imageres.dll,123"
                        }
                    }
                }
                "Documents - KeePass" = @{
                    "Path" = "$env:USERPROFILE\Documents\KeePass"
                    "ini" = @{
                        ".ShellClassInfo" = @{
                            "IconResource" = "$env:USERPROFILE\Pictures\System\KeePassXC-File.ico,0"
                        }
                    }
                }
                "Documents - Koei Tecmo" = @{
                    "Path" = "$env:USERPROFILE\Documents\KoeiTecmo"
                    "ini" = @{
                        ".ShellClassInfo" = @{
                            "IconResource" = "$env:WINDIR\System32\imageres.dll,10"
                        }
                    }
                }
                "Documents - LoversInADangerousSpacetime" = @{
                    "Path" = "$env:USERPROFILE\Documents\LoversInADangerousSpacetime"
                    "ini" = @{
                        ".ShellClassInfo" = @{
                            "IconResource" = "$env:WINDIR\System32\imageres.dll,10"
                        }
                    }
                }
                "Documents - My Games" = @{
                    "Path" = "$env:USERPROFILE\Documents\My Games"
                    "ini" = @{
                        ".ShellClassInfo" = @{
                            "IconResource" = "$env:WINDIR\System32\imageres.dll,10"
                        }
                    }
                }
                "Documents - NGBI " = @{
                    "Path" = "$env:USERPROFILE\Documents\NGBI"
                    "ini" = @{
                        ".ShellClassInfo" = @{
                            "IconResource" = "$env:WINDIR\System32\imageres.dll,10"
                        }
                    }
                }
                "Documents - Obsidian" = @{
                    "Path" = "$env:USERPROFILE\Documents\Obsidian"
                    "ini" = @{
                        ".ShellClassInfo" = @{
                            "IconResource" = "$(es -i -n 1 -r "\.exe$" "Obsidian.exe"),0"
                        }
                    }
                }
                "Documents - Overwatch" = @{
                    "Path" = "$env:USERPROFILE\Documents\Overwatch"
                    "ini" = @{
                        ".ShellClassInfo" = @{
                            "IconResource" = "$env:WINDIR\System32\imageres.dll,10"
                        }
                    }
                }
                "Documents - PowerShell" = @{
                    "Path" = "$env:USERPROFILE\Documents\PowerShell"
                    "ini" = @{
                        ".ShellClassInfo" = @{
                            "IconResource" = "$env:USERPROFILE\Pictures\System\PowerShell.ico,0"
                        }
                    }
                }
                "Documets - PPSSPP" = @{
                    "Path" = "$env:USERPROFILE\Documents\PPSSPP"
                    "ini" = @{
                        ".ShellClassInfo" = @{
                            "IconResource" = "$env:WINDIR\System32\imageres.dll,10"
                        }
                    }
                }
                "Documents - Rockstar Games" = @{
                    "Path" = "$env:USERPROFILE\Documents\Rockstar Games"
                    "ini" = @{
                        ".ShellClassInfo" = @{
                            "IconResource" = "$env:WINDIR\System32\imageres.dll,10"
                        }
                    }
                }
                "Documents - Salt and Sanctuary" = @{
                    "Path" = "$env:USERPROFILE\Documents\Salt and Sanctuary"
                    "ini" = @{
                        ".ShellClassInfo" = @{
                            "IconResource" = "$env:WINDIR\System32\imageres.dll,10"
                        }
                    }
                }
                "Documents - Saved Games" = @{
                    "Path" = "$env:USERPROFILE\Documents\Saved Games"
                    "ini" = @{
                        ".ShellClassInfo" = @{
                            "IconResource" = "$env:WINDIR\System32\imageres.dll,10"
                        }
                    }
                }
                "Documents - Skullgirls" = @{
                    "Path" = "$env:USERPROFILE\Documents\Skullgirls"
                    "ini" = @{
                        ".ShellClassInfo" = @{
                            "IconResource" = "$env:WINDIR\System32\imageres.dll,10"
                        }
                    }
                }
                "Documents - The Witcher 3" = @{
                    "Path" = "$env:USERPROFILE\Documents\The Witcher 3"
                    "ini" = @{
                        ".ShellClassInfo" = @{
                            "IconResource" = "$env:WINDIR\System32\imageres.dll,10"
                        }
                    }
                }
                "Documents - WindowsPowerShell" = @{
                    "Path" = "$env:USERPROFILE\Documents\WindowsPowerShell"
                    "ini" = @{
                        ".ShellClassInfo" = @{
                            "IconResource" = "$env:USERPROFILE\Pictures\System\PowerShell.ico,0"
                        }
                    }
                }
                "Downloads - Audio" = @{
                    "Path" = "$env:USERPROFILE\Downloads\Audio"
                    "ini" = @{
                        ".ShellClassInfo" = @{
                            "IconResource" = "%SystemRoot%\System32\imageres.dll,25"
                        }
                    }
                }
                "Games - Steam Libraries" = @{
                    "Path" = "$env:USERPROFILE\Games\Steam Libraries"
                    "ini" = @{
                        ".ShellClassInfo" = @{
                            "IconResource" = "$env:USERPROFILE\Pictures\System\Steam.ico,0"
                        }
                    }
                }
                "Open-Shell Start Menu - Calibre" = @{
                    "Path" = "$env:APPDATA\OpenShell\Pinned\Open Shell"
                    "ini" = @{
                        ".ShellClassInfo" = @{
                            "IconResource" = "$env:USERPROFILE\Pictures\System\Open-Shell.ico,0"
                        }
                    }
                }
                "Open-Shell Start Menu - OpenShell" = @{
                    "Path" = "$env:APPDATA\OpenShell\Pinned\Open Shell"
                    "ini" = @{
                        ".ShellClassInfo" = @{
                            "IconResource" = "$env:USERPROFILE\Pictures\System\Open-Shell.ico,0"
                        }
                    }
                }
                "Pictures - Screenshots" = @{
                    "Path" = "$env:USERPROFILE\Pictures\Screenshots"
                    "ini" = @{
                        ".ShellClassInfo" = @{
                            "IconResource" = "$env:WINDIR\System32\SHELL32.dll,326"
                        }
                    }
                }
            }

            foreach ($key in $desktopInis.Keys) {
                $hashtable = $desktopInis[$key]
                $filePath = "$($hashtable["Path"])\desktop.ini"
                New-Item -ItemType Directory $hashtable["Path"] -Force | Out-Null
                attrib +R $hashtable["Path"] | Out-Null
                attrib -H -S $filePath | Out-Null
                Out-IniFile $hashtable["ini"] "$($hashtable["Path"])\desktop.ini"
                Set-ItemProperty $filePath -Name "Attributes" -Value "Archive,Hidden,System"
            }
        }

        function Hide-DesktopIcons {
            Write-Host "Hiding desktop icons..."
            Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideIcons" -Value 1 -Force
            Stop-Process -Name "explorer"
            if (-not (Get-Process "explorer" -ErrorAction SilentlyContinue)) {
                Start-Process "explorer"
            }
        }

        function Hide-FoldersAndFiles {
            Write-Host "Hiding folders and files..."

            $itemsToHide = @(
                "$env:USERPROFILE\.azuredatastudio"
                "$env:USERPROFILE\.bash_history"
                "$env:USERPROFILE\.bun"
                "$env:USERPROFILE\.cache"
                "$env:USERPROFILE\.config"
                "$env:USERPROFILE\.dbus-keyrings"
                "$env:USERPROFILE\.deno"
                "$env:USERPROFILE\.docker"
                "$env:USERPROFILE\.gk"
                "$env:USERPROFILE\.gnupg"
                "$env:USERPROFILE\.gtk-bookmarks"
                "$env:USERPROFILE\.idlerc"
                "$env:USERPROFILE\.lesshst"
                "$env:USERPROFILE\.librarymanager"
                "$env:USERPROFILE\.local"
                "$env:USERPROFILE\.minttyrc"
                "$env:USERPROFILE\.node_repl_history"
                "$env:USERPROFILE\.nuget"
                "$env:USERPROFILE\.obs32"
                "$env:USERPROFILE\.obs64"
                "$env:USERPROFILE\.openjfx"
                "$env:USERPROFILE\.pm2"
                "$env:USERPROFILE\.software"
                "$env:USERPROFILE\.ssh"
                "$env:USERPROFILE\.templateengine"
                "$env:USERPROFILE\.veadotube"
                "$env:USERPROFILE\.viminfo"
                "$env:USERPROFILE\.VirtualBox"
                "$env:USERPROFILE\.vscode-insiders"
                "$env:USERPROFILE\.vscode-oss"
                "$env:USERPROFILE\.vscode-server"
                "$env:USERPROFILE\.vscode"
                "$env:USERPROFILE\.xdman"
                "$env:USERPROFILE\ansel"
                "$env:USERPROFILE\AppData"
                "$env:USERPROFILE\Application Data"
                "$env:USERPROFILE\Cookies"
                "$env:USERPROFILE\go"
                "$env:USERPROFILE\IntelGraphicsProfiles"
                "$env:USERPROFILE\Links"
                "$env:USERPROFILE\Local Settings"
                "$env:USERPROFILE\NetHood"
                "$env:USERPROFILE\PrintHood"
                "$env:USERPROFILE\Recent"
                "$env:USERPROFILE\Saved Games"
                "$env:USERPROFILE\Searches"
                "$env:USERPROFILE\SendTo"
                "$env:USERPROFILE\source"
                "$env:USERPROFILE\Start Menu"
                "$env:USERPROFILE\Templates"
                "$env:USERPROFILE\Documents\Dolphin Emulator"
                "$env:USERPROFILE\Documents\DuckStation"
                "$env:USERPROFILE\Documents\Eidos"
                "$env:USERPROFILE\Documents\FromSoftware"
                "$env:USERPROFILE\Documents\IISExpress"
                "$env:USERPROFILE\Documents\KoeiTecmo"
                "$env:USERPROFILE\Documents\LoversInADangerousSpacetime"
                "$env:USERPROFILE\Documents\My Games"
                "$env:USERPROFILE\Documents\My Music"
                "$env:USERPROFILE\Documents\My Pictures"
                "$env:USERPROFILE\Documents\My Videos"
                "$env:USERPROFILE\Documents\NGBI"
                "$env:USERPROFILE\Documents\Overwatch"
                "$env:USERPROFILE\Documents\PowerShell"
                "$env:USERPROFILE\Documents\PowerToys"
                "$env:USERPROFILE\Documents\PPSSPP"
                "$env:USERPROFILE\Documents\Rockstar Games"
                "$env:USERPROFILE\Documents\Salt and Sanctuary"
                "$env:USERPROFILE\Documents\Saved Games"
                "$env:USERPROFILE\Documents\Skullgirls"
                "$env:USERPROFILE\Documents\SQL Server Management Studio"
                "$env:USERPROFILE\Documents\The Witcher 3"
                "$env:USERPROFILE\Documents\Visual Studio 2015"
                "$env:USERPROFILE\Documents\Visual Studio 2017"
                "$env:USERPROFILE\Documents\Visual Studio 2019"
                "$env:USERPROFILE\Documents\Visual Studio 2022"
                "$env:USERPROFILE\Documents\WindowsPowerShell".
                "$env:USERPROFILE\Pictures\pngtubers"
            )

            foreach ($itemToHide in $itemsToHide) {
                try {
                    attrib +H $itemToHide
                } catch {
                    Write-Host "Could not hide $itemToHide"
                }
            }

            # Hides Recycle Bin on desktop
            if (-not (Test-Path -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\NonEnum)) {
                New-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies -Name "NonEnum"
            }
            if ((Get-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\NonEnum | Select-Object -ExpandProperty "{645FF040-5081-101B-9F08-00AA002F954E}") -ne 1) {
                Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\NonEnum -Name "{645FF040-5081-101B-9F08-00AA002F954E}" -Value 1 -Type DWORD
                Stop-Process -Name "explorer"
                if (-not (Get-Process "explorer" -ErrorAction SilentlyContinue)) {
                    Start-Process "explorer"
                }
            }
        }

        function Invoke-Debloat {
            function Disable-WindowsFeatures {
                $featureNames = @(
                    "Print.Fax.Scan~~~~0.0.1.0"
                    "MathRecognizer~~~~0.0.1.0"
                    "Hello.Face.18967~~~~0.0.1.0"
                    "OneCoreUAP.OneSync~~~~0.0.1.0"
                    "Language.Speech~~~en-US~0.0.1.0"
                    "App.Support.QuickAssist~~~~0.0.1.0"
                    "Language.Handwriting~~~en-US~0.0.1.0"
                    "Microsoft.Windows.Notepad~~~~0.0.1.0"
                    "Microsoft.Windows.PowerShell.ISE~~~~0.0.1.0"
                )

                foreach ($featureName in $featureNames) {
                    Remove-WindowsCapability -Online -Name $featureName
                }

                $optionalFeatureNames = @(
                    "MSRDC-Infrastructure"
                    "Microsoft-SnippingTool"
                    "Microsoft-RemoteDesktopConnection"
                )
                
                foreach ($featureName in $optionalFeatureNames) {
                    Disable-WindowsOptionalFeature -Online -FeatureName $featureName -NoRestart -Remove
                }
            }

            function Disable-ScheduledTasks {
                # Write-Host "Disabling unneeded scheduled tasks..."

                # $tasks = @(
                #     ""
                # )

                # foreach ($task in $tasks) {
                #     Get-ScheduledTask -TaskName $task | Disable-ScheduledTask -ErrorAction SilentlyContinue
                # }
            }

            function Disable-Services {
                # from: https://github.com/W4RH4WK/Debloat-Windows-10/blob/master/scripts/disable-services.ps1
                # License: THE BEER-WARE LICENSE https://github.com/W4RH4WK/Debloat-Windows-10/blob/master/LICENSE
                # Excluded some services which are included in Sophia/SoS Optimize Harden Debloat
                Write-Host "Disabling unneeded services..."
                $services = @(
                    "lfsvc"                                    # Geolocation Service
                    "NetTcpPortSharing"                        # Net.Tcp Port Sharing Service
                    "RemoteAccess"                             # Routing and Remote Access
                    "RemoteRegistry"                           # Remote Registry
                    "SharedAccess"                             # Internet Connection Sharing (ICS)
                    "TrkWks"                                   # Distributed Link Tracking Client
                    "WbioSrvc"                                 # Windows Biometric Service (required for Fingerprint reader / facial detection)
                    # "WlanSvc"                                # WLAN AutoConfig (Disabling this can cause issues with wifi connectivity)
                    # "wscsvc"                                 # Windows Security Center Service
                    # "WSearch"                                # Windows Search
                    "XblAuthManager"                           # Xbox Live Auth Manager
                    "XblGameSave"                              # Xbox Live Game Save Service
                    "XboxNetApiSvc"                            # Xbox Live Networking Service
                    "ndu"                                      # Windows Network Data Usage Monitor
                )
    
                foreach ($service in $services) {
                    Get-Service -Name $service -ErrorAction SilentlyContinue | Set-Service -StartupType Disabled -ErrorAction SilentlyContinue
                }
            }

            function Disable-StickyKeys {
                Write-Host "Disabling sticky keys..."
                Set-ItemProperty "HKCU:\Control Panel\Accessibility\StickyKeys" -Name "Flags" -Value 58
            }

            function Optimize-ContextMenu {
                Write-Host "Optimizing context menu..."
                # https://www.tenforums.com/tutorials/61525-how-add-remove-cast-device-context-menu-windows-10-a.html
                New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" -Name "{7AD84985-87B4-4a16-BE58-8B72A5B390F7}" -PropertyType String -Value "Play to Menu" -Force # Removes 'Cast to Device', to restore run: Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" -Name "{7AD84985-87B4-4a16-BE58-8B72A5B390F7}"
                reg import "$PSScriptRoot\Configs\Regedits\Context-Menu\Drive-Autoplay\Disable-AutoPlay-For-All-Drives.reg" 2>$null
                reg import "$PSScriptRoot\Configs\Regedits\Context-Menu\Edit-with-Paint-3D\Remove-Edit-With-Paint-3D-From-Context-Menu.reg" 2>$null
                reg import "$PSScriptRoot\Configs\Regedits\Context-Menu\Open-in-Windows-Terminal\Remove-Open-In-Windows-Terminal-Context-Menu-For-Current-User.reg" 2>$null
                reg import "$PSScriptRoot\Configs\Regedits\Context-Menu\Open-Powershell\Remove-Open-PowerShell-Window-Here-Context-Menu.reg" 2>$null
                reg import "$PSScriptRoot\Configs\Regedits\Context-Menu\Pin-to-Start\Remove-Pin-To-Start-Context-Menu.reg" 2>$null
                reg import "$PSScriptRoot\Configs\Regedits\Context-Menu\Pin-to-Taskbar\Remove-Pin-To-Taskbar-Context-Menu.reg" 2>$null
                reg import "$PSScriptRoot\Configs\Regedits\Context-Menu\Previous-Versions\Remove-Previous-Versions-From-Properties-And-Context-Menu.reg" 2>$null
                reg import "$PSScriptRoot\Configs\Regedits\Context-Menu\Scan-with-Microsoft-Defender\Remove-Scan-With-Microsoft-Defender-Context-Menu.reg" 2>$null
                reg import "$PSScriptRoot\Configs\Regedits\Context-Menu\Send-To\Remove-Send-To-Context-Menu-For-All-Users.reg" 2>$null
                reg import "$PSScriptRoot\Configs\Regedits\Context-Menu\Share\Remove-Share-From-Context-Menu.reg" 2>$null
                reg import "$PSScriptRoot\Configs\Regedits\Context-Menu\Troubleshoot-Compatibility\Remove-Troubleshoot-Compatibility-Context-Menu.reg" 2>$null
                $newBlankFileReg = Get-Content "$PSScriptRoot\Configs\Regedits\Context-Menu\New-Blank-File\New-Blank-File.reg"
                $newBlankFileReg = $newBlankFileReg -replace "icon-path-here", ("$env:USERPROFILE\Pictures\System\File.ico" -replace "\\", "\\")
                $newBlankFileReg | Set-Content ".\tempNewBlankFile.reg"
                reg import ".\tempNewBlankFile.reg" 2>$null
                Remove-Item ".\tempNewBlankFile.reg"
                Stop-Process -Name "explorer"
                if (-not (Get-Process "explorer" -ErrorAction SilentlyContinue)) {
                    Start-Process "explorer"
                }
            }

            function Remove-ThisPCFolders {
                Write-Host "Removing This PC folders..."
                reg import "$PSScriptRoot\Configs\Regedits\Remove-Folders-from-This-PC\Remove-All-User-Folders-From-This-PC.reg" 2>$null
            }

            Disable-WindowsFeatures
            Disable-ScheduledTasks
            Disable-Services
            Disable-StickyKeys
            Optimize-ContextMenu
            Remove-ThisPCFolders

            if (Test-Path "$env:SYSTEMDRIVE\Users\defaultuser0") { 
                Remove-Item "$env:SYSTEMDRIVE\Users\defaultuser0" -Recurse -Force
            }

            gsudo "$PSScriptRoot\Scripts\Sophia-Script-Uninstall-Bloat.ps1"
        }

        function Invoke-PostSetup {
            foreach ($entry in $script:selected) {
                switch ($entry) {
                    "Steam" {
                        foreach ($steamappsFolder in (es -i /ad "steamapps")) { 
                            if ($steamappsFolder -match "SteamLibrary") {
                                New-Item -ItemType SymbolicLink "$env:USERPROFILE\Games\Steam Libraries\$($steamappsFolder.Substring(0,1))" -Target "$steamappsFolder\common" -Force | Out-Null
                            }
                        }
                    }
                    "Wallpaper Engine" {
                        Write-Host "Waiting for Steam to finish downloading..."
                        $downloading = $false
                        $zeroCount = 0
                        while ($downloading) {
                        $state = Get-Counter -Counter "\Process(steam)\IO Write Bytes/sec"
                        if ($state.CounterSamples.CookedValue -eq 0.00) {
                            $zeroCount++
                            if ($zeroCount -ge 5) {
                                $downloading = $false
                                break
                            }
                        } else {
                            $zeroCount = 0
                        }
                        Start-Sleep -Seconds 0.5
                        }
                        $slideClockWallpaperDir = es -i -n 1 /ad "steamapps\workshop\content\431960\1854057384"
                        if (Test-Path $slideClockWallpaperDir -ErrorAction SilentlyContinue) {
                            $style = Get-Content "$slideClockWallpaperDir\style.css"
                            $style = $style -replace '@import url\("https:\/\/fonts\.googleapis\.com\/css\?family=Roboto\+Condensed:300"\);', ''
                            $style = $style -replace 'font-family: "Roboto Condensed", sans-serif;', 'font-family: "CyberpunkWaifus", sans-serif;'
                            $style = $style -replace 'content: "\:";', 'content: "⠀";'
                            $style = $style -replace 'overflow: hidden;', "overflow:hidden;`n`ttransform: translateY(-58%);"
                            $style | Set-Content "$slideClockWallpaperDir\style.css"
                        } else {
                            Write-Host "Wallpaper Engine: Couldn't modify Slide Clock wallpaper, probably hasn't downloaded yet."
                        }
                        $wallpaperengine = es -i -n 1 -r "\.exe$" "wallpaper64.exe"
                        if ($wallpaperengine) {
                            $slideClockWallpaper = "$slideClockWallpaperDir\project.json"
                            if (Test-Path $slideClockWallpaper) {
                                Start-Process $wallpaperengine -Args "-control openWallpaper -file `"$slideClockWallpaper`" -monitor 1"
                            }
                            $terrariaWallpaper = es -i -n 1 /a-d "steamapps\workshop\content\431960\2100929026\project.json"
                            if (Test-Path $terrariaWallpaper -ErrorAction SilentlyContinue) {
                                Start-Process $wallpaperengine -Args "-control openWallpaper -file `"$terrariaWallpaper`" -monitor 0"
                                Start-Process $wallpaperengine -Args "-control applyProperties -properties RAW~({`"wec_brs`":20})~END -monitor 0"
                                Start-Process $wallpaperengine -Args "-control applyProperties -properties RAW~({`"wec_con`":5)~END -monitor 0"
                                Start-Process $wallpaperengine -Args "-control applyProperties -properties RAW~({`"wec_e`":true})~END -monitor 0"
                                Start-Process $wallpaperengine -Args "-control applyProperties -properties RAW~({`"wec_hue`":50})~END -monitor 0"
                                Start-Process $wallpaperengine -Args "-control applyProperties -properties RAW~({`"wec_sa`":10})~END -monitor 0"
                            } else {
                                Write-Host "Wallpaper Engine: Couldn't modify Terraria wallpaper."
                            }
                            Start-Process $wallpaperengine -Args "-control hideIcons"
                            Start-Process $wallpaperengine -Args "-control mute"
                        } else {
                            Write-Host "Wallpaper Engine: Couldn't find Wallpaper Engine executable."
                        }                        
                    }
                }
            }
        }
        
        function New-PsExes {
            function New-PsExe {
                param (
                    [string]$inputFile
                )

                $outputPath = "$env:USERPROFILE\Code\Scripts\ps2exe"
                $outputFile = "$outputPath\$([System.IO.Path]::GetFileNameWithoutExtension($inputFile)).exe"
                Invoke-ps2exe -inputFile $inputFile -outputFile $outputFile -iconFile "$PSScriptRoot\Icons\PowerShell.ico" -noConsole -noError -noOutput
            }

            Write-Host "Compiling scripts with ps2exe..."

            foreach ($entry in $script:selected) {
                switch ($entry) {
                    "BetterDiscord" {
                        New-PsExe "$PSScriptRoot\Scripts\Startup\BetterDiscord-AutoInstaller.ps1"
                    }
                    "Chatterino2" {
                        New-PsExe "$PSScriptRoot\Scripts\Startup\Chatterino.ps1"
                    }
                    "Discord OpenAsar" {
                        New-PsExe "$PSScriptRoot\Scripts\Install-Discord-OpenAsar.ps1"
                    }
                    "Firefox" {
                        New-PsExe "$PSScriptRoot\Scripts\Startup\STG-Backup-Mover.ps1"
                    }
                    "G.Skill Trident Z Lighting Control" {
                        New-PsExe "$PSScriptRoot\Scripts\Startup\Close-GSkill-RGB.ps1"
                    }
                    "Gpg4win" {
                        New-PsExe "$PSScriptRoot\Scripts\Startup\GPG-Agent.ps1"
                        New-PsExe "$PSScriptRoot\Scripts\Startup\Keybox-Daemon.ps1"
                    }
                    "Rainmeter" {
                        New-PsExe "$PSScriptRoot\Scripts\Startup\Refresh-Rainmeter-On-Audio-Device-Change.ps1"
                    }
                    "Spicetify" {
                        New-PsExe "$PSScriptRoot\Scripts\Initialize-Spicetify.ps1"
                    }
                    "Spotify" {
                        New-PsExe "$PSScriptRoot\Scripts\Startup\Minimize-Spotify.ps1"
                    }
                    "SoulseekQt" {
                        New-PsExe "$PSScriptRoot\Scripts\Startup\SoulseekQt.ps1"
                    }
                    "Sekiro" {
                        New-PsExe "$PSScriptRoot\Scripts\Close-SekiroFpsUnlockAndMore.ps1"
                    }
                    "Steam" {
                        New-PsExe "$PSScriptRoot\Scripts\Startup\Steam.ps1"
                    }
                    "Syncthing" {
                        New-PsExe "$PSScriptRoot\Scripts\Startup\Syncthing.ps1"
                    }
                }
            }

            New-PsExe "$PSScriptRoot\Scripts\Download.ps1"
            New-PsExe "$PSScriptRoot\Scripts\Dump-Event-Logs.ps1"
            New-PsExe "$PSScriptRoot\Scripts\Open-Volume-Mixer.ps1"
            New-PsExe "$PSScriptRoot\Scripts\ps2exe-exe2ps.ps1"
            New-PsExe "$PSScriptRoot\Scripts\Refresh-Rainmeter.ps1"
            New-PsExe "$PSScriptRoot\Scripts\Startup\Delete-Persistent-Files-and-Folders.ps1"
            New-PsExe "$PSScriptRoot\Scripts\Startup\Explorer.ps1"
            New-PsExe "$PSScriptRoot\Scripts\Startup\Sync-Time.ps1"
            New-PsExe "$PSScriptRoot\Scripts\Switch-Sound-Output.ps1"
            New-PsExe "$PSScriptRoot\Scripts\Toggle-Steam-Block.ps1"
        }

        function New-ScheduledTasks {
            function New-Task {
                param (
                    [string]$taskName,
                    [Microsoft.Management.Infrastructure.CimInstance]$action,
                    [Microsoft.Management.Infrastructure.CimInstance]$trigger = (New-ScheduledTaskTrigger -AtLogOn -User ([System.Security.Principal.WindowsIdentity]::GetCurrent().Name)),
                    [Microsoft.Management.Infrastructure.CimInstance]$principal = (New-ScheduledTaskPrincipal -UserId $([System.Security.Principal.WindowsIdentity]::GetCurrent().Name) -LogonType Interactive -RunLevel Limited),
                    [Microsoft.Management.Infrastructure.CimInstance]$settings = (New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable),
                    [string]$taskPath = "\Custom"
                )
            
                if (Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue) {
                    Unregister-ScheduledTask -TaskName $taskName -Confirm:$false
                }
                Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -Principal $principal -Settings $settings -TaskPath $taskPath
            }

            function New-EventTrigger {
                param (
                    [string]$query
                )
            
                $CIMTriggerClass = Get-CimClass -ClassName "MSFT_TaskEventTrigger" -Namespace "root/Microsoft/Windows/TaskScheduler:MSFT_TaskEventTrigger"
                
                $trigger = New-CimInstance -CimClass $CIMTriggerClass -ClientOnly
                $trigger.Subscription = $query
                $trigger.Enabled = $True
            
                return $trigger
            }
            
            Write-Host "Creating scheduled tasks..."

            foreach ($entry in $script:selected) {
                switch ($entry) {
                    "BetterDiscord" {
                        $taskName = "BetterDiscord AutoInstaller"
                        $action = New-ScheduledTaskAction -Execute "$env:USERPROFILE\Code\Scripts\ps2exe\BetterDiscord-AutoInstaller.exe"
                        New-Task -taskName $taskName -action $action
                    }
                    "Chatterino2" {
                        $taskName = "Chatterino"
                        $action = New-ScheduledTaskAction -Execute "$env:USERPROFILE\Code\Scripts\ps2exe\Chatterino.exe"
                        New-Task -taskName $taskName -action $action
                    }
                    "Discord OpenAsar" {
                        $taskName = "Discord OpenAsar"
                        $action = New-ScheduledTaskAction -Execute "$env:USERPROFILE\Code\Scripts\ps2exe\Install-Discord-OpenAsar.exe"
                        $trigger = New-ScheduledTaskTrigger -Weekly -DaysOfWeek Friday -At 4:20pm
                        New-Task -taskName $taskName -action $action -trigger $trigger
                    }
                    "Firefox" {
                        $taskName = "STG Backup Mover"
                        $action = New-ScheduledTaskAction -Execute "$env:USERPROFILE\Code\Scripts\ps2exe\STG-Backup-Mover.exe"
                        New-Task -taskName $taskName -action $action
                    }
                    "G.Skill Trident Z Lighting Control" {
                        $taskName = "Close GSkill RGB"
                        $action = New-ScheduledTaskAction -Execute "$env:USERPROFILE\Code\Scripts\ps2exe\Close-GSkill-RGB.exe"
                        New-Task -taskName $taskName -action $action
                    }
                    "Gpg4win" {
                        $taskName = "GPG Agent"
                        $action = New-ScheduledTaskAction -Execute "$env:USERPROFILE\Code\Scripts\ps2exe\GPG-Agent.exe"
                        New-Task -taskName $taskName -action $action

                        $taskName = "Keybox Daemon"
                        $action = New-ScheduledTaskAction -Execute "$env:USERPROFILE\Code\Scripts\ps2exe\Keybox-Daemon.exe"
                        New-Task -taskName $taskName -action $action
                    }
                    "Rainmeter" {
                        $taskName = "Refresh Rainmeter On Audio Device Change"
                        $action = New-ScheduledTaskAction -Execute "$env:USERPROFILE\Code\Scripts\ps2exe\Refresh-Rainmeter-On-Audio-Device-Change.exe"
                        New-Task -taskName $taskName -action $action
                    }
                    "Sekiro" {
                        $sekiro = es -i -n 1 -r "\.exe$" "sekiro.exe"
                        if ($sekiro) {
                            $sekiroUnlocker = $sekiro -replace "sekiro\.exe$", "SekiroFpsUnlockAndMore.exe"

                            $taskName = "SekiroFpsUnlockAndMore Autoclose"
                            $action = New-ScheduledTaskAction -Execute "$env:USERPROFILE\Code\Scripts\ps2exe\Close-SekiroFpsUnlockAndMore.exe"
                            $query = "<QueryList><Query Id='0' Path='Security'><Select Path='Security'>*[System[Provider[@Name='Microsoft-Windows-Security-Auditing'] and (band(Keywords,9007199254740992)) and (EventID=4689)]] and *[EventData[(Data='$sekiro')]]</Select></Query></QueryList>"
                            $trigger = New-EventTrigger -query $query
                            New-Task -taskName $taskName -action $action -trigger $trigger

                            $taskName = "SekiroFpsUnlockAndMore Autostart"
                            $action = New-ScheduledTaskAction -Execute "$sekiroUnlocker"
                            $query = "<QueryList><Query Id='0' Path='Security'><Select Path='Security'>*[System[Provider[@Name='Microsoft-Windows-Security-Auditing'] and Task = 13312 and (band(Keywords,9007199254740992)) and (EventID=4688)]] and *[EventData[Data[@Name='NewProcessName'] and (Data='$sekiro')]]</Select></Query></QueryList>"
                            $trigger = New-EventTrigger -query $query
                            New-Task -taskName $taskName -action $action -trigger $trigger
                        }
                    }
                    "Spotify" {
                        $taskName = "Minimize Spotify"
                        $action = New-ScheduledTaskAction -Execute "$env:USERPROFILE\Code\Scripts\ps2exe\Minimize-Spotify.exe"
                        New-Task -taskName $taskName -action $action
                    }
                    "Spicetify" {
                        $taskName = "Initialize Spicetify"
                        $action = New-ScheduledTaskAction -Execute "$env:USERPROFILE\Code\Scripts\ps2exe\Initialize-Spicetify.exe"
                        New-Task -taskName $taskName -action $action
                    }
                    "SoulseekQt" {
                        $taskName = "SoulseekQt"
                        $action = New-ScheduledTaskAction -Execute "$env:USERPROFILE\Code\Scripts\ps2exe\SoulseekQt.exe"
                        New-Task -taskName $taskName -action $action
                    }
                    "Steam" {
                        $taskName = "Steam"
                        $action = New-ScheduledTaskAction -Execute "$env:USERPROFILE\Code\Scripts\ps2exe\Steam.exe"
                        New-Task -taskName $taskName -action $action
                    }
                    "Syncthing" {
                        $taskName = "Syncthing"
                        $action = New-ScheduledTaskAction -Execute "$env:USERPROFILE\Code\Scripts\ps2exe\Syncthing.exe"
                        New-Task -taskName $taskName -action $action
                    }
                }
            }

            $taskName = "Explorer"
            $action = New-ScheduledTaskAction -Execute "$env:USERPROFILE\Code\Scripts\ps2exe\Explorer.exe"
            New-Task -taskName $taskName -action $action

            $taskName = "Delete Persistent Files & Folders"
            $action = New-ScheduledTaskAction -Execute "$env:USERPROFILE\Code\Scripts\ps2exe\Delete-Persistent-Files-and-Folders.exe"
            New-Task -taskName $taskName -action $action

            $taskName = "Sync Time"
            $action = New-ScheduledTaskAction -Execute "$env:USERPROFILE\Code\Scripts\ps2exe\Sync-Time.exe"
            New-Task -taskName $taskName -action $action
        }

        function New-TaskbarEntries {
            Write-Host "Creating taskbar entries..."
        
            $tempDir = Join-Path ([System.IO.Path]::GetTempPath()) -ChildPath "Taskbar Shortcuts"
            New-Item -ItemType Directory -Path $tempDir -Force | Out-Null
        
            foreach ($entry in $script:selected) {
                switch ($entry) {
                    "Chatterino2" {
                        script:New-Shortcut -linkPath "$tempDir\Chatterino.lnk" -targetPath (script:Get-ShortcutPath "chatterino.exe" -scoopName "chatterino")
                    }
                    "Cheat Engine" {
                        script:New-Shortcut -linkPath "$tempDir\Cheat Engine.lnk" -targetPath (script:Get-ShortcutPath "Cheat Engine.exe" -scoopName "cheat-engine")
                    }
                    "Discord" {
                        script:New-Shortcut -linkPath "$tempDir\Discord.lnk" -targetPath (script:Get-ShortcutPath "Discord.exe" -scoopName "discord")
                    }
                    "Everything" {
                        script:New-Shortcut -linkPath "$tempDir\Everything.lnk" -targetPath (script:Get-ShortcutPath "Everything.exe" -scoopName "everything")
                    }
                    "Firefox" {
                        script:New-Shortcut -linkPath "$tempDir\Firefox.lnk" -targetPath (script:Get-ShortcutPath "firefox.exe" -scoopName "firefox")
                    }
                    "FreeTube" {
                        script:New-Shortcut -linkPath "$tempDir\FreeTube.lnk" -targetPath (script:Get-ShortcutPath "FreeTube.exe" -scoopName "freetube") -iconLocation "$env:USERPROFILE\Pictures\System\YouTube.ico"
                    }
                    "FreeTube (Custom)" {
                        script:New-Shortcut -linkPath "$tempDir\FreeTube.lnk" -targetPath (script:Get-ShortcutPath "FreeTube.exe" -scoopName "freetube") -iconLocation "$env:USERPROFILE\Pictures\System\YouTube.ico"
                    }
                    "Godot" {
                        script:New-Shortcut -linkPath "$tempDir\Godot.lnk" -targetPath (script:Get-ShortcutPath "godot*.exe" -scoopName "godot")
                    }
                    "Godot (Mono)" {
                        script:New-Shortcut -linkPath "$tempDir\Godot.lnk" -targetPath (script:Get-ShortcutPath "godot*.exe" -scoopName "godot-mono")
                    }
                    "KeePassXC" {
                        script:New-Shortcut -linkPath "$tempDir\KeePassXC.lnk" -targetPath (script:Get-ShortcutPath "KeePassXC.exe" -scoopName "keepassxc")
                    }
                    "Mp3tag" {
                        script:New-Shortcut -linkPath "$tempDir\Mp3Tag.lnk" -targetPath (script:Get-ShortcutPath "Mp3tag.exe" -scoopName "mp3tag")
                    }
                    "Nicotine+" {
                        script:New-Shortcut -linkPath "$tempDir\Nicotine+.lnk" -targetPath (script:Get-ShortcutPath "Nicotine+.exe" -scoopName "nicotine-plus")
                    }
                    "Notepad++" {
                        script:New-Shortcut -linkPath "$tempDir\Notepad++.lnk" -targetPath (script:Get-ShortcutPath "notepad++.exe" -scoopName "notepadplusplus")
                    }
                    "OBS Studio" {
                        script:New-Shortcut -linkPath "$tempDir\OBS Studio.lnk" -targetPath (script:Get-ShortcutPath "obs64.exe" -scoopName "obs-studio") -arguments "--startreplaybuffer --startvirtualcam --multi"
                    }
                    "Obsidian" {
                        script:New-Shortcut -linkPath "$tempDir\Obsidian.lnk" -targetPath (script:Get-ShortcutPath "Obsidian.exe" -scoopName "obsidian")
                    }
                    "Photoshop" {
                        script:New-Shortcut -linkPath "$tempDir\Photoshop.lnk" -targetPath (script:Get-ShortcutPath "Photoshop.exe")
                    }
                    "PowerToys" {
                        script:New-Shortcut -linkPath "$tempDir\PowerToys.lnk" -targetPath (script:Get-ShortcutPath "PowerToys.Settings.exe" -scoopName "powertoys")
                    }
                    "Premiere Pro" {
                        script:New-Shortcut -linkPath "$tempDir\Premiere Pro.lnk" -targetPath (script:Get-ShortcutPath "Adobe Premiere Pro.exe")
                    }
                    "qBittorrent" {
                        script:New-Shortcut -linkPath "$tempDir\qBittorrent.lnk" -targetPath (script:Get-ShortcutPath "qbittorrent.exe" -scoopName "qbittorrent")
                    }
                    "qBittorrent Enhanced" {
                        script:New-Shortcut -linkPath "$tempDir\qBittorrent Enhanced.lnk" -targetPath (script:Get-ShortcutPath "qbittorrent.exe" -scoopName "qbittorrent")
                    }
                    "SoulseekQt" {
                        script:New-Shortcut -linkPath "$tempDir\SoulseekQt.lnk" -targetPath (script:Get-ShortcutPath "SoulseekQt.exe" -scoopName "soulseek")
                    }
                    "Spotify" {
                        script:New-Shortcut -linkPath "$tempDir\Spotify.lnk" -targetPath (script:Get-ShortcutPath "Spotify.exe" -scoopName "spotify")
                    }
                    "Steam" {
                        script:New-Shortcut -linkPath "$tempDir\Steam.lnk" -targetPath (script:Get-ShortcutPath "steam.exe" -scoopName "steam") -arguments "-console -nochatui -nofriendsui -forcedesktopscaling 0.69"
                    }
                    "Visual Studio Code" {
                        script:New-Shortcut -linkPath "$tempDir\VSCode.lnk" -targetPath (script:Get-ShortcutPath "Microsoft VS Code\Code.exe" -scoopName "vscode")
                    }
                    "Windows Terminal" {
                        script:Log 'Taskbar: Manually pin Windows Terminal and set shortcut key to "Ctrl+Alt+T" (if not using AHK).'
                    }
                }
            }
        
            script:Log "Taskbar: Manually pin Explorer and set icon to '$env:USERPROFILE\Pictures\System\Grey-Explorer.ico'"
            script:Log "Taskbar: Open calculator and pin from taskbar instead of drag and drop."
            script:New-Shortcut -linkPath "$tempDir\Download.lnk" -targetPath "$env:USERPROFILE\Code\Scripts\ps2exe\Download.exe" -iconLocation "%SystemRoot%\System32\SHELL32.dll,178"
            script:New-Shortcut -linkPath "$tempDir\Calculator.lnk" -targetPath "$env:WINDIR\System32\calc.exe"
            Start-Process $tempDir
        }

        function Remove-DesktopShortcuts {
            Write-Host "Removing desktop shortcuts..."
            $desktopShortcuts = @(Get-ChildItem "$env:USERPROFILE\Desktop" -Include "*.lnk", "*.url" -Recurse)
            $desktopShortcuts += Get-ChildItem "$env:PUBLIC\Desktop" -Include "*.lnk", "*.url" -Recurse
            
            foreach ($shortcut in $desktopShortcuts) {
                Remove-Item $shortcut.FullName
            }            
        }

        function Set-PreferredAssociations {
            Write-Host "Setting file associations..."
            function Set-Association {
                # from: https://stackoverflow.com/a/59048942/22410757
                # not currently using this, but keeping it here for if I ever need it
                param(
                    [string]$ext,
                    [string]$exe
                )

                $name = cmd /c "assoc $ext 2>NUL"
                if ($name) {
                    $name = $name.Split("=")[1]
                } else {
                    $name = "$($ext.Replace('.',''))file" # ".log.1" becomes "log1file"
                    cmd /c "assoc $ext=$name"
                }
                cmd /c "ftype $name=`"$exe`" `"%1`""
            }

            foreach ($entry in $script:selected) {
                switch ($entry) {
                    "Notepad++" {
                        cmd /c "assoc .bash_history=Notepad++_file"
                        cmd /c "assoc .cfg=Notepad++_file"
                        cmd /c "assoc .gitconfig=Notepad++_file"
                        cmd /c "assoc .gtk-bookmarks=Notepad++_file"
                        cmd /c "assoc .ini=Notepad++_file"
                        cmd /c "assoc .lesshst=Notepad++_file"
                        cmd /c "assoc .minttyrc=Notepad++_file"
                        cmd /c "assoc .node_repl_history=Notepad++_file"
                        cmd /c "assoc .txt=Notepad++_file"
                        cmd /c "assoc .viminfo=Notepad++_file"
                        cmd /c "assoc .yarnrc=Notepad++_file"
                    }
                    "Rainmeter" {
                        cmd /c "assoc .rmskin=skininstaller.exe"
                        cmd /c "ftype Rainmeter.SkinInstaller='$((es -i -n 1 -r "\.exe$" "SkinInstaller.exe") -replace "rainmeter\\[\d.]+", "rainmeter\current")' %1"
                    }
                }
            }

            cmd /c "assoc .=blank"
            cmd /c "assoc .ps1=Microsoft.PowerShellScript.1"
            cmd /c "ftype Microsoft.PowerShellScript.1=`"$env:WINDIR\System32\WindowsPowerShell\v1.0\powershell.exe`" -ExecutionPolicy Bypass -File `"%1`""
        }
        
        Edit-Icons
        Add-QuickAccessPins
        Confirm-SysinternalsEula
        Copy-Scripts
        Hide-DesktopIcons
        Hide-FoldersAndFiles
        Invoke-Debloat
        New-PsExes
        New-ScheduledTasks
        New-TaskbarEntries
        Remove-DesktopShortcuts
        Set-PreferredAssociations
        Invoke-PostSetup
    }
}
#endregion

Show-WinForm | Out-Null
