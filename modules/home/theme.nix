# Font configuration — applied to all desktop users
{ lib, config, pkgs, ... }:

{ 
  fonts = {
    fontconfig = { 
      enable = true;
      defaultFonts = {
        serif = [ "Libre Baskerville" ];
        sansSerif = [ "Inter" ];
        monospace = [ "JetBrainsMono Nerd Font" ];
      };
    };
  };
}