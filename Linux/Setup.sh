#!/usr/bin/env bash

set -euo pipefail

# traps

readonly BASH_COMPLETION_DIR=~/.local/share/bash-completion/completions
readonly SCRIPT_DEPENDENCIES=(yq 7z curl gum)
         SCRIPT_DIR=$(dirname "$(realpath "$0")")
readonly SCRIPT_DIR

readonly -A PACKAGE_MANAGERS=(
    [apt-get]='sudo apt-get install -y'
    [cargo]='cargo install'
    [dnf]='sudo dnf install -y'
    [flatpak]='flatpak install --or-update -y'
    [pacman]='sudo pacman -S --noconfirm'
    [paru]='paru -Sa --noconfirm'
    [pipx]='pipx install'
    [uv]='uv tool install'
    [yay]='yay -Sa --noconfirm'
)

readarray -t SORTED_PACKAGE_MANAGERS < <(printf '%s\n' "${!PACKAGE_MANAGERS[@]}" | sort)
readonly SORTED_PACKAGE_MANAGERS

function copy_to_clipboard {
    local string="$1"

    if command -v xclip &>/dev/null; then
        printf "%s" "$string" | xclip -selection clipboard
    elif command -v wl-copy &>/dev/null; then
        printf "%s" "$string" | wl-copy
    fi
}

function get_latest_release_asset_url {
    local repo="$1"
    local pattern="${2:-}"
    local releases_json
    local url=""

    releases_json=$(curl -s "https://api.github.com/repos/$repo/releases")

    if [[ -n $pattern ]]; then
        url=$(echo "$releases_json" | yq -r '.[] | .assets[]? | select(.name | test("'"$pattern"'")) | .browser_download_url' | head -n 1)
    fi

    if [[ -z $url || $url == "null" ]]; then
        url=$(echo "$releases_json" | yq -r '.[0].zipball_url')
    fi

    if [[ -z $url || $url == "null" ]]; then
        echo ""
    else
        echo "$url"
    fi
}

function install_font {
    local font_url="$1"
    local font_dest=~/.local/share/fonts
    local font_zip
    local font_dir

    font_zip=$(mktemp --suffix=.zip)
    font_dir=$(mktemp -d)

    mkdir -p "$font_dir" "$font_dest"
    curl -fsSL -o "$font_zip" "$font_url"
    unzip -q -o "$font_zip" -d "$font_dir"
    find "$font_dir" -iname '*.ttf' -exec cp {} "$font_dest" \;
    fc-cache -f "$font_dest"
    rm -rf "$font_zip" "$font_dir"
}

