# Hyprland settings aggregator — keybinds, animations, window rules, startup, packages
{ ... }:

{
  imports = [
    ./hyprland.nix
    ./binds.nix
    ./packages.nix
    ./execute.nix
    ./windowrules.nix
    ./animations.nix
  ];  
}

