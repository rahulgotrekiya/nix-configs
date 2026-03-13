# Window Manager configuration
{ config, pkgs, ... }:

let
  # Change this to switch between window managers
  # Options: "hyprland", "i3", "none" (for no window manager)
  windowManager = "hyprland";
in
{
  # Import the appropriate window manager configuration
  imports = [
    (./wm + "/${windowManager}.nix")
  ];

  # Common packages useful for window managers
  environment.systemPackages = with pkgs; [
  ];
}