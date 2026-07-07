{ config, lib, pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    shellIntegration.mode = "no-cursor";
    
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 16.0;
    };
    
    settings = {
      cursor_shape = "block";
      bold_font = "auto";
      italic_font = "auto";
      bold_italic_font = "auto";
      enable_audio_bell = "no";
      window_padding_width = 15;
      hide_window_decorations = "yes";
      confirm_os_window_close = 0;
      allow_remote_control = "yes";
      listen_on = "unix:/tmp/mykitty";
    };
    
    # Tokyo Night theme
    extraConfig = ''
      foreground #a9b1d6
      background #1a1b26
      cursor #a9b1d6
      
      color0 #1a1b26
      color8 #4e5173
      
      color1 #F7768E
      color9 #F7768E
      
      color2 #9ECE6A
      color10 #9ECE6A
      
      color3 #E0AF68
      color11 #E0AF68
      
      color4 #7AA2F7
      color12 #7AA2F7
      
      color5 #9a7ecc
      color13 #9a7ecc
      
      color6 #4abaaf
      color14 #4abaaf
      
      color7 #acb0d0
      color15 #acb0d0
    '';
  };
}