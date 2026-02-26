{ config, pkgs, lib, ... }:

let
  serverIP = "192.168.1.13";
  localNet = "192.168.1.0/24";
  domain = "gotrekiya.site";

  # ── Service → port map (single source of truth) ───────────────
  services = {
    ""         = { port = 8080; };                          # Glance dashboard
    "media"    = { port = 8096; extra = ''proxy_buffering off;''; };  # Jellyfin
    "monitor"  = { port = 3000; };                          # Grafana
    "docker"   = { port = 9000; };                          # Portainer
    "status"   = { port = 3001; };                          # Uptime Kuma
    "photos"   = { port = 2283; extra = ''
      client_max_body_size 50000M;
      proxy_read_timeout 600s;
      proxy_send_timeout 600s;
    ''; };                                                  # Immich
    "sonarr"   = { port = 8989; };
    "radarr"   = { port = 7878; };
    "prowlarr" = { port = 9696; };
    "bazarr"   = { port = 6767; };
    "lidarr"   = { port = 8686; };
    "torrent"  = { port = 9091; };                          # Transmission
    "files"    = { port = 8092; };                          # File Browser
    "sync"     = { port = 8384; };                          # Syncthing
  };

  # Helper: subdomain string → full hostname
  mkHostname = sub: if sub == "" then domain else "${sub}.${domain}";

  # Helper: build an Nginx vhost from a service entry
  mkVhost = _sub: svc: {
    forceSSL = true;
    useACMEHost = domain;
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString svc.port}";
      proxyWebsockets = true;
    } // lib.optionalAttrs (svc ? extra) {
      extraConfig = svc.extra;
    };
  };

  # Build the full hostname → vhost attrset
  nginxVhosts = lib.mapAttrs'
    (sub: svc: lib.nameValuePair (mkHostname sub) (mkVhost sub svc))
    services;

  # Auto-generate Blocky DNS mappings from the same services map
  blockyMappings = lib.mapAttrs'
    (sub: _svc: lib.nameValuePair (mkHostname sub) serverIP)
    services;
in
{
  # ── ACME (Let's Encrypt) ─────────────────────────────────────────
  security.acme = {
    acceptTerms = true;
    defaults.email = "rahulgotrekiya@gmail.com";

    certs."${domain}" = {
      dnsProvider = "cloudflare";
      environmentFile = config.sops.secrets."cloudflare/acme_env".path;
      domain = domain;
      extraDomainNames = [ "*.${domain}" ];
      group = "nginx";
    };
  };

  # ── Nginx — Reverse proxy with SSL ──────────────────────────────
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    virtualHosts = nginxVhosts;
  };

  # ── Blocky — DNS with ad blocking ───────────────────────────────
  services.blocky = {
    enable = true;
    settings = {
      ports.dns = 53;

      upstreams.groups.default = [
        "https://one.one.one.one/dns-query"
        "https://dns.google/dns-query"
      ];

      caching = {
        minTime = "5m";
        maxTime = "30m";
        prefetching = true;
      };

      blocking = {
        blackLists.ads = [
          "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
        ];
        clientGroupsBlock.default = [ "ads" ];
      };

      # Auto-generated from the services map above
      customDNS.mapping = blockyMappings;
    };
  };

  # # WireGuard VPN — requires public IPv4 (CGNAT blocks this)
  # # Use Tailscale instead.
  # networking.wireguard.interfaces.wg0 = { ... };

  # ── Fail2ban — Intrusion prevention ─────────────────────────────
  services.fail2ban = {
    enable = true;
    maxretry = 5;
    bantime = "1h";
    ignoreIP = [
      "127.0.0.1/8"
      localNet
    ];
    jails.sshd.settings = {
      enabled = true;
      port = "22";
      filter = "sshd";
      backend = "systemd";
      maxretry = 3;
      bantime = "1d";
    };
  };
}
