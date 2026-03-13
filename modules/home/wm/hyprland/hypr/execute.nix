{ config, lib, pkgs, ... }:

{ 
  wayland.windowManager.hyprland.settings = {
    # Startup programs
    exec-once = [
      "launch-waybar"
      "wl-paste --type text --watch cliphist store"
      "wl-paste --type image --watch cliphist store"
      "powernotd"
      "hyprpaper"
      "pypr"
      "hyprctl setcursor \"Bibata-Original-Classic\" 35"
    ];

    exec = [
      "gsettings set org.gnome.desktop.interface cursor-theme \"Bibata-Original-Classic\""
      "gsettings set org.gnome.desktop.interface cursor-size 35"
      "gsettings set org.gnome.desktop.interface color-scheme \"prefer-dark\""
    ];
  };
}