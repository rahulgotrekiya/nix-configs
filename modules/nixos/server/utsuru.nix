# Utsuru - Self-hosted Jellyfin download manager
{ config, pkgs, lib, ... }:

{
  # 1. Setup aria2c daemon
  services.aria2 = {
    enable = true;
    openFirewall = true;
    settings = {
      enable-rpc = true;
      rpc-listen-all = true;
      rpc-allow-origin-all = true;
      dir = "/media/downloads";
      max-connection-per-server = 16;
      split = 16;
      min-split-size = "1M";
    };
  };

  # 2. Setup Utsuru container
  virtualisation.oci-containers.containers.utsuru = {
    image = "ghcr.io/rahulgotrekiya/utsuru:latest";
    ports = [ "4096:4096" ];
    volumes = [
      "/var/lib/utsuru/data:/app/data"
      "/media:/media" 
    ];
    environment = {
      TZ = "Asia/Kolkata";
      PORT = "4096";
      HOST = "0.0.0.0";
      # Use host bridge IP for RPC connection
      ARIA2_RPC_URL = "http://172.17.0.1:6800/jsonrpc";
      JELLYFIN_URL = "http://172.17.0.1:8096";
      DATABASE_PATH = "/app/data/utsuru.db";
      MEDIA_MOVIES_DIR = "/media/movies";
      MEDIA_TV_DIR = "/media/tv";
      # Default credentials
      ADMIN_PASSWORD = "admin"; 
      SECRET_KEY = "utsuru-secret-key-change-me";
    };
  };

  # 3. Persistence & Directories
  systemd.tmpfiles.rules = [
    "d /var/lib/utsuru/data 0755 neo root -"
    "d /media/downloads 0755 neo root -"
  ];

  # 4. Firewall
  networking.firewall.allowedTCPPorts = [ 4096 6800 ];
}
