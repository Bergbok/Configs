## [Setup.sh](./Setup.sh)

> [!WARNING]  
> Work in progress!

Supports Arch-based systems using the systemd init system.

### Usage

```bash
curl -fsSL -o Configs.zip https://github.com/Bergbok/Configs/archive/refs/heads/main.zip
unzip -q -o Configs.zip -d Configs
rm Configs.zip
cd Configs/Configs-main/Linux
nano .env
chmod +x Setup.sh
./Setup.sh
```

### Development

for sorting [packages.yml](./packages.yml) alphabetically:
```bash
yq -i 'sort_by(.name | downcase)' packages.yml && awk 'BEGIN { first=1 } /^- name:/ { if (!first) print ""; first=0 } { print }' packages.yml > temp && mv temp packages.yml
```

for finding things to work on in [packages.yml](./packages.yml):
```bash
yq '.[] | select(.tags == null)' packages.yml
```
```regex
description:.*\.
url:.*\/$
```

#### Package Tags

- artificial intelligence
- command line
- compatibility
- compression
- database
- development
- disk analysis
- editors
- emulators
- file transfer
- fonts
- fun
- gaming
- hardware control
- media creation
- modding
- networking
- quality of life
- ricing
- social
- standard tool replacements
- system monitors
- terminal emulators
- viewers
- virtualization

<!--
https://archlinux.org/packages
https://aur.archlinux.org/packages
https://flathub.org
https://packages.debian.org
https://packages.fedoraproject.org
-->