function install_packages {
    local packages=("$@")

    for package in "${packages[@]}"; do
        installed=0
        for manager in "${detected_managers[@]}"; do
            yq_manager=$manager

            if [[ $manager = 'apt-get' ]]; then
                yq_manager='apt'
            elif [[ $manager =~ ^(pipx|uv)$ ]]; then
                yq_manager='pypi'
            elif printf '%s\0' "${detected_aur_helpers[@]}" | grep -Fxqz -- "$manager"; then
                yq_manager='aur'
            fi

            commands=$(yq '.[] | select((.name | downcase) == "'"${package,,}"'") | .install[] | select((.manager == "'"$yq_manager"'") or (.manager[]? == "'"$yq_manager"'")) | .run' "$SCRIPT_DIR/packages.yml")

            if [[ -n $commands && $commands != null ]]; then
                gum style " → Running install commands for $package:"
                gum style "$commands"
                # "$commands"
                installed=1
                break
            fi

            package_id=$(yq '.[] | select((.name | downcase) == "'"${package,,}"'") | .install[] | select((.manager == "'"$yq_manager"'") or (.manager[]? == "'"$yq_manager"'")) | .id' "$SCRIPT_DIR/packages.yml")

            if [[ -n "$package_id" ]]; then
                install_command=${PACKAGE_MANAGERS[$manager]}
                gum style " → Running $install_command $package_id"
                # "$install_command $package_id"
                installed=1
                break
            fi
        done

        if [[ $installed -eq 0 ]]; then
            bash_commands=$(yq '.[] | select(.name == "'"$package"'") | .install[] | select(.manager == "bash") | .run' "$SCRIPT_DIR/packages.yml")
            if [[ -n $bash_commands && $bash_commands != 'null' ]]; then
                gum style " → Running bash install commands for $package:"
                gum style "$bash_commands"
                # "$bash_commands"
            else
                gum style "Could not find install commands for $package." >&2
                continue
            fi
        fi

        package=''

        case $package in
            'BetterDiscord')
                cp -r "$SCRIPT_DIR"/../Cross-Platform/BetterDiscord/* ~/.config/BetterDiscord
                pluginDir=~/.config/BetterDiscord/plugins
                themeDir=~/.config/BetterDiscord/themes
                mkdir -p "$pluginDir" "$themeDir"
                curl -fsSL -o "$pluginDir/0BDFDB.plugin.js"                     https://raw.githubusercontent.com/mwittrien/BetterDiscordAddons/refs/heads/master/Library/0BDFDB.plugin.js
                curl -fsSL -o "$pluginDir/0PluginLibrary.plugin.js"             https://raw.githubusercontent.com/zerebos/BDPluginLibrary/refs/heads/master/release/0PluginLibrary.plugin.js
                curl -fsSL -o "$pluginDir/ActivityIcons.plugin.js"              https://raw.githubusercontent.com/Neodymium7/BetterDiscordStuff/refs/heads/main/ActivityIcons/ActivityIcons.plugin.js
                curl -fsSL -o "$pluginDir/BetterAnimations.plugin.js"           https://raw.githubusercontent.com/arg0NNY/DiscordPlugins/refs/heads/master/BetterAnimations/BetterAnimations.plugin.js
                curl -fsSL -o "$pluginDir/BetterAudioPlayer.plugin.js"          https://raw.githubusercontent.com/jaspwr/BDPlugins/refs/heads/main/BetterAudioPlayer/BetterAudioPlayer.plugin.js
                curl -fsSL -o "$pluginDir/BetterFormattingRedux.plugin.js"      https://raw.githubusercontent.com/zerebos/BetterDiscordAddons/refs/heads/master/Plugins/BetterFormattingRedux/BetterFormattingRedux.plugin.js
                curl -fsSL -o "$pluginDir/BetterGuildTooltip.plugin.js"         https://raw.githubusercontent.com/arg0NNY/DiscordPlugins/refs/heads/master/BetterGuildTooltip/BetterGuildTooltip.plugin.js
                curl -fsSL -o "$pluginDir/BetterNsfwTag.plugin.js"              https://raw.githubusercontent.com/mwittrien/BetterDiscordAddons/refs/heads/master/Plugins/BetterNsfwTag/BetterNsfwTag.plugin.js
                curl -fsSL -o "$pluginDir/BetterVolume.plugin.js"               https://raw.githubusercontent.com/Zerthox/BetterDiscord-Plugins/refs/heads/master/dist/bd/BetterVolume.plugin.js
                curl -fsSL -o "$pluginDir/BiggerStreamPreview.plugin.js"        https://raw.githubusercontent.com/nicola02nb/BetterDiscord-Stuff/refs/heads/main/Plugins/BiggerStreamPreview/BiggerStreamPreview.plugin.js
                curl -fsSL -o "$pluginDir/CallTimeCounter.plugin.js"            https://raw.githubusercontent.com/QWERTxD/BetterDiscordPlugins/refs/heads/main/CallTimeCounter/CallTimeCounter.plugin.js
                curl -fsSL -o "$pluginDir/DiscordFreeEmojis.plugin.js"          https://raw.githubusercontent.com/EpicGazel/DiscordFreeEmojis/refs/heads/master/DiscordFreeEmojis.plugin.js
                curl -fsSL -o "$pluginDir/DoNotTrack.plugin.js"                 https://raw.githubusercontent.com/zerebos/BetterDiscordAddons/refs/heads/master/Plugins/DoNotTrack/DoNotTrack.plugin.js
                curl -fsSL -o "$pluginDir/DoubleClickToEdit.plugin.js"          https://raw.githubusercontent.com/Farcrada/DiscordPlugins/refs/heads/master/Double-click-to-edit/DoubleClickToEdit.plugin.js
                curl -fsSL -o "$pluginDir/EditUsers.plugin.js"                  https://raw.githubusercontent.com/mwittrien/BetterDiscordAddons/refs/heads/master/Plugins/EditUsers/EditUsers.plugin.js
                curl -fsSL -o "$pluginDir/GameActivityToggle.plugin.js"         https://raw.githubusercontent.com/mwittrien/BetterDiscordAddons/refs/heads/master/Plugins/GameActivityToggle/GameActivityToggle.plugin.js
                curl -fsSL -o "$pluginDir/ImageUtilities.plugin.js"             https://raw.githubusercontent.com/mwittrien/BetterDiscordAddons/refs/heads/master/Plugins/ImageUtilities/ImageUtilities.plugin.js
                curl -fsSL -o "$pluginDir/InvisibleTyping.plugin.js"            https://raw.githubusercontent.com/Strencher/BetterDiscordStuff/refs/heads/master/InvisibleTyping/InvisibleTyping.plugin.js
                curl -fsSL -o "$pluginDir/NoSpotifyPause.plugin.js"             https://raw.githubusercontent.com/bepvte/bd-addons/refs/heads/main/plugins/NoSpotifyPause.plugin.js
                curl -fsSL -o "$pluginDir/ReadAllNotificationsButton.plugin.js" https://raw.githubusercontent.com/mwittrien/BetterDiscordAddons/refs/heads/master/Plugins/ReadAllNotificationsButton/ReadAllNotificationsButton.plugin.js
                curl -fsSL -o "$pluginDir/SecretRingTone.plugin.js"             https://raw.githubusercontent.com/jaimeadf/BetterDiscordPlugins/refs/heads/build/SecretRingTone/dist/SecretRingTone.plugin.js
                curl -fsSL -o "$pluginDir/ShowConnections.plugin.js"            https://raw.githubusercontent.com/mwittrien/BetterDiscordAddons/refs/heads/master/Plugins/ShowConnections/ShowConnections.plugin.js
                curl -fsSL -o "$pluginDir/SplitLargeMessages.plugin.js"         https://raw.githubusercontent.com/mwittrien/BetterDiscordAddons/refs/heads/master/Plugins/SplitLargeMessages/SplitLargeMessages.plugin.js
                curl -fsSL -o "$pluginDir/TypingIndicator.plugin.js"            https://raw.githubusercontent.com/aarondoet/BetterDiscordStuff/refs/heads/master/Plugins/TypingIndicator/TypingIndicator.plugin.js
                curl -fsSL -o "$pluginDir/TypingUsersAvatars.plugin.js"         https://raw.githubusercontent.com/QWERTxD/BetterDiscordPlugins/main/TypingUsersAvatars/TypingUsersAvatars.plugin.js
                curl -fsSL -o "$themeDir/DiscordRecolor.theme.css"              https://raw.githubusercontent.com/mwittrien/BetterDiscordAddons/refs/heads/master/Themes/DiscordRecolor/DiscordRecolor.theme.css
                curl -fsSL -o "$themeDir/discolored.theme.css"                  https://raw.githubusercontent.com/NYRI4/Discolored/refs/heads/master/support/discolored.theme.css
                if (betterdiscordctl -i traditional install &> /dev/null || betterdiscordctl -i flatpak install &> /dev/null); then
                    gum style 'BetterDiscord installed successfully.'
                else
                    gum style 'BetterDiscord installation failed.'
                fi
                ;;
            'BlueZ')
                ! lsmod | grep -Fq btusb && sudo modprobe btusb
                sudo systemctl enable --now bluetooth.service
                ;;
            'Calibre')
                mkdir -p ~/.config/calibre
                cp "$SCRIPT_DIR/../Cross-Platform/Calibre/icons-dark.rcc" ~/.config/calibre
                ;;
            'Chatterino')
                config_dir=~/.local/share/chatterino/Settings
                mkdir -p $config_dir ~/Audio/SFX/Notifications
                cp "$SCRIPT_DIR"/../Cross-Platform/Chatterino/{commands,window-layout}.json $config_dir
                cp "$SCRIPT_DIR"/../Cross-Platform/Chatterino/default-notification.mp3 ~/Audio/SFX/Notifications/chatterino-default.mp3
                cp "$SCRIPT_DIR"/../Cross-Platform/Chatterino/jerma-notification.wav ~/Audio/SFX/Notifications/chatterino-jerma-message.wav

                sed -e "s|jerma-notification-path-here|$HOME/Audio/SFX/Notifications/chatterino-jerma-message.wav|g" \
                    -e "s|default-notification-path-here|$HOME/Audio/SFX/Notifications/chatterino-default.mp3|g" \
                    -e "s|imgur-client-id-here|$IMGUR_CLIENT_ID|g" \
                    "$SCRIPT_DIR/../Cross-Platform/Chatterino/settings.json" > $config_dir/settings.json

                if command -v syncthing &> /dev/null; then
                    printf '*.json.bkp-*\n*.json.??????' >  ~/.local/share/chatterino/Settings/.stignore
                    syncthing cli config folders add --id 'axgjf-shqtw' --label 'Chatterino' --path ~/.local/share/chatterino/Settings
                fi
                ;;
            'ckb-next')
                sudo systemctl enable --now ckb-next-daemon.service
                ;;
            'Dolphin Emulator')
                if command -v flatpak &> /dev/null && flatpak list --columns=application | grep -Fq org.DolphinEmu.dolphin-emu; then
                    profiles_dir=~/.var/app/org.DolphinEmu.dolphin-emu/config/dolphin-emu/Profiles
                else
                    # todo
                    profiles_dir=~/.config/dolphin-emu/Profiles
                fi

                temp_zip=$(mktemp --suffix=.zip)
                temp_dir=$(mktemp -d)
                mkdir -p $profiles_dir/{GCPad,Wiimote}
                curl -fsSL -o "$temp_zip" https://gist.github.com/Bergbok/7db0ab7cdeb96bebb9144c7a96a4c211/archive/2e21ed4a370688d1a65b0ec25483fc7be7ce2b7a.zip
                unzip -q -o "$temp_zip" -d "$temp_dir"
                find "$temp_dir" -type f -name 'Xbox Controller (GCPad).ini'            -exec cp {} $profiles_dir/GCPad \;
                find "$temp_dir" -type f -name 'Xbox Controller (Nunchuk+Wiimote).ini'  -exec cp {} $profiles_dir/Wiimote \;
                rm -rf "$temp_zip" "$temp_dir"
                ;;
            'DuckStation')
                if command -v flatpak &> /dev/null && flatpak list --columns=application | grep -Fq org.duckstation.DuckStation; then
                    bios_dir=~/.var/app/org.duckstation.DuckStation/config/duckstation/bios
                else
                    # todo
                    bios_dir=~/.config/duckstation/bios
                fi

                temp_zip=$(mktemp --suffix=.zip)
                temp_dir=$(mktemp -d)
                mkdir -p "$bios_dir"
                curl -fsSL -o "$temp_zip" https://archive.org/download/bios_20210423/BIOS.zip
                unzip -q -o "$temp_zip" -d "$temp_dir"
                mv "$temp_dir"/* "$bios_dir"
                rm -rf "$temp_zip" "$temp_dir"
                ;;
            'fail2ban')
                sudo systemctl enable --now fail2ban.service
                ;;
            'Firefox')
                firefox --setDefaultBrowser

                arkenfox_zip=$(mktemp --suffix=.zip)
                arkenfox_dir=$(mktemp -d)
                user_chrome=$(mktemp --suffix=.css)
                profile_folder="$SCRIPT_DIR/../Cross-Platform/Firefox"
                syncthing_folder=''

                curl -fsSL -o "$arkenfox_zip" "$(get_latest_release_asset_url 'arkenfox/user.js')"
                unzip -q -o "$arkenfox_zip" -d "$arkenfox_dir"
                mv "$arkenfox_dir"/arkenfox-user.js*/* "$arkenfox_dir"
                rm -rf "$arkenfox_dir"/arkenfox-user.js* "$arkenfox_dir/prefsCleaner.bat" "$arkenfox_dir/updater.bat" "$arkenfox_dir/README.md" "$arkenfox_dir/LICENSE.txt"
                chmod +x "$arkenfox_dir/prefsCleaner.sh" "$arkenfox_dir/updater.sh"

                sed -e "s|phone-hostname-here|$PHONE_HOSTNAME|g" \
                    -e "s|pi-hostname-here|$PI_HOSTNAME|g" \
                    "$profile_folder/chrome/userChrome.css" > "$user_chrome"

                for dir in ~/.mozilla/firefox/*/; do
                    dir="${dir%/}"
                    if [[ -d "$dir/chrome" || -d "$dir/settings" ]]; then
                        [[ -z $syncthing_folder ]] && syncthing_folder="$dir/chrome"
                        mkdir -p "$dir/chrome"
                        cp -r "$profile_folder"/* "$dir"
                        cp "$arkenfox_dir"/* "$dir"
                        cp "$user_chrome" "$dir/chrome/userChrome.css"

                        pkill firefox || true

                        echo y | . "$dir/updater.sh" -u
                        echo 1 | . "$dir/prefsCleaner.sh"
                    fi
                done

                rm -rf "$arkenfox_zip" "$arkenfox_dir" "$user_chrome"

                for file in "$SCRIPT_DIR"/../Cross-Platform/Browser-Extensions/*; do
                    if [[ -f "$file" && "$(basename "$file")" != "FFZ.json" ]]; then
                        firefox --new-tab "file://$file"
                    fi
                done

                firefox --new-tab https://store.steampowered.com
                firefox --new-tab https://www.twitch.tv/greatsphynx
                firefox --new-tab https://adsbypasser.github.io/releases/adsbypasser.full.es7.user.js
                firefox --new-tab https://raw.githubusercontent.com/Nuklon/Steam-Economy-Enhancer/master/code.user.js
                firefox --new-tab https://github.com/pixeltris/TwitchAdSolutions/raw/refs/heads/master/video-swap-new/video-swap-new.user.js
                firefox --new-tab https://codeberg.org/Amm0ni4/bypass-all-shortlinks-debloated/raw/branch/main/Bypass_All_Shortlinks.user.js
                firefox --new-tab https://raw.githubusercontent.com/Bergbok/Configs/refs/heads/main/Cross-Platform/Browser-Extensions/FFZ.json
                firefox --new-tab https://duckduckgo.com/settings
                firefox --new-tab about:profiles
                firefox --new-tab about:preferences#search

                if command -v syncthing &> /dev/null && [[ -n $syncthing_folder ]]; then
                    syncthing cli config folders add --id 'xhfsq-nqpty' --label 'Firefox CSS' --path "$syncthing_folder" --paused
                fi
                ;;
            'Flameshot')
                if command -v flatpak &> /dev/null && flatpak list --columns=application | grep -Fq org.flameshot.Flameshot; then
                    config_dir=~/.var/app/org.flameshot.Flameshot/config/flameshot
                else
                    # todo
                    config_dir=~/.config/flameshot
                fi

                mkdir -p "$config_dir" ~/Pictures/Screenshots
                sed -e "s|screenshot-path-here|$HOME/Pictures/Screenshots|" \
                    -e "s|imgur-client-id-here|$IMGUR_CLIENT_ID|" \
                    "$SCRIPT_DIR/../Cross-Platform/Flameshot/Flameshot.ini" > $config_dir/flameshot.ini
                ;;
            'Flatpak')
                flatpak remote-add --if-not-exists --system flathub https://dl.flathub.org/repo/flathub.flatpakrepo
                ;;
            'FreeTube')
                temp_7z=$(mktemp --suffix=.7z)

                mkdir -p ~/.config/FreeTube
                cp "$SCRIPT_DIR/../Cross-Platform/FreeTube/settings.db" ~/.config/FreeTube
                pdown "$FREETUBE_DATA_PDRIVE_ID" -o "$temp_7z"
                7z x "$temp_7z" -o~/.config/FreeTube -p"$KEY_STRING" -y
                rm "$temp_7z"

                if command -v syncthing &> /dev/null; then
                    printf '!/history.db\n!/playlists.db\n!/profiles.db\n!/settings.db\n*' > ~/.config/FreeTube/.stignore
                    syncthing cli config folders add --id 'kqgmu-jazfm' --label 'FreeTube' --path ~/.config/FreeTube
                fi
                ;;
            'GameMode')
                sudo usermod -aG gamemode "$USER"
                ;;
            'git')
                git config --global alias.please 'push --force-with-lease'
                git config --global core.symlinks true
                git config --global init.defaultBranch 'main'
                git config --global user.email "$GIT_EMAIL"
                git config --global user.name "$GIT_NAME"

                if ! git config --global user.signingKey &> /dev/null && command -v gpg &> /dev/null; then
                    git config --global commit.gpgSign true
                    git config --global tag.gpgSign true

                    temp_file=$(mktemp)

                    echo "%echo Generating GPG key...
                        Key-Type: $GPG_KEY_TYPE
                        Key-Length: $GPG_KEY_LENGTH
                        Key-Curve: $GPG_KEY_CURVE
                        Subkey-Type: $GPG_SUBKEY_TYPE
                        Subkey-Length: $GPG_SUBKEY_LENGTH
                        Subkey-Curve: $GPG_SUBKEY_CURVE
                        Passphrase: $GPG_PASSPHRASE
                        Name-Real: $GPG_NAME_REAL
                        Name-Email: $GPG_NAME_EMAIL
                        Expire-Date: $GPG_EXPIRE_DATE
                        %commit
                        %echo done" > "$temp_file"

                    gpg_output=$(gpg --batch --generate-key "$temp_file" 2>&1)
                    key_fingerprint=$(echo "$gpg_output" | sed -n "s|.*/\([A-F0-9]\{40\}\)\.rev.*|\1|p" | head -n1)

                    if [[ -n "$key_fingerprint" ]]; then
                        git config --global user.signingkey "$key_fingerprint"
                        pubkey=$(gpg --armor --export "$key_fingerprint")
                        echo "$pubkey"
                        copy_to_clipboard "$pubkey"
                        xdg-open 'https://github.com/settings/gpg/new'
                    else
                        echo "Could not extract GPG key fingerprint from gpg output." >&2
                    fi
                fi

                if command -v code &> /dev/null || printf '%s\0' "${packages[@]}" | grep -Fxqz -- 'Visual Studio Code'; then
                    git config --global core.editor 'code --wait'
                fi
                ;;
            'gpustat')
                gpustat --print-completion bash > "$BASH_COMPLETION_DIR/gpustat"
                ;;
            'KeePassXC')
                mkdir -p ~/Documents/KeePass
                if command -v syncthing &> /dev/null; then
                    syncthing cli config folders add --id 'fxxre-9vvua' --label 'KeePass' --path ~/Documents/KeePass
                fi
                ;;
            'Localsend')
                # allow incoming udp & tcp on 53317
                ;;
            'Lumafly')
                lumafly scarab://modpack/mPP6enEq
                ;;
            'Obsidian')
                mkdir -p ~/Documents/Obsidian
                xdg-open https://github.com/Bergbok/Obsidian-Vault
                if command -v syncthing &> /dev/null; then
                    syncthing cli config folders add --id 'd4xqu-hqmrt' --label 'Obsidian' --path ~/Documents/Obsidian
                fi
                ;;
            'OpenRB')
                mkdir -p ~/.config/OpenRGB
                cp -r "$SCRIPT_DIR"/../Cross-Platform/OpenRGB/. ~/.config/OpenRGB
                ;;
            'PCXS2')
                if command -v flatpak &> /dev/null && flatpak list --columns=application | grep -Fq net.pcsx2.PCSX2; then
                    bios_dir=~/.var/app/net.pcsx2.PCSX2/config/PCSX2/bios
                else
                    # todo
                    bios_dir=~/.config/PCSX2/bios
                fi

                temp_zip=$(mktemp --suffix=.zip)
                temp_dir=$(mktemp -d)
                mkdir -p "$bios_dir"
                curl -fsSL -o "$temp_zip" https://archive.org/download/bios_20210423/BIOS.zip
                unzip -q -o "$temp_zip" -d "$temp_dir"
                mv "$temp_dir"/* "$bios_dir"
                rm -rf "$temp_zip" "$temp_dir"
                ;;
            'PeaZip')
                if command -v flatpak &> /dev/null && flatpak list --columns=application | grep -Fq io.github.peazip.PeaZip; then
                    config_dir=~/.var/app/io.github.peazip.PeaZip/config/peazip
                else
                    config_dir=~/.config/peazip
                fi

                mkdir -p "$config_dir"
                # peazip doesn't actually accept the config as valid but w/e
                sed -e 's|themes\main-embedded\theme.txt|themes/main-embedded/theme.txt|' \
                    -e 's|themes\main-embedded\\|themes/main-embedded/|' \
                    "$SCRIPT_DIR/../Cross-Platform/PeaZip/conf.txt" > "$config_dir/conf.txt"
                ;;
            'pipx')
                sudo pipx ensurepath --global
                ;;
            'pwsh')
                pwsh -Command Update-Help &
                ;;
            'scdl')
                mkdir -p ~/Downloads/Audio/SoundCloud ~/.config/scdl
                sed -e "s|path-here|$HOME/Downloads/Audio/SoundCloud|" \
                    "$SCRIPT_DIR/../Cross-Platform/scdl/scdl.cfg" > ~/.config/scdl/scdl.cfg
                ;;
            'SGDBoop')
                xdg-open https://www.steamgriddb.com/boop
                ;;
            'Ship of Harkinian')
                temp_7z=$(mktemp --suffix=.7z)
                pdown "$SOH_PDRIVE_ID" -o "$temp_7z"
                7z x "$temp_7z" -o"$HOME/.local/share/shipwright" -p"$KEY_STRING" -y
                rm "$temp_7z"
                ;;
            'Spicetify')
                chmod +x "$SCRIPT_DIR/Scripts/setup-spicetify.sh"
                . "$SCRIPT_DIR/Scripts/setup-spicetify.sh"
                xdg-open spotify:marketplace
                xdg-open https://raw.githubusercontent.com/Bergbok/Configs/refs/heads/main/Cross-Platform/Spicetify/marketplace.json
                xdg-open https://gist.githubusercontent.com/Bergbok/c7503bcb7ba2699ae10830b5aacbf333/raw/excluding-%255Bcontains-local-files%255D
                xdg-open https://gist.githubusercontent.com/Bergbok/c7503bcb7ba2699ae10830b5aacbf333/raw/including-%255Bcontains-local-files%255D
                ;;
            'Steam')
                sudo ufw allow 27040/tcp comment 'Steam LAN Transfer'
                sudo ufw allow 27031:27036/udp comment 'Steam LAN Discovery'
                sudo ufw reload

                while true; do
                    cd "$SCRIPT_DIR/../Cross-Platform/Steam"
                    python -m venv .venv
                    source .venv/bin/activate
                    pip install -r requirements.txt
                    output=$(python Steam-Config.py ~/.local/share/Steam)
                    deactivate
                    rm -rf .venv
                    cd "$SCRIPT_DIR"

                    if grep -Eq 'No (config|localconfig|sharedconfig)\.vdf found' <<< "$output"; then
                        retry=$(gum confirm --affirmative='Retry' --negative='Skip' "Steam couldn't be configured. Have you logged in yet?")
                        [[ $retry = "Skip" ]] && break
                    else
                        break
                    fi
                done
                ;;
            'Syncthing')
                syncthing generate --no-default-folder
                systemctl enable --user --now syncthing.service
                ;;
            'tealdeer')
                tldr --update
                ;;
            'Tailscale')
                sudo systemctl enable --now tailscaled
                sudo tailscale up
                tailscale ip -4
                ;;
            'TLP')
                sudo systemctl enable --now tlp.service
                sudo systemctl mask systemd-rfkill.service systemd-rfkill.socket
                ;;
            'Vesktop')
                flatpak override dev.vencord.Vesktop --socket=wayland
                ;;
            'XMousePasteBlock')
                systemctl enable --user --now xmousepasteblock
                ;;
        esac
    done
}

if [[ $EUID -eq 0 ]]; then
    echo "Don't run this with root privileges." >&2c
    exit 1
fi

if [[ -z "${USER:-}" ]]; then
    USER=$(id -u -n)
fi

# https://stackoverflow.com/a/43267603
set -a
source "$SCRIPT_DIR/.env"
set +a

# https://gist.github.com/cowboy/3118588
# sudo -v
# while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2> /dev/null &

mkdir -p "$BASH_COMPLETION_DIR" ~/.config/systemd/user ~/Audio
[[ -d ~/Music ]] && mv ~/Music ~/Audio

# Detect package managers
detected_managers=()
detected_aur_helpers=()
for manager in "${SORTED_PACKAGE_MANAGERS[@]}"; do
    if command -v "$manager" &> /dev/null; then
        detected_managers+=("$manager")

        case $manager in
            'apt-get')
                sudo apt-get update
                sudo apt-get upgrade -y
                SYSTEM_PACKAGE_MANAGER='apt-get'
                ;;
            'dnf')
                sudo dnf upgrade --refresh -y
                SYSTEM_PACKAGE_MANAGER='dnf'
                ;;
            'flatpak')
                flatpak remote-add --if-not-exists --system flathub https://dl.flathub.org/repo/flathub.flatpakrepo
                ;;
            'pacman')
                # enables the multilib repository
                if ! grep -q "^\[multilib\]" /etc/pacman.conf; then
                    sudo sed -i '/^\s*#\s*\[multilib\]/s/^#\s*//' /etc/pacman.conf
                    sudo sed -i '/^\[multilib\]/,/^$/s/^\s*#\s*Include/Include/' /etc/pacman.conf
                fi

                # sudo pacman -Syu --noconfirm
                SYSTEM_PACKAGE_MANAGER='pacman'
                ;;
            'pipx')
                # sudo pipx ensurepath --global
                ;;
        esac
    fi
