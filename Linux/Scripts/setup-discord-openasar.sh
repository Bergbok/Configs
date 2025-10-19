#!/usr/bin/env bash

asar_url=https://github.com/GooseMod/OpenAsar/releases/latest/download/app.asar
success=0

[[ -f /opt/discord/resources/app.asar ]] && sudo curl -fsSL -o /opt/discord/resources/app.asar "$asar_url" && success=1

for path in ~/.local/share/flatpak/app/com.discordapp.Discord/x86_64/stable/*/files/discord/resources/app.asar; do
	[[ -f $path ]] && curl -fsSL -o "$path" "$asar_url" && success=1
done

[[ $success -eq 0 ]] && echo 'Discord OpenAsar could not be installed.' >&2
