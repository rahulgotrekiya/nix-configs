{ config, pkgs, ... }:

{
  imports = [
    ./shell.nix
    ./themes/theme.nix
    ./packages.nix
    ./programs
    ./desktop
    ./wm
  ];

  home.username = "rahul";
  home.homeDirectory = "/home/rahul";
  home.stateVersion = "24.05";

  home.sessionVariables = {
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
  };

  programs.home-manager.enable = true;
  programs.zsh.enable = true;
}
