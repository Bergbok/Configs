param (
    [string[]]$devices = @("MyHeadphones", "MySpeakers")
)

$currentPlaybackDevice = Get-AudioDevice -Playback

$nextDevice = $null
$foundCurrentDevice = $false

foreach ($device in $devices) {
    if ($foundCurrentDevice) {
        if (Get-AudioDevice -list | Where-Object Name -like ("$device*")) {
            $nextDevice = $device
            break
        }
    }
    if ($currentPlaybackDevice.Name -like "$device*") {
        $foundCurrentDevice = $true
    }
}

if (-not $foundCurrentDevice -or (-not $nextDevice)) {
    $nextDevice = $devices[0]
}

(Get-AudioDevice -list | Where-Object Name -like ("$nextDevice*") | Set-AudioDevice).Name
