param (
    [string]$Path = $PSScriptRoot,
    [string]$CurrentRomPathRegex = "C:\\\\Users\\\\USERNAME\\\\ROMs\\\\Switch"
)

$jsonFiles = Get-ChildItem -Path $path -Filter '*.json' -Recurse

foreach ($file in $jsonFiles) {
    $fileContent = Get-Content $file.FullName
    $fileContent = $fileContent -replace $currentRomPathRegex, 'roms-path-here'
    $fileContent | Set-Content $file.FullName
}
