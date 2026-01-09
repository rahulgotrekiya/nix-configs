{ config, pkgs, ... }:

{
  services.hyprpaper = {
    enable = true;
    settings = {
      splash_offset = 2;
      splash = false;
      preload = [
        "${config.home.homeDirectory}/dotfiles/home/themes/wallpapers/wall.jpg"
      ];
      wallpaper = [{
        monitor = "";
        path = "${config.home.homeDirectory}/dotfiles/home/themes/wallpapers/wall.jpg";
      }];
    };
  };
}