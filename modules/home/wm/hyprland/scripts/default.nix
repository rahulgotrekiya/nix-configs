# modules/home/wm/hyprland/scripts/default.nix
{ pkgs, ... }:

{
  home.packages = with pkgs.custom; [
    clipboard-manager
    gamemode
    rofi-bluetooth
    screenshot
    windowpin
  ];
}
