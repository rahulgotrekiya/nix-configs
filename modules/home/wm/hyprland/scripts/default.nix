# modules/home/wm/hyprland/scripts/default.nix
{ config, lib, pkgs, ... }:

let
  scriptDeps = with pkgs; [
    # General dependencies
    bash
    glib # for gsettings
    jq
    libnotify # for notify-send
    
    # Clipboard dependencies
    cliphist
    wtype
    wl-clipboard
    
    # Bluetooth dependencies
    bluez
    
    # Screenshot dependencies
    grimblast
    swappy
    
    # Gaming mode dependencies
    waybar
    
    # Hyprland utils
    hyprland
  ];

  scriptsDir = "${config.home.homeDirectory}/.local/bin";

  mkScript = name: text: pkgs.writeTextFile {
    inherit name;
    executable = true;
    destination = "/${name}";
    text = text;
  };

  clipboard_manager = mkScript "clipboard-manager" (builtins.readFile ./clipboard-manager.sh);
  gamemode_script = mkScript "gamemode.sh" (builtins.readFile ./gamemode.sh);
  rofi_bluetooth = mkScript "rofi-bluetooth" (builtins.readFile ./rofi-bluetooth.sh);
  screenshot_script = mkScript "screenshot" (builtins.readFile ./screenshot.sh);
  windowpin_script = mkScript "windowpin.sh" (builtins.readFile ./windowpin.sh);
in 

{
  home.packages = scriptDeps;

  home.file = {
    "${scriptsDir}/clipboard-manager".source = "${clipboard_manager}/clipboard-manager";
    "${scriptsDir}/gamemode.sh".source = "${gamemode_script}/gamemode.sh";
    "${scriptsDir}/rofi-bluetooth".source = "${rofi_bluetooth}/rofi-bluetooth";
    "${scriptsDir}/screenshot".source = "${screenshot_script}/screenshot";
    "${scriptsDir}/windowpin.sh".source = "${windowpin_script}/windowpin.sh";

    ".local/bin/.keep".text = "";
  };

  home.sessionVariables = {
    PATH = "${scriptsDir}:$PATH";
  };
}
