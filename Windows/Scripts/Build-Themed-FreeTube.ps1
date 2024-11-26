param (
    [string]$path = "$env:USERPROFILE\Code"
)

New-Item -ItemType Directory $path -Force | Out-Null

if (Test-Path "$path\FreeTube") {
    Set-Location "$path\FreeTube"
    git pull
} else {
    git clone "https://github.com/FreeTubeApp/FreeTube.git" $path\FreeTube
    Set-Location "$path\FreeTube"
}

git checkout master

$buildCommand = $null

if (Get-Command bun -ErrorAction SilentlyContinue) {
    bun ci
    $buildCommand = "bun run build"
} elseif (Get-Command yarn -ErrorAction SilentlyContinue) {
    yarn install
    $buildCommand = "yarn build"
} elseif (Get-Command npm -ErrorAction SilentlyContinue) {
    npm install
    $buildCommand = "npm run build"
} else {
    Write-Warning "This script requires either bun, yarn, or npm to be installed. Please install one and try again."
    Exit 1
}

Set-Location ".\src"

$themePath = ".\renderer\themes.css"
$themeContent = Get-Content $themePath -Raw
$themeContent = $themeContent -replace '(?<=\.catppuccinMocha\s*{[^}]*?--bg-color:\s*)#[0-9a-fA-F]+', '#c8c8c8'
$themeContent = $themeContent -replace '(?<=\.catppuccinMocha\s*{[^}]*?--secondary-card-bg-color:\s*)#[0-9a-fA-F]+', '#c8c8c8'
$themeContent = $themeContent -replace '(?<=\.mainCatppuccinMochaRosewater\s*\{[^}]*--primary-color:\s*)#[0-9a-fA-F]{6}(?=;)', '#212121'
$themeContent = $themeContent -replace 'text-with-main-color: #1e1e2e;', 'text-with-main-color: #c8c8c8;'
$themeContent = $themeContent -replace 'accent-color: #f5e0dc;', 'accent-color: #c8c8c8;'
Set-Content $themePath -Value $themeContent

$iconButtonPath = ".\renderer\components\ft-icon-button\ft-icon-button.scss"
$iconButtonContent = Get-Content $iconButtonPath -Raw
$iconButtonContent = $iconButtonContent -replace 'background-color: var\(--side-nav-color\);', 'background-color: var(--primary-color);'
Set-Content $iconButtonPath -Value $iconButtonContent

$subscribeButtonPath = ".\renderer\components\ft-subscribe-button\ft-subscribe-button.scss"
$subscribeButtonContent = Get-Content $subscribeButtonPath -Raw
$subscribeButtonContent = $subscribeButtonContent -replace 'background-color: var\(--side-nav-color\);', 'background-color: var(--primary-color);'
$subscribeButtonContent = $subscribeButtonContent -replace 'border-inline-end: 2px solid var\(--primary-color-active\) !important;\r\n', ''
Set-Content $subscribeButtonPath -Value $subscribeButtonContent

$sideNavPath = ".\renderer\components\side-nav\side-nav.css"
$sideNavContent = Get-Content $sideNavPath -Raw
$sideNavContent = $sideNavContent -replace 'background-color: var\(--side-nav-color\);', 'background-color: var(--primary-color);'
$sideNavContent = $sideNavContent -replace 'box-shadow: 1px -1px 1px -1px var\(--primary-shadow-color\);\r\n', ''
$sideNavContent = $sideNavContent -replace 'color: inherit;', 'color: #c8c8c8;'
$sideNavContent = $sideNavContent -replace 'color: var\(--text-with-main-color\);', 'color: #c8c8c8;'
Set-Content $sideNavPath -Value $sideNavContent

$sideNavMoreOptionsPath = ".\renderer\components\side-nav-more-options\side-nav-more-options.css"
$sideNavMoreOptionsContent = Get-Content $sideNavMoreOptionsPath -Raw
$sideNavMoreOptionsContent = $sideNavMoreOptionsContent -replace 'background-color: var\(--side-nav-color\);', 'background-color: var(--primary-color);'
Set-Content $sideNavMoreOptionsPath -Value $sideNavMoreOptionsContent

$topNavPath = ".\renderer\components\top-nav\top-nav.scss"
$topNavContent = Get-Content $topNavPath -Raw
$topNavContent = $topNavContent -replace 'box-shadow: 0 2px 1px 0 var\(--primary-shadow-color\);\r\n', ''
$topNavContent = $topNavContent -replace 'color: var\(--primary-text-color\);', 'color: #c8c8c8;'
$topNavContent = $topNavContent -replace 'background-color: var\(--card-bg-color\);', 'background-color: var(--primary-color);'
Set-Content $topNavPath -Value $topNavContent

$floatingRefreshPath = ".\renderer\components\ft-refresh-widget\ft-refresh-widget.scss"
$floatingRefreshContent = Get-Content $floatingRefreshPath -Raw
$floatingRefreshContent = $floatingRefreshContent -replace 'box-shadow: 0 2px 1px 0 var\(--primary-shadow-color\);\r\n', ''
$floatingRefreshContent = $floatingRefreshContent -replace 'border-inline-start: 2px solid var\(--primary-shadow-color\);\r\n', ''
Set-Content $floatingRefreshPath -Value $floatingRefreshContent

$progressBarPath = ".\renderer\scss-partials\_ft-list-item.scss"
$progressBarContent = Get-Content $progressBarPath -Raw
$progressBarContent = $progressBarContent -replace 'background-color: var\(--primary-color\);', 'background-color: #c8c8c8;'
Set-Content $progressBarPath -Value $progressBarContent

Set-Location ".."

Invoke-Expression $buildCommand

Remove-Item ".\build\win-unpacked" -Recurse -Force

$latestVersion = Get-ChildItem ".\build" -Filter "FreeTube Setup *.exe" | 
    Sort-Object { [version]($_.Name -replace 'FreeTube Setup |\.exe', '') } -Descending | 
    Select-Object -First 1

if ($latestVersion) {
    Start-Process $latestVersion.FullName -Args "/S"
} else {
    Write-Warning "Could not open installer."
}
