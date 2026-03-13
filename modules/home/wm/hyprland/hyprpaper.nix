{ config, pkgs, ... }:

let
  # Wallpaper path — resolved via Nix store (works regardless of clone location)
  wallpaperPath = builtins.toString ../../../../assets/wallpapers/wall.jpg;
in
{
  services.hyprpaper = {
    enable = true;
    settings = {
      splash_offset = 2;
      splash = false;
      preload = [
        wallpaperPath
      ];
      wallpaper = [{
        monitor = "";
        path = wallpaperPath;
      }];
    };
  };
}