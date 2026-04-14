# Hyprland home-manager aggregator — wallpaper, hypr config, waybar, scripts, dunst
{ ... }:

{
  imports = [
    ./wallpaper.nix
    ./hypr
    ./waybar
    ./scripts
    ./dunst.nix
  ];  
}

