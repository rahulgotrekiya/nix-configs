# Utsuru - Self-hosted Jellyfin download manager
{ config, pkgs, lib, meta, ... }:

let
  user = meta.user;
in
{
  # 1. Write aria2 RPC secret to a file and fix state directory ownership
  systemd.tmpfiles.rules = [
    "d /var/lib/aria2           0755 ${user} users  -"
    "Z /var/lib/aria2           -    ${user} users  -"
    "f /var/lib/aria2/rpc-secret 0600 ${user} users - utsuru-aria2-secret"
    "d /var/lib/utsuru/data     0755 ${user} root   -"
    "d /media/downloads         0755 ${user} root   -"
  ];

  # 2. aria2c daemon
  services.aria2 = {
    enable = true;
    rpcSecretFile = "/var/lib/aria2/rpc-secret";
    settings = {
      enable-rpc            = true;
      rpc-listen-all        = true;
      rpc-allow-origin-all  = true;
      dir                   = "/media/downloads";
      max-connection-per-server = 16;
      split                 = 16;
      min-split-size        = "1M";
    };
  };

  # Force aria2 to run as the 'neo' user so it has write access to the media folders
  systemd.services.aria2.serviceConfig = {
    User = lib.mkForce user;
    Group = lib.mkForce "users";
  };

  # 3. Utsuru container
  virtualisation.oci-containers.containers.utsuru = {
    image = "ghcr.io/rahulgotrekiya/utsuru:latest";
    # Force the container to run as your host user to match /media permissions (0755)
    user  = "1000:1000"; 
    ports = [ "4096:4096" ];
    volumes = [
      "/var/lib/utsuru/data:/app/data"
      "/media:/media"
    ];
    environment = {
      NODE_ENV         = "production";
      BASE_URL         = "https://utsuru.gotrekiya.site";
      TZ               = "Asia/Kolkata";
      PORT             = "4096";
      HOST             = "0.0.0.0";
      ARIA2_RPC_URL    = "http://172.17.0.1:6800/jsonrpc";
      ARIA2_RPC_SECRET = "utsuru-aria2-secret";
      JELLYFIN_URL     = "http://172.17.0.1:8096";
      DATABASE_PATH    = "/app/data/utsuru.db";
      MEDIA_MOVIES_DIR = "/media/movies";
      MEDIA_TV_DIR     = "/media/tv";
      ADMIN_PASSWORD   = "admin";
      SECRET_KEY       = "utsuru-secret-key-change-me";
    };
  };

  # 4. Firewall
  networking.firewall.allowedTCPPorts = [ 4096 ];
  # Allow Docker containers to reach aria2c RPC
  networking.firewall.interfaces."docker0".allowedTCPPorts = [ 6800 ];
}

