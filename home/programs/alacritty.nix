{ pkgs, ... }:

let
  colors = import ../themes/colors.nix;
in
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
          background = colors.bg;
          foreground = colors.fg;
        };
        cursor = {
          text   = "#1E1E2E";
          cursor = "#F5E0DC";
        };
        normal = {
          black   = colors.black;
          red     = colors.red;
          green   = colors.green;
          yellow  = colors.yellow;
          blue    = colors.blue;
          magenta = colors.magenta;
          cyan    = colors.cyan;
          white   = colors.white;
        };
        bright = {
          black   = colors.brightBlack;
          red     = colors.brightRed;
          green   = colors.brightGreen;
          yellow  = colors.brightYellow;
          blue    = colors.brightBlue;
          magenta = colors.brightMagenta;
          cyan    = colors.brightCyan;
          white   = colors.brightWhite;
        };
      };
    };
  };
}
