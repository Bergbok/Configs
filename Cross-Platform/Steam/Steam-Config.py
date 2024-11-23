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

def edit_install_config(install_config_path):
    config_string = open(install_config_path, encoding='utf-8').read()
    config = vdf.loads(config_string, mapper=vdf.VDFDict)
    config["InstallConfigStore"]["Software"]["Valve"]["Steam"]["DownloadThrottleKbps"] = "20000"
    print_keys_recursively(config)

def edit_local_config(localconfig_path):
    config_string = open(localconfig_path, encoding='utf-8').read()
    config = vdf.loads(config_string, mapper=vdf.VDFDict)
    config["UserLocalConfigStore"]["friends"]["Notifications_ShowIngame"] = "0"
    config["UserLocalConfigStore"]["friends"]["Notifications_ShowOnline"] = "0"
    config["UserLocalConfigStore"]["friends"]["Notifications_ShowMessage"] = "1"
    config["UserLocalConfigStore"]["friends"]["Notifications_EventsAndAnnouncements"] = "1"
    config["UserLocalConfigStore"]["friends"]["Sounds_PlayIngame"] = "0"
    config["UserLocalConfigStore"]["friends"]["Sounds_PlayOnline"] = "0"
    config["UserLocalConfigStore"]["friends"]["Sounds_PlayMessage"] = "1"
    config["UserLocalConfigStore"]["friends"]["Sounds_EventsAndAnnouncements"] = "0"
    config["UserLocalConfigStore"]["friends"]["ChatFlashMode"] = "0"
    config["UserLocalConfigStore"]["friends"]["DoNotDisturb"] = "0"
    config["UserLocalConfigStore"]["friends"]["SignIntoFriends"] = "1"
    config["UserLocalConfigStore"]["system"]["JumplistSettings"] = "12112"
    config["UserLocalConfigStore"]["system"]["JumplistSettingsKnown"] = "262143"
    config["UserLocalConfigStore"]["system"]["displayratesasbits"] = "0"
    config["UserLocalConfigStore"]["system"]["GameOverlayHomePage"] = "https://duckduckgo.com"
    config["UserLocalConfigStore"]["news"]["NotifyAvailableGames"] = "0"
    # vdf.dump(config, open(localconfig_path, 'w', encoding='utf-8'), pretty=True)
    # print_keys_recursively(config)

def edit_shared_config(sharedconfig_path):
    config_string = open(sharedconfig_path, encoding='utf-8').read()
    config = vdf.loads(config_string, mapper=vdf.VDFDict)
    config["UserRoamingConfigStore"]["Software"]["Valve"]["Steam"]["SteamDefaultDialog"] = "#app_games"
    # vdf.dump(config, open(sharedconfig_path, 'w', encoding='utf-8'), pretty=True)
    # print_keys_recursively(config)
    
def main():
    parser = argparse.ArgumentParser(description='Edits Steam localconfig configuration file.')
    parser.add_argument('steampath', type=str, help='Path to folder containing Steam executable folder.')
    args = parser.parse_args()
    
    install_config_path = os.path.join(args.steampath, r"config\config.vdf")
    edit_install_config(install_config_path)
    
    localconfig_paths = glob.glob(os.path.join(args.steampath, r"userdata\*\config\localconfig.vdf"))

    if not localconfig_paths:
        print("No localconfig.vdf found.")
    
    for localconfig_path in localconfig_paths:
        edit_local_config(localconfig_path)

    sharedconfig_paths = glob.glob(os.path.join(args.steampath, r"userdata\*\*\remote\sharedconfig.vdf"))

    if not sharedconfig_paths:
        print("No sharedconfig.vdf found.")
    
    for sharedconfig_path in sharedconfig_paths:
        edit_shared_config(sharedconfig_path)

if __name__ == "__main__":
    main()
