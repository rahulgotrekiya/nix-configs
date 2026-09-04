# homelab/modules/cloudflare-tunnel.nix
{ config, pkgs, lib, ... }:

{
  environment.systemPackages = [ pkgs.cloudflared ];

  systemd.services.cloudflared = {
    description = "Cloudflare Tunnel";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];

    serviceConfig = {
      Type = "simple";
      User = "cloudflared";
      Group = "cloudflared";
      Restart = "on-failure";
      RestartSec = "5s";
      
      ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.cloudflared}/bin/cloudflared tunnel --no-autoupdate run --token $(cat ${config.sops.secrets."cloudflare/tunnel_token".path})'";
      
      NoNewPrivileges = true;
      PrivateTmp = true;
      ProtectSystem = "strict";
      ProtectHome = true;
      ReadWritePaths = [ "/var/lib/cloudflared" ];
    };
  };

  users.users.cloudflared = {
    isSystemUser = true;
    group = "cloudflared";
    home = "/var/lib/cloudflared";
    createHome = true;
  };

  users.groups.cloudflared = {};

  systemd.tmpfiles.rules = [
    "d /var/lib/cloudflared 0755 cloudflared cloudflared -"
  ];
}
