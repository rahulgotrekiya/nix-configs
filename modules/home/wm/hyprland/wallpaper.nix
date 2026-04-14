{ config, pkgs, ... }:

let
  # Wallpaper path — copied into the Nix store so swww can access it
  wallpaperPath = builtins.path {
    path = ../../../../assets/wallpapers/wall.jpg;
    name = "wall.jpg";
  };
in
{
  # Install swww (now known as awww), the modern Hyprland wallpaper daemon
  home.packages = with pkgs; [ 
    awww 
  ];

  # Disable hyprpaper since it was crashing with backend assertion errors
  services.hyprpaper.enable = false;

  # Auto-start awww and set the wallpaper with a nice fade transition
  wayland.windowManager.hyprland.settings.exec-once = [
    "awww-daemon"
    "sleep 1 && awww img ${wallpaperPath} --transition-type wipe --transition-angle 30 --transition-step 90"
  ];
}