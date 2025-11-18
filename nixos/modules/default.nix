{ config, pkgs, ... }:

{
  imports = [
    ./system.nix
    ./services.nix
    ./packages.nix
    ./users.nix
    ./networking.nix
    ./flatpak.nix
    ./wm.nix 
    ./kanata.nix
    ./nvidia.nix
    ./filesystems.nix
    ./battery-monitor.nix
    ./desktop    
    ./lamp.nix
    ./vm.nix
    ./docker.nix
  ];
}
