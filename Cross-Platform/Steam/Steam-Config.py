import vdf
import argparse
import glob
import os

def print_keys_recursively(d, parent_key=''):
    if isinstance(d, dict):
        for key, value in d.items():
            full_key = f"[\"{parent_key.strip("\"[]")}\"][\"{key}\"]" if parent_key else key
            print(full_key)
            print_keys_recursively(value, full_key)

def update_vdf_dict(vdf_dict, tweaks):
    for key, value in tweaks.items():
        if isinstance(value, dict):
            if key not in vdf_dict:
                vdf_dict[key] = vdf.VDFDict()
            update_vdf_dict(vdf_dict[key], value)
        else:
            vdf_dict.remove_all_for(key)
            vdf_dict[key] = value

def edit_install_config(install_config_path):
    config_string = open(install_config_path, encoding='utf-8').read()
    config = vdf.loads(config_string, mapper=vdf.VDFDict)
    config_tweaks = {
        "InstallConfigStore": {
            "Software": {
                "Valve": {
                    "Steam": {
                        "DownloadThrottleKbps": "20000"
                    }
                }
            }
        }
    }
    update_vdf_dict(config, config_tweaks)
    vdf.dump(config, open(install_config_path, 'w', encoding='utf-8'), pretty=True)
    # print_keys_recursively(config)

def edit_local_config(localconfig_path):
    config_string = open(localconfig_path, encoding='utf-8').read()
    config = vdf.loads(config_string, mapper=vdf.VDFDict)
    config_tweaks = {
        "UserLocalConfigStore": {
            "friends": {
                "ChatFlashMode": "0",
                "DoNotDisturb": "0",
                "Notifications_ShowIngame": "0",
                "Notifications_ShowOnline": "0",
                "Notifications_ShowMessage": "1",
                "Notifications_EventsAndAnnouncements": "1",
                "SignIntoFriends": "1",
                "Sounds_PlayIngame": "0",
                "Sounds_PlayOnline": "0",
                "Sounds_PlayMessage": "1",
                "Sounds_EventsAndAnnouncements": "0"
            },
            "news": {
                "NotifyAvailableGames": "0"
            },
            "system": {
                "displayratesasbits": "0",
                "JumplistSettings": "12112",
                "JumplistSettingsKnown": "262143",
                "GameOverlayHomePage": "https://duckduckgo.com"
            }
        }
    }
    update_vdf_dict(config, config_tweaks)
    vdf.dump(config, open(localconfig_path, 'w', encoding='utf-8'), pretty=True)
    # print_keys_recursively(config)

def edit_shared_config(sharedconfig_path):
    config_string = open(sharedconfig_path, encoding='utf-8').read()
    config = vdf.loads(config_string, mapper=vdf.VDFDict)
    config_tweaks = {
        "UserRoamingConfigStore" : {
            "Software": {
                "Valve": {
                    "Steam": {
                        "SteamDefaultDialog": "#app_games"
                    }
                }
            }
        }
    }
    update_vdf_dict(config, config_tweaks)
    vdf.dump(config, open(sharedconfig_path, 'w', encoding='utf-8'), pretty=True)
    # print_keys_recursively(config)

def main():
    parser = argparse.ArgumentParser(description='Edits Steam configuration files.')
    parser.add_argument('steampath', type=str, help='Path to Steam folder containing config & userdata folders.')
    args = parser.parse_args()

    print(f"Editing Steam config files in {args.steampath}")

    install_config_path = os.path.join(args.steampath, "config", "config.vdf")
    edit_install_config(install_config_path)

    localconfig_paths = glob.glob(os.path.join(args.steampath, "userdata", "*", "config", "localconfig.vdf"))

    if not localconfig_paths:
        print("No localconfig.vdf found.")

    for localconfig_path in localconfig_paths:
        print(f"Editing {localconfig_path}")
        edit_local_config(localconfig_path)

    sharedconfig_paths = glob.glob(os.path.join(args.steampath, "userdata", "*", "*", "remote", "sharedconfig.vdf"))

    if not sharedconfig_paths:
        print("No sharedconfig.vdf found.")

    for sharedconfig_path in sharedconfig_paths:
        print(f"Editing {sharedconfig_path}")
        edit_shared_config(sharedconfig_path)

if __name__ == "__main__":
    main()
