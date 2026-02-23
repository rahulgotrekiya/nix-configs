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
