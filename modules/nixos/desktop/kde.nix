# KDE Plasma 6 desktop environment (INACTIVE TEMPLATE)
# To activate: set desktopEnvironment = "kde" in modules/nixos/desktop/default.nix
# TODO: populate kdeApps list if this is ever used
{ pkgs, ... }:

let
  kdeApps = with pkgs; [
  
  ];
in
{
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  environment.systemPackages = kdeApps;

  services.displayManager.sddm.settings = {
    Theme = {
      CursorTheme = "Bibata-Original-Classic";
    };
  };

  programs.kdeconnect.enable = true;
}
