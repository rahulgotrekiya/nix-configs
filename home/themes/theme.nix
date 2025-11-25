{ libs, config, pkgs, ... }:

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