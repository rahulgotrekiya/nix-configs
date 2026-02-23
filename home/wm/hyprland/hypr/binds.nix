{ config, pkgs, ... }:

{
  wayland.windowManager.hyprland.settings = {
    # Main mod key
    "$mainMod" = "SUPER";
    "$omenKey" = "XF86Launch2";
    "$calcKey" = "XF86Calculator";

    # Mouse keys
    "$LMB" = "mouse:272";
    "$RMB" = "mouse:273";
    "$mouseSide1" = "mouse:275";
    "$mouseSide2" = "mouse:276";

    # Program variables
    "$term" = "kitty";
    "$scrPath" = "$HOME/.local/bin";

    bind = [
      # Terminal and applications
      "$mainMod, Return, exec, $term"
      "$mainMod SHIFT, Return, exec, alacritty"
      "$mainMod, Q, killactive"
      "$mainMod, T, togglefloating"
      "$mainMod, D, fullscreen"
      "$mainMod SHIFT, E, exec, nautilus"
      "$mainMod SHIFT, Delete, exit"

      "SUPER, N, exec, swaync-client -t -sw" 
      "SUPER SHIFT, N, exec, swaync-client -C -sw"
      "SUPER CTRL, N, exec, swaync-client -d -sw"

      # Custom scripts
      "$mainMod, G, exec, pkill waybar || waybar"
      "$mainMod SHIFT, T, exec, hyprctl dispatch workspaceopt allfloat"
      "$mainMod SHIFT, P, exec, $scrPath/windowpin.sh"
      "$mainMod Alt, G, exec, $scrPath/gamemode.sh"

      # Rofi menu
      "$mainMod, B, exec, pkill -x rofi || $scrPath/rofi-bluetooth"
      "$mainMod, V, exec, pkill -x rofi || $scrPath/clipboard-manager -c"
      "$mainMod SHIFT, V, exec, pkill -x rofi || $scrPath/clipboard-manager -d"
      "$mainMod ALT, V, exec, pkill -x rofi || $scrPath/clipboard-manager -w"
      "$mainMod, space, exec, pkill -x rofi || rofi -show drun -font \"JetBrains Mono Nerd Font Semi-Bold 16\""

      # Run on dedicated GPU
      "$mainMod, $calcKey, exec, prime-run code"
      "$mainMod, P, exec, prime-run firefox"
      "$mainMod, O, exec, prime-run obsidian"
      "$mainMod, $omenKey, exec, prime-run firefox"
      ", $calcKey, exec, prime-run obsidian"
      ", $omenKey, exec, flatpak run app.zen_browser.zen"

      # Window focus with vim bindings
      "$mainMod, h, movefocus, l"
      "$mainMod, l, movefocus, r"
      "$mainMod, k, movefocus, u"
      "$mainMod, j, movefocus, d"

     # Window focus with arrow keys
      "$mainMod, left, movefocus, l"
      "$mainMod, right, movefocus, r"
      "$mainMod, up, movefocus, u"
      "$mainMod, down, movefocus, d"

      # Window movement
      "$mainMod SHIFT, H, movewindow, l"
      "$mainMod SHIFT, L, movewindow, r"
      "$mainMod SHIFT, K, movewindow, u"
      "$mainMod SHIFT, J, movewindow, d"

      "$mainMod control, L, moveactive, 40 0"
      "$mainMod control, H, moveactive, -40 0"
      "$mainMod control, K, moveactive, 0 -40"
      "$mainMod control, J, moveactive, 0 40"

      # Workspace switching
      "$mainMod, 1, workspace, 1"
      "$mainMod, 2, workspace, 2"
      "$mainMod, 3, workspace, 3"
      "$mainMod, 4, workspace, 4"
      "$mainMod, 5, workspace, 5"
      "$mainMod, 6, workspace, 6"
      "$mainMod, 7, workspace, 7"
      "$mainMod, 8, workspace, 8"
      "$mainMod, 9, workspace, 9"
      "$mainMod, 0, workspace, 10"

      # Move windows to workspaces
      "$mainMod SHIFT, 1, movetoworkspace, 1"
      "$mainMod SHIFT, 2, movetoworkspace, 2"
      "$mainMod SHIFT, 3, movetoworkspace, 3"
      "$mainMod SHIFT, 4, movetoworkspace, 4"
      "$mainMod SHIFT, 5, movetoworkspace, 5"
      "$mainMod SHIFT, 6, movetoworkspace, 6"
      "$mainMod SHIFT, 7, movetoworkspace, 7"
      "$mainMod SHIFT, 8, movetoworkspace, 8"
      "$mainMod SHIFT, 9, movetoworkspace, 9"
      "$mainMod SHIFT, 0, movetoworkspace, 10"

      # Special workspace handling
      "$mainMod, A, togglespecialworkspace, magic"
      "$mainMod SHIFT, A, movetoworkspace, special:magic"
      "$mainMod, X, togglespecialworkspace, magic1"
      "$mainMod SHIFT, X, movetoworkspace, special:magic1"

      # Workspace navigation with scroll/keys
      "$mainMod, mouse_up, workspace, e+1"
      "$mainMod, mouse_down, workspace, e-1"
      "$mainMod, page_down, workspace, e+1"
      "$mainMod, page_up, workspace, e-1"
      "$mainMod, F, workspace, e+1"
      "$mainMod, S, workspace, e-1"
      "Ctrl ALT, right, workspace, e+1"
      "Ctrl ALT, left, workspace, e-1"

      # Window movement between workspaces
      "$mainMod+Ctrl+Alt, Right, movetoworkspace, r+1"
      "$mainMod+Ctrl+Alt, Left, movetoworkspace, r-1"

      # Center floating window
      "$mainMod, C, centerwindow"

      # Move to empty workspace
      "$mainMod, E, workspace, empty"

      # Window cycling
      "SUPER, Tab, cyclenext"
      "SUPER, Tab, bringactivetotop"

      # Mouse button binds
      "$mainMod, $mouseSide1, workspace, e+1"
      "$mainMod, $mouseSide2, workspace, e-1"
      "$mainMod SHIFT, $mouseSide1, movetoworkspace, r+1"
      "$mainMod SHIFT, $mouseSide2, movetoworkspace, r-1"

      # Brightness controls
      "ALT, $mouseSide2, exec, brightnessctl set +5%"
      "ALT, $mouseSide1, exec, brightnessctl set 5%-"
      ",XF86MonBrightnessUp, exec, brightnessctl set +5%"
      ",XF86MonBrightnessDown, exec, brightnessctl set 5%-"

      # Volume controls
      "Ctrl, $mouseSide2, exec, pactl set-sink-volume @DEFAULT_SINK@ +5%"
      "Ctrl, $mouseSide1, exec, pactl set-sink-volume @DEFAULT_SINK@ -5%"
      ", XF86AudioMute, exec, pactl set-sink-mute @DEFAULT_SINK@ toggle"

      # Screenshot
      ", Print, exec, $scrPath/screenshot p"
      "SHIFT, Print, exec, $scrPath/screenshot s"
      "CTRL, Print, exec, $scrPath/screenshot sf"
      "$mainMod, Print, exec, $scrPath/screenshot"
      "$mainMod SHIFT, Print, exec, $scrPath/screenshot v"

      # Color picker
      "$mainMod SHIFT, C, exec, hyprpicker -a"
      
      "ALT, LEFT, resizeactive, -50 0"
      "ALT, RIGHT, resizeactive, 50 0"
      "ALT, UP, resizeactive, 0 -50"
      "ALT, DOWN, resizeactive, 0 50"
      "ALT, H, resizeactive, -50 0"
      "ALT, L, resizeactive, 50 0"
      "ALT, K, resizeactive, 0 -50"
      "ALT, J, resizeactive, 0 50"
    ];

    # Special bindings (bindl, binde, etc.)
    bindl = [
      ", XF86AudioMute, exec, pactl set-sink-mute @DEFAULT_SINK@ toggle"
      ", XF86AudioPlay, exec, playerctl play-pause"
      ", XF86AudioPause, exec, playerctl play-pause"
      ", XF86AudioNext, exec, playerctl next"
      ", XF86AudioPrev, exec, playerctl previous"
    ];

    bindle = [
      ", XF86AudioRaiseVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ +5%"
      ", XF86AudioLowerVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ -5%"
      ",XF86MonBrightnessUp, exec, brightnessctl set +5%"
      ",XF86MonBrightnessDown, exec, brightnessctl set 5%-"
      "ALT, $mouseSide2, exec, brightnessctl set +5%"
      "ALT, $mouseSide1, exec, brightnessctl set 5%-"
    ];

    binde = [
      "ALT, $mouseSide2, exec, brightnessctl set +5%"
      "ALT, $mouseSide1, exec, brightnessctl set 5%-"
    ];

    # Move/resize with mouse
    bindm = [
      "$mainMod, $LMB, movewindow"
      "$mainMod, $RMB, resizewindow"
    ];
  };
}
