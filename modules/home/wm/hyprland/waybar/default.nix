{ config, lib, pkgs, ... }:

{
  imports = [
    ./config.nix
    ./style.nix
  ];

  home.packages = with pkgs; [
    networkmanagerapplet # For nm-applet
    pavucontrol         # For audio control
    (writeScriptBin "launch-waybar" ''
      #!${pkgs.bash}/bin/bash
      ${pkgs.psmisc}/bin/killall -9 waybar
      ${pkgs.waybar}/bin/waybar &
    '')
  ];

  # Create script directories
  home.file = {
    ".config/waybar/scripts" = {
      source = ./scripts;
      recursive = true;
      executable = true;
    };
  };

  programs.waybar = {
    enable = true;
    systemd.enable =false;
  };
}