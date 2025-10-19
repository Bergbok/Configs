#!/usr/bin/env bash

set -eu

		 SCRIPT_DIR=$(dirname "$(realpath "$0")")
readonly SCRIPT_DIR

set -a
source "$SCRIPT_DIR/../.env"
set +a

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

	if command -v xclip &>/dev/null; then
		printf "%s" "$pubkey" | xclip -selection clipboard
	elif command -v wl-copy &>/dev/null; then
		printf "%s" "$pubkey" | wl-copy
	fi

	xdg-open 'https://github.com/settings/gpg/new'
else
	echo "Could not extract GPG key fingerprint from gpg output." >&2
fi
