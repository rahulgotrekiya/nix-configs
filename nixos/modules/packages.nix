{ config, pkgs, ... }:

{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    neovim
    git
    fastfetch
    btop
    tree
    vscodium
    bibata-cursors
    dosbox
    gcc
    docker-compose
    awscli
    easyeffects
  ];

  # HP Victus uses Intel HDA with SOF (Sound Open Firmware)
  hardware.firmware = with pkgs; [ sof-firmware ];
  
  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
}
