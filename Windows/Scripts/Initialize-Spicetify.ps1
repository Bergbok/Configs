param(
    [switch]$Full
)

function Initialize-Paths {
    if (Get-Command scoop -ErrorAction SilentlyContinue) {
        if (scoop list | Select-String -Pattern "spotify" -SimpleMatch) {
            $spotify_path = "$env:USERPROFILE\scoop\apps\spotify\current"
            $prefs_paths = Get-ChildItem "$env:APPDATA\Spotify\Users\*\prefs" -ErrorAction SilentlyContinue
            spicetify config spotify_path $spotify_path
            spicetify config prefs_path $prefs_paths[0]
            return
        }
    }
    
    $spotifyDirs = es -i -r "^(?!Minimize-).*\.exe$" "Spotify.exe"
    $roamingDir = $null

    foreach ($dir in $spotifyDirs) {
        $dir = Split-Path $dir
        if ($dir -match "Roaming\\Spotify") {
            $roamingDir = $dir
        }
    }

    if ($roamingDir) {
        spicetify config spotify_path "$roamingDir"
        spicetify config prefs_path "$roamingDir\prefs"
    }
}

Initialize-Paths
spicetify enable-devtools

if (-not $full) {
    spicetify backup apply
    Exit 0
}

spicetify config disable_sentry 1
spicetify config disable_ui_logging 1
spicetify config remove_rtl_rule 1
spicetify config expose_apis 1
spicetify config sidebar_config 1
spicetify config experimental_features 1
spicetify config inject_css 1
spicetify config replace_colors 1
spicetify config check_spicetify_update 1
spicetify config always_enable_devtools 1
Stop-Process -Name "Spotify" -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 3
spicetify spotify-updates block

$spicetifyConfigDir = "$env:APPDATA\spicetify"

function Initialize-CustomApps {
    function Get-LatestReleaseAssetUrl {
        param (
            [string]$repo,
            [string]$pattern
        )
    
        $releasesUrl = "https://api.github.com/repos/$repo/releases"
        $releases = Invoke-RestMethod -Uri $releasesUrl
    
        foreach ($release in $releases) {
            foreach ($asset in $release.assets) {
                if ($asset.name -match $pattern) {
                    return $asset.browser_download_url
                }
            }
        }
        return $null
    }
    
    $libraryUrl = Get-LatestReleaseAssetUrl -repo "harbassan/spicetify-apps" -pattern "spicetify-library\.release\.zip"
    $statsUrl = Get-LatestReleaseAssetUrl -repo "harbassan/spicetify-apps" -pattern "spicetify-stats\.release\.zip"
    
    if ($libraryUrl) {
        Write-Host "Installing 'Library' custom app to $spicetifyConfigDir\CustomApps"
        Invoke-WebRequest $libraryUrl -OutFile ".\library.zip"
        Expand-Archive ".\library.zip"
        Remove-Item ".\library.zip"
        if (Test-Path "$spicetifyConfigDir\CustomApps\library") {
            Remove-Item "$spicetifyConfigDir\CustomApps\library" -Recurse -Force
        }
        Move-Item ".\library" -Destination "$spicetifyConfigDir\CustomApps"
        spicetify config custom_apps library
    } else {
        Write-Warning "Couldn't download spicetify library custom app."
    }
    
    if ($statsUrl) {
        Write-Host "Installing 'Stats' custom app to '$spicetifyConfigDir\CustomApps'"
        Invoke-WebRequest $statsUrl -OutFile ".\stats.zip"
        Expand-Archive ".\stats.zip"
        Remove-Item ".\stats.zip"
        if (Test-Path "$spicetifyConfigDir\CustomApps\stats") {
            Remove-Item "$spicetifyConfigDir\CustomApps\stats" -Recurse -Force
        }
        Move-Item ".\stats" -Destination "$spicetifyConfigDir\CustomApps"
        spicetify config custom_apps stats
    } else {
        Write-Warning "Couldn't download spicetify stats custom app."
    }

    Write-Host "Installing 'Playlist Tags' custom app to '$spicetifyConfigDir\CustomApps'"
    Invoke-WebRequest "https://github.com/Bergbok/Spicetify-Creations/archive/refs/heads/dist/playlist-tags.zip" -OutFile ".\playlist-tags.zip"
    Expand-Archive ".\playlist-tags.zip"
    Remove-Item ".\playlist-tags.zip"
    Copy-Item ".\playlist-tags\Spicetify-Creations-dist-playlist-tags\*" -Destination ".\playlist-tags" -Recurse -Force
    Remove-Item ".\playlist-tags\Spicetify-Creations-dist-playlist-tags" -Recurse -Force
    if (Test-Path "$spicetifyConfigDir\CustomApps\playlist-tags") {
        Remove-Item "$spicetifyConfigDir\CustomApps\playlist-tags" -Recurse -Force
    }
    Move-Item ".\playlist-tags" -Destination "$spicetifyConfigDir\CustomApps"
    spicetify config custom_apps playlist-tags

    Write-Host "Installing 'History in Sidebar' custom app to $spicetifyConfigDir\CustomApps"
    Invoke-WebRequest "https://github.com/Bergbok/Spicetify-Creations/archive/refs/heads/dist/history-in-sidebar.zip" -OutFile ".\history-in-sidebar.zip"
    Expand-Archive ".\history-in-sidebar.zip"
    Remove-Item ".\history-in-sidebar.zip"
    Copy-Item ".\history-in-sidebar\Spicetify-Creations-dist-history-in-sidebar\*" -Destination ".\history-in-sidebar" -Recurse -Force
    Remove-Item ".\history-in-sidebar\Spicetify-Creations-dist-history-in-sidebar" -Recurse -Force
    if (Test-Path "$spicetifyConfigDir\CustomApps\history-in-sidebar") {
        Remove-Item "$spicetifyConfigDir\CustomApps\history-in-sidebar" -Recurse -Force
    }
    Move-Item ".\history-in-sidebar" -Destination "$spicetifyConfigDir\CustomApps"
    spicetify config custom_apps history-in-sidebar

    Write-Host "Installing 'Marketplace' custom app to $spicetifyConfigDir\CustomApps"
    Invoke-WebRequest "https://github.com/spicetify/marketplace/releases/latest/download/marketplace.zip" -OutFile ".\marketplace.zip"
    Expand-Archive ".\marketplace.zip"
    Remove-Item ".\marketplace.zip"
    if (Test-Path "$spicetifyConfigDir\CustomApps\marketplace") {
        Remove-Item "$spicetifyConfigDir\CustomApps\marketplace" -Recurse -Force
    }
    Move-Item ".\marketplace" -Destination "$spicetifyConfigDir\CustomApps"
    spicetify config custom_apps marketplace

    spicetify config custom_apps lyrics-plus
}

function Initialize-Extensions {
    Write-Host "Installing 'Auto Skip Tracks by Duration' extension to $spicetifyConfigDir\Extensions"
    Invoke-WebRequest "https://raw.githubusercontent.com/Bergbok/Spicetify-Creations/refs/heads/dist/auto-skip-tracks-by-duration/auto-skip-tracks-by-duration.js" -OutFile "$spicetifyConfigDir\Extensions\auto-skip-tracks-by-duration.js"
    spicetify config extensions auto-skip-tracks-by-duration.js
}

Initialize-CustomApps
Initialize-Extensions

spicetify backup apply
