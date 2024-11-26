param(
    [string]$Url,
    [string]$OutputDirectory = "$env:USERPROFILE\Downloads"
)

Set-Location $PSScriptRoot

while (-not $url) {
    $url = Read-Host "Enter URL"
}

function Get-ytdlp {
    if (Get-Command yt-dlp -ErrorAction SilentlyContinue) { 
        $ytdlp = "yt-dlp"
    } else {
        $ytdlp = es -i -n 1 -r "^(?!.*Python.*\\Scripts\\).*\.exe$" "yt-dlp.exe"
    }
    return $ytdlp
}

switch -regex ($url) {
    "https?:\/\/downloads\.khinsider\.com" {
        $khinsiderpy = es -i -n 1 -r "\.py$" "khinsider.py"

        if (-not $khinsiderpy) {
            Write-Host "khinsider.py not found" -ForegroundColor Red
            break
        }

        New-Item -ItemType Directory "$env:USERPROFILE\Downloads\Audio\Khinsider" -Force | Out-Null
        Set-Location "$env:USERPROFILE\Downloads\Audio\Khinsider"
        Start-Process "python" -Args "-u `"$khinsiderpy`" --format mp3 $url" -NoNewWindow -Wait
        Set-Location $PSScriptRoot
        break
    }
    "https?:\/\/(on\.)?soundcloud\.com" {
        if (Get-Command scdl -ErrorAction SilentlyContinue) { 
            $scdl = "scdl"
        } else {
            $scdl = "python $(es -i -n 1 -r "\.py$" "scdl.py")"
        }
        if ($scdl -eq "python ") {
            Write-Host "scdl.py not found" -ForegroundColor Red
            break
        }
        try {
            $params = "--onlymp3 -l $url --path `"$outputDirectory\Audio\SoundCloud`""
            throw "An error occurred"
            Start-Process $scdl -Args $params -NoNewWindow -Wait
        } catch {
            Write-Host "An error occurred downloading with scdl, falling back to yt-dlp" -ForegroundColor Yellow
            $ytdlp = Get-ytdlp
            $params = "-x -P `"$outputDirectory\Audio\SoundCloud`" --audio-format mp3 --audio-quality 0 $url"
            if ($url -match "\/sets\/") {
                $params = $params + " -o `".\%(playlist)s\%(playlist_index)s %(title)s.%(ext)s`""
            } else {
                $params = $params + " -o `"%(title)s.%(ext)s`""
            }
            Start-Process $ytdlp -Args $params -NoNewWindow -Wait
        }
        break
    }
    "https?:\/\/((www|m)\.)?twitch\.tv" {
        if (Get-Command "twitchemotedownloader" -ErrorAction SilentlyContinue) { 
            $twitchemotedownloader = "twitchemotedownloader"
        } else {
            $twitchemotedownloader = es -i -n 1 -r "\.exe$" "EmoteDownloader.exe"
        }

        if (-not $twitchemotedownloader) {
            Write-Host "Twitch Emote Downloader not found" -ForegroundColor Red
            break
        }

        if (Get-Command "webp2gif" -ErrorAction SilentlyContinue) { 
            $webp2gif = "webp2gif"
        } else {
            $webp2gif = es -i -n 1 -r "\.exe$" "webp2gif.exe"
            if (-not $webp2gif) {
                if ((Read-Host "webp2gif not found, download? (y/n)") -eq "y") {
                    Write-Host "Downloading webp2gif..." -ForegroundColor Yellow
                    Invoke-WebRequest "http://download.rw-designer.com/1.0/webp2gif.exe" -OutFile ".\webp2gif.exe"
                    if ((Get-FileHash ".\webp2gif.exe" -Algorithm SHA256).Hash -eq "8E43925DC80C81CB0471E2D1842D40C7A554E2DE4731773897C1A4B6C3F53A3E")  {
                        $webp2gif = (Get-ChildItem ".\webp2gif.exe").FullName
                    } else {
                        Write-Host "webp2gif download integrity check failed" -ForegroundColor Red
                        Remove-Item ".\webp2gif.exe"
                    }
                }
            }
        }

        $platforms = @(
            "Twitch", 
            "BTTV",
            "FFZ",
            "7TV"
        )

        if (-not $env:TWITCH_EMOTE_DL_CLIENT_ID) {
            $env:TWITCH_EMOTE_DL_CLIENT_ID = Read-Host "TWITCH_EMOTE_DL_CLIENT_ID environment variable is not set.`nhttps://dev.twitch.tv/console/apps`nPlease enter client ID"
            [System.Environment]::SetEnvironmentVariable('TWITCH_EMOTE_DL_CLIENT_ID', $env:TWITCH_EMOTE_DL_CLIENT_ID, [System.EnvironmentVariableTarget]::User)
        }

        if (-not $env:TWITCH_EMOTE_DL_CLIENT_SECRET) {
            $env:TWITCH_EMOTE_DL_CLIENT_SECRET = Read-Host "TWITCH_EMOTE_DL_CLIENT_SECRET environment variable is not set.`nhttps://dev.twitch.tv/console/apps`nPlease enter client secret"
            [System.Environment]::SetEnvironmentVariable('TWITCH_EMOTE_DL_CLIENT_SECRET', $env:TWITCH_EMOTE_DL_CLIENT_SECRET, [System.EnvironmentVariableTarget]::User)
        }

        $channel = $url.Split("/")[-1]
        foreach ($platform in $platforms) {
            $params = "-p $platform --channel_names $channel --client_id $env:TWITCH_EMOTE_DL_CLIENT_ID --client_secret $env:TWITCH_EMOTE_DL_CLIENT_SECRET --output_dir `"$env:USERPROFILE\Pictures\Twitch Emotes`""
            Start-Process $twitchemotedownloader -Args $params -NoNewWindow -Wait
        }
        
        $emotes = Get-ChildItem "$env:USERPROFILE\Pictures\Twitch Emotes\$channel" -Filter *.webp
        foreach ($emote in $emotes) {
            Start-Process $webp2gif -Args "-u `"$($emote.FullName)`"" -NoNewWindow -Wait
            Remove-Item $emote.FullName
        }
        break
    }
    "https?:\/\/((www|m)\.)?youtu(be)?(-nocookie)?\.(com|be)" {
        $ytdlp = Get-ytdlp

        if (-not $ytdlp) {
            Write-Host "yt-dlp not found" -ForegroundColor Red
            break
        }

        $params = "-x -P `"$outputDirectory\Audio\YouTube`" --audio-format mp3 --split-chapters --no-keep-video --audio-quality 0 $url"

        if ($url -match "playlist") {
            $params = $params + " -o `".\%(playlist)s\%(playlist_index)s %(title)s.%(ext)s`""
        }

        Start-Process $ytdlp -Args $params -NoNewWindow -Wait

        $downloadThumbnail = Read-Host "`nDownload thumbnail? (y/n)"
        if ($downloadThumbnail.ToLower() -eq "y") {
            $params = "-P `"$outputDirectory\Audio\YouTube`" --skip-download --write-thumbnail --convert-thumbnail png $url"
            Start-Process $ytdlp -Args $params -NoNewWindow -Wait
        }
        break
    }
    default {
        Write-Host "URL ($url) not supported" -ForegroundColor Red
    }
}

& $PSCommandPath -OutputDirectory $OutputDirectory
