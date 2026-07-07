{ pkgs, ... }:

{
  programs.alacritty = {
    enable = true;

    settings = {
      env = {
        TERM                   = "xterm-256color";
        WINIT_X11_SCALE_FACTOR = "1.0";
      };

      window = {
        padding        = { x = 20; y = 10; };
        dimensions     = { columns = 120; lines = 29; };
        dynamic_padding = true;
        dynamic_title   = true;
        blur            = true;
        decorations     = "full";
      };

      cursor = {
        style = {
          shape    = "Block";
          blinking = "On";
        };
        blink_interval = 550;
      };

      terminal.shell.program = "${pkgs.zsh}/bin/zsh";

      keyboard.bindings = [
        {
          key    = "Return";
          mods   = "Control|Shift";
          action = "SpawnNewInstance";
        }
      ];

      font = {
        normal  = { family = "JetBrainsMono Nerd Font"; style = "Regular"; };
        bold    = { family = "JetBrainsMono Nerd Font"; style = "Bold"; };
        italic  = { family = "JetBrainsMono Nerd Font"; style = "Italic"; };
        size    = 16.0;
      };

      colors = {
        draw_bold_text_with_bright_colors = false;
        primary = {
          background = "#1a1b26";
          foreground = "#a9b1d6";
        };
        cursor = {
          text   = "#1E1E2E";
          cursor = "#F5E0DC";
        };
        normal = {
          black   = "#32344a";
          red     = "#f7768e";
          green   = "#9ece6a";
          yellow  = "#e0af68";
          blue    = "#7aa2f7";
          magenta = "#ad8ee6";
          cyan    = "#449dab";
          white   = "#787c99";
        };
        bright = {
          black   = "#444b6a";
          red     = "#ff7a93";
          green   = "#b9f27c";
          yellow  = "#ff9e64";
          blue    = "#7da6ff";
          magenta = "#bb9af7";
          cyan    = "#0db9d7";
          white   = "#acb0d0";
        };
      };
    };
  };
}
