$latestRelease = Invoke-RestMethod -Uri "https://api.github.com/repos/farag2/Sophia-Script-for-Windows/releases/latest"

if ($PSVersionTable.PSVersion.Major -ge 7 -and $PSVersionTable.PSVersion.Minor -ge 3) { 
    $asset = $latestRelease.assets | Where-Object { $_.name -like "Sophia.Script.for.Windows.10.PowerShell.7*.zip" }
} else {
    $asset = $latestRelease.assets | Where-Object { $_.name -like "Sophia.Script.for.Windows.10.v*.zip" }
}

if ($null -ne $asset) {
    Invoke-WebRequest $asset.browser_download_url -OutFile ".\SophiaScript.zip"
} else {
    Write-Warning "Could not download Sophia Script."
    return
}

Expand-Archive ".\SophiaScript.zip" -DestinationPath ".\Sophia"
Remove-Item ".\SophiaScript.zip"

Get-ChildItem ".\Sophia" -Filter "*.psm1" -Recurse | ForEach-Object {
    $module = Get-Content $_.FullName
    $module = $module -replace "\[Windows\.UI\.Notifications\.ToastNotificationManager\]::CreateToastNotifier", "# [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier"
    $module | Set-Content $_.FullName
}

if ($PSVersionTable.PSVersion.Major -ge 7 -and $PSVersionTable.PSVersion.Minor -ge 3) { 
    Move-Item ".\Sophia\Sophia_Script_for_Windows_10_PowerShell_7_v*\*" -Destination ".\Sophia"
    Remove-Item ".\Sophia\Sophia_Script_for_Windows_10_PowerShell_7_v*"
} else {
    Move-Item ".\Sophia\Sophia_Script_for_Windows_10_v*\*" -Destination ".\Sophia"
    Remove-Item ".\Sophia\Sophia_Script_for_Windows_10_v*"
}

. ".\Sophia\Functions.ps1"

Sophia -Functions "UninstallUWPApps"
Sophia -Functions "WindowsCapabilities -Uninstall"
Sophia -Functions "WindowsFeatures -Disable"

Remove-Item ".\Sophia" -Recurse -Force
