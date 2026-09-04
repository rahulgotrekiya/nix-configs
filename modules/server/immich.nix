# Immich - Self-hosted photo & video backup (Google Photos alternative)
{ config, pkgs, lib, ... }:

{
  services.immich = {
    enable = true;
    port = 2283;
    host = "0.0.0.0";
    openFirewall = false;  # We use nginx reverse proxy

    mediaLocation = "/media/photos";

    environment = {
      TZ = "Asia/Kolkata";
    };
  };

  # Photo storage directory
  systemd.tmpfiles.rules = lib.mkAfter [
    "d /media/photos 0755 immich immich -"
  ];
}
