function cmder { cmd /k %CMDER_ROOT%\vendor\init.bat }
function e { exit }
function kys { shutdown /s /t 0 }
function p { powershell-here -ExecutionPolicy Bypass -NoLogo }
function sleepo { psshutdown64.exe -d -t 0 }

Set-Alias -Name c -Value clear

if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
    oh-my-posh init pwsh --config 'theme-path-here' | Invoke-Expression
}

Import-Module DockerCompletion -ErrorAction SilentlyContinue
Import-Module gsudoModule -ErrorAction SilentlyContinue
Import-Module "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1" -ErrorAction SilentlyContinue
