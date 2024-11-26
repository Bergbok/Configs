param (
    [double]$frequency = 3
)

Import-Module -Name AudioDeviceCmdlets

$currentDevice = Get-AudioDevice -Playback

$rainmeter = es -i -n 1 -r "\.exe$" "Rainmeter.exe"

$visualizer = es -i -n 1 -r "\.ini$" "Restona\Visualizer\Visualizer.ini"

$content = Get-Content $visualizer

while ($true) {
    $newDevice = Get-AudioDevice -Playback

    if ($newDevice.ID -ne $currentDevice.ID) {
        $currentDevice = $newDevice

        switch -wildcard ($currentDevice.Name) {
            "SAMSUNG*" {
                Write-Output "Device is Samsung TV"
                $content = $content -replace 'Sensitivity=\d+', 'Sensitivity=69'
            }
            "MyHeadphones*" {
                Write-Output "Device is Headphones"
                $content = $content -replace 'Sensitivity=\d+', 'Sensitivity=64'
            }
            "MySpeakers*" {
                Write-Output "Device is Speakers"
                $content = $content -replace 'Sensitivity=\d+', 'Sensitivity=80'
            }
            default {
                Write-Output "$($currentDevice.Name) with ID: $($currentDevice.ID) is not mapped to a sensitivity value"
            }
        }
        $content | Set-Content $visualizer

        Start-Process $rainmeter -Args "!Refresh" -NoNewWindow -Wait
    }

    Start-Sleep -Seconds $frequency
}
