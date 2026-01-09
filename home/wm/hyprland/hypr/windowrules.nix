{ config, lib, pkgs, ... }:

{
  wayland.windowManager.hyprland.settings = {
    # Window rules
    windowrulev2 = [
      "float, class:^Google-chrome$, title:^WhatsApp\\ Web$"
      "float, class:^Spotify$"
      "float, class:^xdg-desktop-portal-gtk$"
      "float, class:^org.gnome.Nautilus$"
      "float, class:^org.gnome.NautilusPreviewer$"
      "float, title:^(About Mozilla Firefox)$"
      "float, class:^(firefox)$, title:^(Picture-in-Picture)$"
      "float, class:^(firefox)$, title:^(Library)$"
      "float, class:^(Skype)$"
      "float, class:^(org.pulseaudio.pavucontrol)$"
      "float, class:^(com.github.rafostar.Clapper)$"
      "float, class:^(eog)$"
      "float,class:(clipse)"
      "size 622 652,class:(clipse)"
      "opacity 0.90 0.90, class:^(com.github.rafostar.Clapper)$"
      "opacity 0.80 0.80, class:^(com.github.tchx84.Flatseal)$"
      "opacity 0.80 0.80, class:^(com.obsproject.Studio)$"
      "opacity 0.80 0.80, class:^(gnome-boxes)$"
      "opacity 0.80 0.80, class:^(discord)$"
      "opacity 0.80 0.70, class:^(polkit-gnome-authentication-agent-1)$"
      "opacity 0.80 0.70, class:^(org.freedesktop.impl.portal.desktop.gtk)$"
      "opacity 0.80 0.70, class:^(org.freedesktop.impl.portal.desktop.hyprland)$"
      "opacity 0.80 0.80, class:^(Spotify)$"
      "opacity 0.70 0.70, initialTitle:^(Spotify Free)$"
      # "workspace 10, gapsout:110"
      "float,class:^(scratchpad)$"
      "size 80% 85%,class:^(scratchpad)$"
      "workspace special:scratchpad ,class:^(scratchpad)$"
      "center,class:^(scratchpad)$"
      "workspace 9,class:^(resolve)$"
      "float,class:^(resolve)$"
    ];   
  };
}