done

if [[ ${#detected_managers[@]} -eq 0 ]]; then
    echo No supported package managers found. >&2
    exit 1
fi

if [[ -z "${SYSTEM_PACKAGE_MANAGER:-}" ]]; then
    echo No system package manager found. >&2
    exit 1
else
    new_managers=("$SYSTEM_PACKAGE_MANAGER")
    for manager in "${detected_managers[@]}"; do
        if [[ $manager != "$SYSTEM_PACKAGE_MANAGER" ]]; then
            new_managers+=("$manager")
        fi
    done
    detected_managers=("${new_managers[@]}")
fi

# AUR helper setup
if [[ $SYSTEM_PACKAGE_MANAGER = 'pacman' ]]; then
    for helper in paru yay; do
        if command -v "$helper" &> /dev/null; then
            detected_aur_helpers+=("$helper")
        fi
    done

    if [[ ${#detected_aur_helpers[@]} -eq 0 ]]; then
        helper=$(gum choose --header='No AUR helper detected - choose one to install:' --limit=1 'paru' 'yay')
        case $helper in
            'paru')
                detected_aur_helpers+=('paru')
                git clone https://aur.archlinux.org/paru.git
                cd paru
                makepkg -si
                cd ..
                rm -rf paru

                mkdir -p ~/.config/paru
                cp "$SCRIPT_DIR/Configs/paru.conf" ~/.config/paru
                ;;
            'yay')
                detected_aur_helpers+=('yay')
                git clone https://aur.archlinux.org/yay.git
                cd yay
                makepkg -si
                cd ..
                rm -rf yay

                yay -Y --devel --save
                yay -Y --sudoloop --save
                ;;
        esac
    fi
fi

# Script dependency setup
for dependency in "${SCRIPT_DEPENDENCIES[@]}"; do
    if ! command -v "$dependency" &> /dev/null; then
        if [[ $dependency = 'yq' ]]; then
            [[ $SYSTEM_PACKAGE_MANAGER = 'pacman' ]] && dependency='extra/go-yq'
            ${PACKAGE_MANAGERS[$SYSTEM_PACKAGE_MANAGER]} "$dependency"
            continue
        fi

        [[ $dependency = '7z' ]] && dependency='7zip'

        install_packages "$dependency"
    fi
done
yq completion bash > "$BASH_COMPLETION_DIR/yq"

# Setup additional package managers and reorder
while true; do
    detected_manager_list=''
    for i in "${!detected_managers[@]}"; do
        detected_manager_list+="$((i + 1)). ${detected_managers[i]}"$'\n'
    done
    gum style --border double --padding "1 2" --margin 1 <<< "$detected_manager_list"

    missing_managers=()
    for manager in "${!PACKAGE_MANAGERS[@]}"; do
        if [[ $manager =~ ^(apt-get|dnf|pacman)$ ]]; then
            continue
        elif ! printf '%s\0' "${detected_managers[@]}" | grep -Fxqz -- "$manager"; then
            missing_managers+=("$manager")
        fi
    done

    options=('Add' 'Reorder' 'Continue')

    [[ ${#missing_managers[@]} -eq 0 ]] && options=("${options[@]:1}")

    choice=$(gum choose "${options[@]}")

    if [[ $choice = 'Add' ]]; then
        additions=$(gum choose --no-limit "${missing_managers[@]}")
        for manager in $additions; do
            install_packages "$manager"
            detected_managers+=("$manager")
        done
    elif [[ $choice = 'Reorder' ]]; then
        while true; do
            mapfile -t new_managers < <(
                printf "%s\n" "${detected_managers[@]}" |
                gum write |
                sed '/^[[:space:]]*$/d' |
                xargs -n1
            )

            # Only allow values present in the original list
            invalid_entries=()
            for manager in "${new_managers[@]}"; do
                if ! printf "%s\n" "${detected_managers[@]}" | grep -Fxq -- "$manager"; then
                    invalid_entries+=("$manager")
                fi
            done

            if (( ${#invalid_entries[@]} )); then
                gum style "Invalid: ${invalid_entries[*]}" >&2
                continue
            fi

            if (( ${#new_managers[@]} != ${#detected_managers[@]} )); then
                gum style "Keep all managers! Removals or additions aren't supported." >&2
                continue
            fi

            detected_managers=("${new_managers[@]}")
            break
        done
    else
        break
    fi
done

# TODO: determine --preselected

# Package selection
readarray -t tags < <(yq '.[].tags[]' "$SCRIPT_DIR/packages.yml" | sort | uniq -c | sort -nr | awk '{gsub(/^ +/, ""); printf "[%02d] %s\n", $1, substr($0, index($0,$2))}')
final_selection=()
while true; do
    choice=$(gum choose "${tags[@]}" 'Done')

    if [[ $choice = 'Done' && ${#final_selection[@]} -eq 0 ]]; then
        # gum style --border double --padding "1 2" --margin 1 <<< 'No packages selected.'
        # continue
        break
    elif [[ $choice = 'Done' ]]; then
        break
    fi

    choice=$(awk '{ $1=""; sub(/^ +/, ""); print }' <<< "$choice")

    readarray -t category_packages < <(yq '.[] | select(.tags[] == "'"$choice"'") | .name' "$SCRIPT_DIR/packages.yml")
    readarray -t selection < <(
        gum choose --header="Select packages:" --no-limit \
            --selected="$(IFS=,; echo "${final_selection[*]}")" \
            "${category_packages[@]}"
    )

    new_final=()
    for package in "${final_selection[@]}"; do
        if ! printf '%s\0' "${category_packages[@]}" | grep -Fxqz -- "$package"; then
            new_final+=("$package")
        fi
    done

    new_final+=( "${selection[@]}" )

    final_selection=()
    for package in "${new_final[@]}"; do
        if ! printf '%s\0' "${final_selection[@]}" | grep -Fxqz -- "$package"; then
            final_selection+=("$package")
        fi
    done
done

# TODO: reorder final_selection

# General configuration
# sudo cp /etc/sudoers /tmp/sudoers
# sudo grep -q '^Defaults insults'          /tmp/sudoers || sudo tee -a /tmp/sudoers <<< 'Defaults insults'           > /dev/null
# sudo grep -q '^Defaults passwd_timeout=0' /tmp/sudoers || sudo tee -a /tmp/sudoers <<< 'Defaults passwd_timeout=0'  > /dev/null

# # shellcheck disable=SC2024
# if sudo visudo --check --file /tmp/sudoers > /dev/null; then
#     sudo mv /tmp/sudoers /etc/sudoers
# else
#     echo 'Modified sudoers file is invalid! Changes not applied.' >&2
# fi
# loginctl enable-linger "$USER"
# echo 'blacklist hid_playstation' | sudo tee /etc/modprobe.d/playstation.conf

install_packages "${final_selection[@]}"

# "Autologon"               https://wiki.archlinux.org/title/SDDM#Autologin
# "Cyberpunk Waifus Font"   https://dl.dafont.com/dl/?f=cyberpunkwaifus
# "Elden Ring Save Manager" https://github.com/vaalberith/EldenRing-Save-Manager.git
# "khinsider.py"            https://github.com/obskyr/khinsider.git
# "NoPayStation"            https://github.com/sigmaboy/nopaystation_scripts + aur pkg2zip-fork
# "NVIDIA Drivers"
# "Obsidian AppImage"       https://github.com/obsidianmd/obsidian-releases/releases get_latest_release_asset_url "obsidianmd/obsidian-releases" "Obsidian-[\d.]+AppImage"
# "Terraria Font"           https://www.ffonts.net/Andy-Bold.font.zip
# "veadotube mini"          https://olmewe.itch.io/veadotube-mini/purchase
# "Voicemod"
# "Wallpaper"
