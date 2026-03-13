{ config, lib, pkgs, ... }:

{
  wayland.windowManager.hyprland.settings = {
    # Window rules using new 0.53 syntax
    windowrule = [
      {
        name = "float-chrome-whatsapp";
        "match:class" = "Google-chrome";
        "match:title" = "WhatsApp Web";
        float = "on";
      }
      {
        name = "float-spotify";
        "match:class" = "Spotify";
        float = "on";
      }
      {
        name = "float-xdg-portal";
        "match:class" = "xdg-desktop-portal-gtk";
        float = "on";
      }
      {
        name = "float-nautilus";
        "match:class" = "org.gnome.Nautilus";
        float = "on";
      }
      {
        name = "float-nautilus-previewer";
        "match:class" = "org.gnome.NautilusPreviewer";
        float = "on";
      }
      {
        name = "float-firefox-about";
        "match:title" = "(About Mozilla Firefox)";
        float = "on";
      }
      {
        name = "float-firefox-pip";
        "match:class" = "firefox";
        "match:title" = "(Picture-in-Picture)";
        float = "on";
      }
      {
        name = "float-firefox-library";
        "match:class" = "firefox";
        "match:title" = "(Library)";
        float = "on";
      }
      {
        name = "float-skype";
        "match:class" = "Skype";
        float = "on";
      }
      {
        name = "float-pavucontrol";
        "match:class" = "org.pulseaudio.pavucontrol";
        float = "on";
      }
      {
        name = "float-clapper";
        "match:class" = "com.github.raafostar.Clapper";
        float = "on";
      }
      {
        name = "float-eog";
        "match:class" = "eog";
        float = "on";
      }
      {
        name = "float-clipse";
        "match:class" = "clipse";
        float = "on";
        size = "622 652";
      }
      {
        name = "opacity-clapper";
        "match:class" = "com.github.rafostar.Clapper";
        opacity = "0.90 0.90";
      }
      {
        name = "opacity-flatseal";
        "match:class" = "com.github.tchx84.Flatseal";
        opacity = "0.80 0.80";
      }
      {
        name = "opacity-obs";
        "match:class" = "com.obsproject.Studio";
        opacity = "0.80 0.80";
      }
      {
        name = "opacity-boxes";
        "match:class" = "gnome-boxes";
        opacity = "0.80 0.80";
      }
      {
        name = "opacity-discord";
        "match:class" = "discord";
        opacity = "0.80 0.80";
      }
      {
        name = "opacity-polkit";
        "match:class" = "polkit-gnome-authentication-agent-1";
        opacity = "0.80 0.70";
      }
      {
        name = "opacity-portal-gtk";
        "match:class" = "org.freedesktop.impl.portal.desktop.gtk";
        opacity = "0.80 0.70";
      }
      {
        name = "opacity-portal-hyprland";
        "match:class" = "org.freedesktop.impl.portal.desktop.hyprland";
        opacity = "0.80 0.70";
      }
      {
        name = "opacity-spotify";
        "match:class" = "Spotify";
        opacity = "0.80 0.80";
      }
      {
        name = "opacity-spotify-free";
        "match:initial_title" = "Spotify Free";
        opacity = "0.70 0.70";
      }
      {
        name = "scratchpad-setup";
        "match:class" = "scratchpad";
        float = "on";
        size = "80% 85%";
        workspace = "special:scratchpad";
        center = "on";
      }
      {
        name = "resolve-setup";
        "match:class" = "resolve";
        workspace = "9";
        float = "on";
      }
    ];   
  };
}