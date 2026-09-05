let
  colors = import ../themes/colors.nix;
in
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
      foreground ${colors.fg}
      background ${colors.bg}
      cursor ${colors.fg}

      color0 ${colors.bg}
      color8 ${colors.brightBlack}

      color1 ${colors.red}
      color9 ${colors.red}

      color2 ${colors.green}
      color10 ${colors.green}

      color3 ${colors.yellow}
      color11 ${colors.yellow}

      color4 ${colors.blue}
      color12 ${colors.blue}

      color5 ${colors.magenta}
      color13 ${colors.magenta}

      color6 ${colors.cyan}
      color14 ${colors.cyan}

      color7 ${colors.brightWhite}
      color15 ${colors.brightWhite}
    '';
  };
}