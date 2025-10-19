#!/usr/bin/env bash

# https://spicetify.app/docs/advanced-usage/installation/#spotify-installed-from-flatpak
if command -v flatpak &> /dev/null && flatpak list --columns=application | grep -Fq com.spotify.Client; then
	potential_spotify_paths=(
		"$(dirname "$(flatpak info --show-location --user com.spotify.Client 2> /dev/null)")/active/files/extra/share/spotify"
		"$(dirname "$(flatpak info --show-location --system com.spotify.Client 2> /dev/null)")/active/files/extra/share/spotify"
	)

	for spotify_path in "${potential_spotify_paths[@]}"; do
		if [[ -d $spotify_path ]]; then
			echo "Using spotify_path: $spotify_path"
			spicetify config spotify_path "$spotify_path"
			[[ ! -w $spotify_path ]] && sudo chmod a+wr "$spotify_path"
			[[ ! -w "$spotify_path/Apps" ]] && sudo chmod a+wr -R "$spotify_path/Apps"
		fi
	done

	potential_prefs_paths=(
		~/.config/spotify/prefs
		~/.var/app/com.spotify.Client/config/spotify/prefs
	)

	for prefs_path in "${potential_prefs_paths[@]}"; do
		if [[ -f $prefs_path ]]; then
			echo "Using prefs_path: $prefs_path"
			spicetify config prefs_path "$prefs_path"
		fi
	done
fi

spicetify config always_enable_devtools 1
spicetify config check_spicetify_update 1
spicetify config disable_sentry 1
spicetify config disable_ui_logging 1
spicetify config experimental_features 1
spicetify config expose_apis 1
spicetify config inject_css 1
spicetify config remove_rtl_rule 1
spicetify config replace_colors 1
spicetify config sidebar_config 1

spicetifyConfigDir=~/.config/spicetify

mkdir -p "$spicetifyConfigDir/CustomApps" "$spicetifyConfigDir/Extensions"

function get_latest_release_asset_url {
	local repo="$1"
	local pattern="$2"
	local releases_json
	local url
	releases_json=$(curl -s "https://api.github.com/repos/$repo/releases")
	url=$(echo "$releases_json" | yq -r '.[] | .assets[] | select(.name | test("'"$pattern"'")) | .browser_download_url' | head -n 1)

	if [[ -z $url || $url = 'null' ]]; then
		echo ""
	else
		echo "$url"
	fi
}

# Library custom app
libraryUrl=$(get_latest_release_asset_url "harbassan/spicetify-apps" "spicetify-library\.release\.zip")
if [ -n "$libraryUrl" ]; then
	echo "Installing 'Library' custom app to $spicetifyConfigDir/CustomApps"
	curl -fsSL "$libraryUrl" -o library.zip
	unzip -qo library.zip && rm -f library.zip
	[ -d "$spicetifyConfigDir/CustomApps/library" ] && rm -rf "$spicetifyConfigDir/CustomApps/library"
	mv library "$spicetifyConfigDir/CustomApps"
	spicetify config custom_apps library
else
	echo "Couldn't download library custom app." >&2
fi

# Stats custom app
statsUrl=$(get_latest_release_asset_url "harbassan/spicetify-apps" "spicetify-stats\.release\.zip")
if [ -n "$statsUrl" ]; then
	echo "Installing 'Stats' custom app to $spicetifyConfigDir/CustomApps"
	curl -fsSL "$statsUrl" -o stats.zip
	unzip -qo stats.zip && rm -f stats.zip
	[ -d "$spicetifyConfigDir/CustomApps/stats" ] && rm -rf "$spicetifyConfigDir/CustomApps/stats"
	mv stats "$spicetifyConfigDir/CustomApps"
	spicetify config custom_apps stats
else
	echo "Couldn't download stats custom app." >&2
fi

# Playlist Tags custom app
echo "Installing 'Playlist Tags' custom app to $spicetifyConfigDir/CustomApps"
curl -fsSL -o playlist-tags.zip https://github.com/Bergbok/Spicetify-Creations/archive/refs/heads/dist/playlist-tags.zip
unzip -qo playlist-tags.zip && rm -f playlist-tags.zip
mkdir -p playlist-tags
cp -r Spicetify-Creations-dist-playlist-tags/* playlist-tags
rm -rf Spicetify-Creations-dist-playlist-tags
[ -d "$spicetifyConfigDir/CustomApps/playlist-tags" ] && rm -rf "$spicetifyConfigDir/CustomApps/playlist-tags"
mv playlist-tags "$spicetifyConfigDir/CustomApps/"
spicetify config custom_apps playlist-tags

# History in Sidebar custom app
echo "Installing 'History in Sidebar' custom app to $spicetifyConfigDir/CustomApps"
curl -fsSL -o history-in-sidebar.zip https://github.com/Bergbok/Spicetify-Creations/archive/refs/heads/dist/history-in-sidebar.zip
unzip -qo history-in-sidebar.zip && rm -f history-in-sidebar.zip
mkdir -p history-in-sidebar
cp -r Spicetify-Creations-dist-history-in-sidebar/* history-in-sidebar
rm -rf Spicetify-Creations-dist-history-in-sidebar
[ -d "$spicetifyConfigDir/CustomApps/history-in-sidebar" ] && rm -rf "$spicetifyConfigDir/CustomApps/history-in-sidebar"
mv history-in-sidebar "$spicetifyConfigDir/CustomApps"
spicetify config custom_apps history-in-sidebar

# Marketplace custom app
echo "Installing 'Marketplace' custom app to $spicetifyConfigDir/CustomApps"
curl -fsSL "https://github.com/spicetify/marketplace/releases/latest/download/marketplace.zip" -o marketplace.zip
unzip -qo marketplace.zip && rm -f marketplace.zip
[ -d "$spicetifyConfigDir/CustomApps/marketplace" ] && rm -rf "$spicetifyConfigDir/CustomApps/marketplace"
mv marketplace-dist "$spicetifyConfigDir/CustomApps/marketplace"
spicetify config custom_apps marketplace

spicetify config custom_apps lyrics-plus

echo "Installing 'Auto Skip Tracks by Duration' extension to $spicetifyConfigDir/Extensions"
curl -fsSL -o "$spicetifyConfigDir/Extensions/auto-skip-tracks-by-duration.js" "https://raw.githubusercontent.com/Bergbok/Spicetify-Creations/refs/heads/dist/auto-skip-tracks-by-duration/auto-skip-tracks-by-duration.js"
spicetify config extensions auto-skip-tracks-by-duration.js

spicetify backup apply
