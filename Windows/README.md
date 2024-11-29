## Setup.ps1

<!-- <p align="center">
    <img src="https://i.imgur.com/Q1WH8az.png" alt="GUI preview"></img>
</p> -->
<!-- ![GUI Preview](https://i.imgur.com/Q1WH8az.png) -->

### Usage

<details>
<!-- <details open> -->
<summary><strong>Click to expand</strong></summary>

#### Preparation

Use Rufus to create your Windows install medium and use the options to automatically create a user account and skip data collection questions.

Before running, optionally

- Change PC name -> `sysdm.cpl`
- Change main drive letter -> `diskmgmt.msc`

```pwsh
Set-ExecutionPolicy Bypass CurrentUser
Invoke-WebRequest "https://github.com/Bergbok/Configs/archive/refs/heads/main.zip" -OutFile "Configs.zip"
Expand-Archive ".\Configs.zip"
Remove-Item ".\Configs.zip"
Set-Location ".\Configs\Configs-main\Windows"
notepad ".\.env"
& ".\Setup.ps1" -Verbose 4> Verbose.log
```

```pwsh
Get-Content ".\Windows\Setup.log" -Wait
```

#### During downtime

- Import foreign disks & change drive letters if needed -> `diskmgmt.msc`
- Enable clipboard history -> <kbd>Win</kbd>+<kbd>V</kbd> /  `ms-settings:clipboard`
- Ready up display settings so when display driver finishes installing you can immediately rearrange displays & increase Hz -> `dpiscaling`
- Rename Windows drive from Local Disk -> `shell:MyComputerFolder`
- Hide taskbar notification area icons (Input Indicator, Location, Meet Now) -> `ms-settings:taskbar`
- Change lock screen image -> `ms-settings:lockscreen`
- Set user account profile picture -> `ms-settings:yourinfo` ([link](https://i.imgur.com/GVI4MpM.png)) <!-- Invoke-WebRequest https://i.imgur.com/GVI4MpM.png -OutFile ./pfp.png -->
- Disable unneeded audio devices and rename headphones/speakers to MyHeadphones/MySpeakers respectively -> `mmsys.cpl`
> Alternatively, change the default param values in [Switch-Sound-Output.ps1](./Scripts/Switch-Sound-Output.ps1) before the script ends

- [Lumafly] Have Hollow Knight preinstalled to external drive. Pre-open folder incase Lumafly can't find it.

</details>

### What It Does

This script is intended to help get a fresh Windows 10 installation into a usable state.  
Made it for myself, but should be totally usable by other people.  

It's capable of doing the following

<details>
<!-- <details open> -->
<summary><strong>Click to expand</strong></summary>

- Accept the Sysinternals EULA
- Change folder icons
- Change the amount of lines scrolling scrolls
- Change where Explorer starts to This PC from Quick Access
- Change accent color
- Change cursor size
- Change desktop wallpaper
- Clean up context menu
- Create folders/symlinks
- Create shortcuts
- Create task scheduler entries
- Disable mouse acceleration
- Disable the <kbd>Alt</kbd>+<kbd>Shift</kbd> language switching hotkey
- Disable the ability to create/connect to a M$ account
- Enable dark mode
- Hide desktop icons
- Hide specific folders and files
- Hide the drive usage bars in This PC
- Pin things to Quick Access
- Show file extensions in Explorer
- Show things with the Hidden attribute in Explorer
- Show things with the System attribute in Explorer 
- Sync time
- Uninstall Edge

#### Sets up

Uses [Scoop](https://scoop.sh), [Chocolatey](https://chocolatey.org) and [WinGet](https://github.com/microsoft/winget-cli) for most entries.

> Entries suffixed by a lock require you to provide appropriate values in .env  
> If the required values are not provided, expect errors

- [.NET 8.0 Desktop Runtime](https://dotnet.microsoft.com/en-us)
- [After Dark CC Theme](https://cleodesktop.gumroad.com/l/zbiIR) 🔒
    - requires: AFTER_DARK_THEME_GDRIVE_ID
- [Ares](https://ares-emu.net)
- [Audacity](https://www.audacityteam.org)
- [AudioDeviceCmdlets](https://github.com/frgnca/AudioDeviceCmdlets)
- [AutoHotkey](https://www.autohotkey.com)
- [Autologon](https://learn.microsoft.com/en-us/sysinternals/downloads/autologon)
- [AutoRuns](https://learn.microsoft.com/en-us/sysinternals/downloads/autoruns)
- [BCUninstaller](https://www.bcuninstaller.com)
- [BetterDiscord](https://betterdiscord.app)
- [BFG Repo-Cleaner](https://github.com/rtyley/bfg-repo-cleaner)
- [Bun](https://bun.sh)
- [Calibre](https://calibre-ebook.com)
- [CEMU](https://cemu.info) 🔒
    - requires: WII_U_SAVES_GDRIVE_ID
- [Chatterino 2](https://chatterino.com) 🔒
    - requires: IMGUR_CLIENT_ID
- [Cheat Engine](https://github.com/cheat-engine/cheat-engine)
- [Cmder](https://github.com/cmderdev/cmder)
- [Command Prompt Aliases](./Configs/Command-Prompt/aliases.doskey)
- [CPUID HWMonitor](https://www.cpuid.com/softwares/hwmonitor.html)
- [CreamInstaller](https://cs.rin.ru/forum/viewtopic.php?f=29&t=117227)
- [Cyberpunk Waifus Font](https://www.dafont.com/cyberpunkwaifus.font)
    - from [VA-11 Hall-A](https://store.steampowered.com/app/447530)
- [Deno](https://deno.com)
- [Discord OpenAsar](https://openasar.dev)
    - see [Install-Discord-OpenAsar.ps1](./Scripts/Install-Discord-OpenAsar.ps1)
- [Discord](https://discord.com)
- [DisplayFusion](https://www.displayfusion.com)
- [Docker CLI](https://www.docker.com/products/cli)
- [Docker Completion](https://github.com/matt9ucci/DockerCompletion)
- [Docker Compose](https://docs.docker.com/compose)
- [Docker Desktop](https://www.docker.com/products/docker-desktop)
- [Docker Engine](https://docs.docker.com/engine)
- [Dolphin](https://dolphin-emu.org)
- [DS4Windows](https://github.com/schmaldeo/DS4Windows)
- [DuckStation](https://github.com/stenzek/duckstation)
- [Elden Ring Save Manager](https://github.com/Ariescyn/EldenRing-Save-Manager) 🔒  
    - downloads saves from [here](https://github.com/Bergbok/Elden-Ring-Saves)
    - requires: STEAM_ID
- [Epic Games Launcher](https://store.epicgames.com/en-US/download)
- [Everything](https://www.voidtools.com/support/everything)
- [Everything CLI](https://www.voidtools.com/support/everything/command_line_interface)
- [Everything PowerToys](https://github.com/lin-ycv/EverythingPowerToys)
- [ExplorerPatcher](https://github.com/valinet/ExplorerPatcher)
- [f.lux](https://justgetflux.com)
- [Fan Control](https://getfancontrol.com)
- [FFDec](https://github.com/jindrapetrik/jpexs-decompiler)
- [ffmpeg](https://ffmpeg.org)
- [FileTypesMan](https://www.nirsoft.net/utils/file_types_manager.html)
- [Firefox](https://www.mozilla.org/en-US/firefox/new) 🔒
    - sets up [Arkenfox](https://github.com/arkenfox/user.js) with [these overrides](../Cross-Platform/Firefox/user-overrides.js), [Bypass Paywalls Clean](https://github.com/bpc-clone/bypass-paywalls-firefox-clean), and [custom CSS](../Cross-Platform/Firefox/chrome).
    - requires: PHONE_HOSTNAME, PI_HOSTNAME
- [Flameshot](https://flameshot.org) 🔒
    - requires: IMGUR_CLIENT_ID
- [Flash-enabled Chromium](https://gist.github.com/Bergbok/05ab9b6be67f7ca71deae6aeb317efa9)
- [Flashpoint Infinity](https://flashpointarchive.org)
- [FlicFlac](https://github.com/DannyBen/FlicFlac)
- [FreeTube](https://freetubeapp.io) 🔒
    - requires: FREETUBE_DATA_GDRIVE_ID
- [G.Skill Trident Z Lighting Control](https://www.gskill.com/download/1502180912/1551690847/Trident-Z--Trident-Z5--Ripjaws-M5-RGB-Family)
- [gdown](https://github.com/wkentaro/gdown)
- [GifCam](https://blog.bahraniapps.com/gifcam)
- [Gifsicle](https://github.com/kohler/gifsicle)
- [GIMP](https://www.gimp.org)
- [git](https://git-scm.com)
- [git filter-repo](https://github.com/newren/git-filter-repo)
- [GitHub CLI](https://cli.github.com)
- [GitHub Desktop](https://desktop.github.com/download)
- [Go](https://go.dev)
- [Godot](https://godotengine.org/download/windows)
- [Gpg4win](https://www.gpg4win.org)
- [gsudo](https://github.com/gerardog/gsudo)
- [HandBrake](https://handbrake.fr)
- [HeidiSQL](https://www.heidisql.com)
- [HypnOS Cursor](https://www.deviantart.com/nicho7/art/HypnOS-Windows-Cursors-790344855)
- [IconsExtract](https://www.nirsoft.net/utils/iconsext.html)
- [iCUE](https://www.corsair.com/us/en/s/icue)
- [ImageGlass](https://imageglass.org)
- [itch](https://itch.io)
- [iTunes](https://www.apple.com/itunes)
- [JDownloader](https://jdownloader.org)
- [KDE Connect](https://kdeconnect.kde.org)
- [KeePassXC](https://keepassxc.org)
- [khinsider.py](https://github.com/obskyr/khinsider)
- [Legendary](https://github.com/derrod/legendary)
- [LibreHardwareMonitor](https://github.com/LibreHardwareMonitor/LibreHardwareMonitor)
- [LibreOffice](https://www.libreoffice.org)
- [Lime3DS](https://github.com/Lime3DS/lime3ds-archive)
- [Logitech G HUB](https://www.logitechg.com/en-us/innovation/g-hub.html)
- [Lumafly](https://github.com/TheMulhima/Lumafly)
- [Majora's Mask](https://github.com/Mr-Wiseguy/Zelda64Recomp)
- [Media Feature Pack](https://www.microsoft.com/en-us/software-download/mediafeaturepack)
- [MegaBasterd](https://github.com/tonikelope/megabasterd)
- [melonDS](https://github.com/melonDS-emu/melonDS)
- [Meslo Nerd Font](https://www.programmingfonts.org/#meslo)
- [Minecraft Font](https://www.dafont.com/minecraft.font)
- [Minecraft Launcher](https://www.minecraft.net/en-us)
- [Mp3tag](https://www.mp3tag.de/en) 🔒
    - requires: MP3TAG_CONFIG_GDRIVE_ID
- [mpv](https://mpv.io)
- [MultiMonitorTool](https://www.nirsoft.net/utils/multi_monitor_tool.html)
- [Neofetch](https://github.com/nepnep39/neofetch-win)
- [Nicotine+](https://nicotine-plus.org)
- [NirCmd](https://www.nirsoft.net/utils/nircmd.html)
- [Node.js](https://nodejs.org)
- [NoPayStation](https://nopaystation.com)
- [Notepad++](https://notepad-plus-plus.org)
- [NVIDIA Drivers](https://www.nvidia.com/en-us/drivers)
- [NZXT CAM](https://nzxt.com/software/cam)
- [OBS Studio](https://obsproject.com)
- [Obsidian](https://obsidian.md)
- [oh-my-posh](https://ohmyposh.dev)
- [OldNewExplorer](https://www.majorgeeks.com/files/details/oldnewexplorer.html)
- [onefetch](https://github.com/o2sh/onefetch)
- [Open-Shell](https://open-shell.github.io/Open-Shell-Menu)
- [OpenRGB](https://openrgb.org)
- [OpenWithView](https://www.nirsoft.net/utils/open_with_view.html)
- [osu!](https://osu.ppy.sh)
- [PCSX2](https://pcsx2.net)
- [PeaZip](https://peazip.github.io)
- [Photoshop](https://www.adobe.com/products/photoshop.html) 🔒
    - requires: ADOBE_PHOTOSHOP_URL
- [PowerShell Profile](./Configs/PowerShell/Microsoft.PowerShell_profile.ps1)
- [PowerShell Update](https://learn.microsoft.com/en-us/powershell/scripting/whats-new/migrating-from-windows-powershell-51-to-powershell-7?view=powershell-7.4)
    - installs [PowerShell 7](https://github.com/PowerShell/PowerShell)
    - runs [Update-Help](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/update-help?view=powershell-7.4)
- [PowerToys](https://learn.microsoft.com/en-us/windows/powertoys)
- [PPSSPP](https://www.ppsspp.org)
- [Premiere Pro](https://www.adobe.com/products/premiere.html)
    - requires: ADOBE_PREMIERE_PRO_URL
- [Process Explorer](https://learn.microsoft.com/en-us/sysinternals/downloads/process-explorer)
- [Process Monitor](https://learn.microsoft.com/en-us/sysinternals/downloads/procmon)
- [ps2exe](https://github.com/MScholtes/PS2EXE)
- [PsShutdown](https://learn.microsoft.com/en-us/sysinternals/downloads/psshutdown)
- [Python](https://www.python.org)
- [qBittorrent](https://github.com/qbittorrent/qBittorrent) / [qBittorrent Enhanced](https://github.com/c0re100/qBittorrent-Enhanced-Edition)
- [QTTabBar](https://github.com/indiff/qttabbar)
- [r2modman](https://github.com/ebkr/r2modmanPlus)
- [Rainmeter](https://www.rainmeter.net) 🔒
    - requires: RAINMETER_WEATHER_API_KEY
- [RPCS3](https://rpcs3.net) 🔒
    - requires: PS3_SAVES_GDRIVE_ID
- [Ruby](https://www.ruby-lang.org/en)
- [Ruffle](https://ruffle.rs)
- [Rufus](https://rufus.ie/en)
- [Rust](https://www.rust-lang.org)
- [RustDesk](https://rustdesk.com)
- [Ryujinx](https://github.com/ryujinx-mirror/ryujinx) 🔒
    - requires: SWITCH_FILES_GDRIVE_ID
- [SameBoy](https://sameboy.github.io)
- [scdl](https://github.com/scdl-org/scdl)
- [SecureUxTheme](https://github.com/namazso/SecureUxTheme)
- [Sekiro](https://store.steampowered.com/app/814380) 🔒
    - requires: SEKIRO_GDRIVE_ID
- [SGDBoop](https://www.steamgriddb.com/boop)
- [ShellExView](https://www.nirsoft.net/utils/shexview.html)
- [ShellMenuNew](https://www.nirsoft.net/utils/shell_menu_new.html)
- [ShellMenuView](https://www.nirsoft.net/utils/shell_menu_view.html)
- [Ship of Harkinian](https://www.shipofharkinian.com) 🔒
    - requires: SOH_GDRIVE_ID
- [SoundVolumeView](https://www.nirsoft.net/utils/sound_volume_view.html)
- [Spicetify](https://spicetify.app)
    - see [Initialize-Spicetify.ps1](./Scripts/Initialize-Spicetify.ps1)
- [Spotify](https://open.spotify.com)
- [ssh](https://en.wikipedia.org/wiki/Secure_Shell)
    - optional: AUTHORIZED_SSH_PUBKEYS
- [Steam](https://store.steampowered.com)
    - see [Steam-Config.py](../Cross-Platform/Steam/Steam-Config.py)
- [Steam Achievement Manager](https://github.com/syntax-tm/SteamAchievementManager)
- [Steam ROM Manager](https://github.com/SteamGridDB/steam-rom-manager) 🔒
    - requires: STEAM_ACCOUNT_NAME, STEAM_ID, STEAM_ID3
- [Streamlink Twitch GUI](https://streamlink.github.io/streamlink-twitch-gui)
- [Stremio](https://www.stremio.com)
- [Syncthing](https://syncthing.net)
- [Syncthing Tray](https://github.com/Martchus/syncthingtray)
- [TaskbarX](https://chrisandriessen.nl/taskbarx)
- [TeraCopy](https://www.codesector.com/teracopy)
- [Terraria Font](https://freefontslab.com/terraria-font)
- [Twitch Downloader](https://github.com/lay295/TwitchDownloader)
- [Twitch Downloader CLI](https://github.com/lay295/TwitchDownloader)
- [Twitch Emote Downloader](https://github.com/Daniel2193/EmoteDownloader)
- [UniGetUI](https://github.com/marticliment/UniGetUI)
- [USBHelper](https://github.com/FailedShack/USBHelperInstaller)
- [veadotube mini](https://olmewe.itch.io/veadotube-mini)
- [Ventoy](https://www.ventoy.net/en/index.html)
- [VirtualBox](https://www.virtualbox.org)
- [Visual C++ Redistributable](https://learn.microsoft.com/en-us/cpp/windows/latest-supported-vc-redist?view=msvc-170)
- [Visual Studio Code](https://code.visualstudio.com)
- [Vita3K](https://vita3k.org)
- [VLC](https://www.videolan.org/vlc)
- [Voicemod](https://www.voicemod.net)
- [Wallpaper Engine](https://www.wallpaperengine.io/en)
    - Sets wallpapers to [this](https://steamcommunity.com/sharedfiles/filedetails/?id=2100929026) and [this](https://steamcommunity.com/sharedfiles/filedetails/?id=1854057384), and modifies them just before the script ends. Ensure you're subscribed to them.
- [webp2gif](http://www.rw-designer.com/webp2gif)
- [whois](https://learn.microsoft.com/en-us/sysinternals/downloads/whois)
- [WinAero Tweaker](https://winaerotweaker.com)
- [Windows Terminal](https://github.com/microsoft/terminal)
    - optional: LAPTOP_HOSTNAME, PI_HOSTNAME
- [WinRAR](https://www.win-rar.com/start.html?&L=0)
- [WinSetView](https://lesferch.github.io/WinSetView)
- [WizTree](https://www.diskanalyzer.com)
- [WSL](https://learn.microsoft.com/en-us/windows/wsl/about) with Arch/Debian
- [Xtreme Download Manager](https://xtremedownloadmanager.com)
- [Yarn](https://yarnpkg.com)
- [yt-dlp](https://github.com/yt-dlp/yt-dlp)

#### Runs Scripts

- [Microsoft Activation Scripts](https://github.com/massgravel/Microsoft-Activation-Scripts)
- [Sophia Script](https://github.com/farag2/Sophia-Script-for-Windows)
- [SoS Optimize Harden Debloat](https://github.com/simeononsecurity/Windows-Optimize-Harden-Debloat)

> [!NOTE]  
> The script probably does stuff I forgot to mention, you should really read through the script if you want the full picture.

</details>

### Credits

A few sections of [Setup.ps1](Setup.ps1) are from/rely on the following scripts.

- [Sophia Script](https://github.com/farag2/Sophia-Script-for-Windows)
- [Chris Titus Tech's Windows Utility](https://github.com/ChrisTitusTech/winutil)
- [W4RH4WK's Windows 10 Debloating Scripts](https://github.com/W4RH4WK/Debloat-Windows-10)
- [SoS Optimize, Harden, and Debloat Script](https://github.com/simeononsecurity/Windows-Optimize-Harden-Debloat)
