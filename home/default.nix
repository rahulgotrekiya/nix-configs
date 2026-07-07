# Home Manager entry point
{ config, pkgs, ... }:

{
  imports = [
    ./shell.nix
    ./programs
    ./packages.nix
  ];

  home.username      = "rahul";
  home.homeDirectory = "/home/rahul";

  # Must match the NixOS stateVersion of the fresh install
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;

  # comma — run any nixpkgs binary without installing it
  # Usage: , cowsay hello   , htop   , neofetch
  programs.nix-index-database.comma.enable = true;
}
