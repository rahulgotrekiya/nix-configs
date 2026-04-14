{ pkgs }:

let
  # Helper: wraps a shell script with runtime dependencies on PATH.
  # Uses writeShellApplication with relaxed bash options so the original
  # scripts (not written for strict mode) keep working.
  mkScript = { name, runtimeInputs, src }:
    pkgs.writeShellApplication {
      inherit name runtimeInputs;
      text = builtins.readFile src;

      # These scripts were not written for strict mode — disable nounset
      # (many use potentially-unset vars) and keep only errexit + pipefail.
      bashOptions = [ "pipefail" ];

      # Suppress shellcheck warnings that the scripts were never meant to follow.
      excludeShellChecks = [
        "SC2034"  # unused variables (intentional config vars)
        "SC2001"  # sed usage
        "SC2086"  # word splitting (intentional in rofi piping)
        "SC2046"  # word splitting in command substitution
        "SC2048"  # $* usage
        "SC2116"  # useless echo
        "SC2199"  # array as string
      ];
    };
in
{
  clipboard-manager = mkScript {
    name = "clipboard-manager";
    runtimeInputs = with pkgs; [
      bash coreutils gnugrep gnused findutils
      cliphist wl-clipboard wtype jq rofi hyprland libnotify
    ];
    src = ./clipboard-manager.sh;
  };

  gamemode = mkScript {
    name = "gamemode";
    runtimeInputs = with pkgs; [
      bash coreutils gnugrep gnused gawk
      hyprland libnotify waybar killall
    ];
    src = ./gamemode.sh;
  };

  rofi-bluetooth = mkScript {
    name = "rofi-bluetooth";
    runtimeInputs = with pkgs; [
      bash coreutils gnugrep gnused gawk
      bluez rofi procps util-linux bc
    ];
    src = ./rofi-bluetooth.sh;
  };

  screenshot = mkScript {
    name = "screenshot";
    runtimeInputs = with pkgs; [
      bash coreutils findutils gnugrep gnused
      grimblast swappy libnotify jq wl-clipboard rofi
      hyprshade xdg-utils
    ];
    src = ./screenshot.sh;
  };

  windowpin = mkScript {
    name = "windowpin";
    runtimeInputs = with pkgs; [
      bash coreutils
      hyprland libnotify jq
    ];
    src = ./windowpin.sh;
  };
}
