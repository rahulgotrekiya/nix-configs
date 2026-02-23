# Desktop environment and window manager selector
{ config, pkgs, lib, ... }:

let
  desktopEnvironment = "gnome"; # or "kde", or "none"

  gnome = import ./gnome.nix;
  kde = import ./kde.nix;
  common = import ./common.nix;

  selectedDE =
    if desktopEnvironment == "gnome" then gnome
    else if desktopEnvironment == "kde" then kde
    else {};
in
{
  imports = [
    common
    selectedDE
    ./wm.nix
    ./nvidia.nix
  ];

  services.displayManager.autoLogin = {
    enable = false;
    user = "rahul";
  };
}
