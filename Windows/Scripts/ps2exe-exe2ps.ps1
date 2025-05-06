param (
    [string]$path
)

if (-not $path) {
    if ($MyInvocation.MyCommand.CommandType -eq "ExternalScript") {
        $path = Split-Path $MyInvocation.MyCommand.Definition
    } else {
        $path = Split-Path ([Environment]::GetCommandLineArgs()[0])
        if (!$path) {
            $path = "."
        }
    }
}

Get-ChildItem $path -Filter *.exe | ForEach-Object {
    $exeName = $_.BaseName
    Start-Process $_.FullName -Args "-extract:`"$path\$exeName.ps1`"" -NoNewWindow
}
