#!/usr/bin/env bash

script_dir="$(dirname "$0")"

mkdir -p "$HOME/Audio/SFX/Notifications"

cp -f "$script_dir/../Cross-Platform/Chatterino/default-notification.mp3" "$HOME/Audio/SFX/Notifications/Metroid-Data-Received.mp3"
cp -f "$script_dir/../Cross-Platform/Chatterino/jerma-notification.wav" "$HOME/Audio/SFX/Notifications/Jerma-UWU.wav"

settings=$(cat "$script_dir/../Cross-Platform/Chatterino/settings.json")

settings="${settings//jerma-notification-path-here/$HOME\/Audio\/SFX\/Notifications\/Jerma-UWU.wav}"
settings="${settings//default-notification-path-here/$HOME\/Audio\/SFX\/Notifications\/Metroid-Data-Received.wav}"
settings="${settings//imgur-client-id-here/$imgurClientID}"

confPath="$HOME/.config/Chatterino2/Settings"

mkdir -p "$confPath"

rsync -av --exclude='default-notification.mp3' --exclude='jerma-notification.wav' "$script_dir/../Cross-Platform/Chatterino/" "$confPath/"

echo "$settings" > "$confPath/settings.json"

if command -v syncthing >/dev/null 2>&1; then
	echo -e '*.json.bkp-*\n*.json.??????' > "$confPath/.stignore"
	syncthing cli config folders add --id 'axgjf-shqtw' --label 'Chatterino' --path "$confPath"
fi
