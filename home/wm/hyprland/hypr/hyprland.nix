{ config, lib, pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    xwayland.enable = true;

    settings = {
      monitor = ",1920x1080@144,auto,1";
      
      # Input configuration
      input = {
        kb_layout = "us";
        numlock_by_default = true;
        follow_mouse = 1;
        
        touchpad = {
          natural_scroll = true;
          disable_while_typing = true;
        };
        
        sensitivity = 0.4; # -1.0 - 1.0, 0 means no modification.
      };
      
      # General configuration
      general = {
        gaps_in = 5;
        gaps_out = 5;
        border_size = 0;
        "col.active_border" = "rgba(ca9ee6ff) rgba(f2d5cfff) 45deg";
        "col.inactive_border" = "rgba(b4befecc) rgba(6c7086cc) 45deg";
        layout = "dwindle";
        resize_on_border = true;
      };
      
      # Group configuration
      group = {
        "col.border_active" = "rgba(ca9ee6ff) rgba(f2d5cfff) 45deg";
        "col.border_inactive" = "rgba(b4befecc) rgba(6c7086cc) 45deg";
        "col.border_locked_active" = "rgba(ca9ee6ff) rgba(f2d5cfff) 45deg";
        "col.border_locked_inactive" = "rgba(b4befecc) rgba(6c7086cc) 45deg";
      };
      
      # Decoration configuration
      decoration = {
        rounding = 5;
        
        blur = {
          enabled = true;
          size = 3;
          passes = 4;
          new_optimizations = true;
          ignore_opacity = false;
          xray = false;
        };
        
        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          color = "rgba(1a1a1aee)";
        };
      };
      
      # Dwindle layout configuration
      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };
      
      # Misc configuration
      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
      };      
    };

    extraConfig = ''
      # NVIDIA-specific environment variables for Hyprland
      env = LIBVA_DRIVER_NAME,iHD
      env = GBM_BACKEND,nvidia-drm
      env = __GLX_VENDOR_LIBRARY_NAME,nvidia
      env = WLR_NO_HARDWARE_CURSORS,1
      
      # Graphics settings (hardware acceleration)
      env = XCURSOR_SIZE,24
      env = WLR_RENDERER,vulkan
      
      # For better performance
      misc {
        vfr = true
        vrr = 1
        disable_hyprland_logo = true
        disable_splash_rendering = true
        mouse_move_enables_dpms = true
        enable_swallow = true
        new_window_takes_over_fullscreen = 2
      }
      
      # NVIDIA GPU rules for graphics performance
      group {
        groupbar {
          font_size = 16
          gradients = false
        }
      }
      
      # Better compatibility with hybrid graphics
      env = XDG_SESSION_TYPE,wayland
      env = QT_QPA_PLATFORM,wayland
      env = QT_WAYLAND_DISABLE_WINDOWDECORATION,1
      env = MOZ_ENABLE_WAYLAND,1
      env = NIXOS_OZONE_WL,1


      # Gesture configuration
      gesture = 3, horizontal, workspace
      gesture = 3, down, mod: ALT, close
      gesture = 3, up, mod: SUPER, scale: 1.5, fullscreen
      gesture = 2, pinchin, scale: 1.5, float
    '';
  };
}
