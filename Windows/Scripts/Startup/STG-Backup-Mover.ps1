param (
    [string]$SaveDir = "$env:USERPROFILE\Documents\Backups\STG",
    [int]$FrequencyMs = 10000
)

$host.UI.RawUI.WindowTitle = "STG Backup Mover"

New-Item $saveDir -ItemType Directory -Force | Out-Null

$path = "$env:USERPROFILE\Downloads"

try {
    Write-Host "FileSystemWatcher is monitoring $path" -ForegroundColor Green

    $watcher = New-Object -TypeName IO.FileSystemWatcher -Args $path, '*' -Property @{
        IncludeSubdirectories = $true
        NotifyFilter = [IO.NotifyFilters]::FileName, [IO.NotifyFilters]::LastWrite
    }

    while ($true) {
        $result = $watcher.WaitForChanged([System.IO.WatcherChangeTypes]::All, $frequencyMs)
        if ($result.TimedOut) { continue }
        $result | Out-String | Write-Host -ForegroundColor DarkYellow
        Start-Sleep -Seconds 2
        Copy-Item "$path\STG-backups-FF-*" -Destination $saveDir -Recurse -Force
        Remove-Item "$path\STG-backups-FF-*" -Recurse -Force
    }
} finally {
    $watcher.Dispose()
}
