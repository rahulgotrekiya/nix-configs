# Hyprland home-manager aggregator — hyprpaper, hypr config, waybar, scripts, dunst
{ ... }:

{
  imports = [
    ./hyprpaper.nix
    ./hypr
    ./waybar
    ./scripts
    ./dunst.nix
  ];  
}

