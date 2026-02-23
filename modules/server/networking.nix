{ config, pkgs, ... }:

let
  serverIP = "192.168.1.13";
  localNet = "192.168.1.0/24";
  domain = "gotrekiya.site";
in
{
  # ── ACME (Let's Encrypt) ─────────────────────────────────────────
  security.acme = {
    acceptTerms = true;
    defaults.email = "rahulgotrekiya@gmail.com";

    # Wildcard certificate for *.gotrekiya.site
    certs."${domain}" = {
      dnsProvider = "cloudflare";
      environmentFile = config.sops.secrets."cloudflare/acme_env".path;
      domain = domain;
      extraDomainNames = [ "*.${domain}" ];
      group = "nginx"; # Let Nginx read the cert
    };
  };

  # ── Nginx — Reverse proxy with SSL ──────────────────────────────
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;

    virtualHosts = {
      # ── Dashboard (Glance) ──
      "${domain}" = {
        forceSSL = true;
        useACMEHost = domain;
        locations."/" = {
          proxyPass = "http://127.0.0.1:8080";
          proxyWebsockets = true;
        };
      };

      # ── Jellyfin ──
      "media.${domain}" = {
        forceSSL = true;
        useACMEHost = domain;
        locations."/" = {
          proxyPass = "http://127.0.0.1:8096";
          proxyWebsockets = true;
          extraConfig = ''
            proxy_buffering off;
          '';
        };
      };

      # ── Grafana ──
      "monitor.${domain}" = {
        forceSSL = true;
        useACMEHost = domain;
        locations."/" = {
          proxyPass = "http://127.0.0.1:3000";
          proxyWebsockets = true;
        };
      };

      # ── Portainer ──
      "docker.${domain}" = {
        forceSSL = true;
        useACMEHost = domain;
        locations."/" = {
          proxyPass = "http://127.0.0.1:9000";
          proxyWebsockets = true;
        };
      };

      # ── Uptime Kuma ──
      "status.${domain}" = {
        forceSSL = true;
        useACMEHost = domain;
        locations."/" = {
          proxyPass = "http://127.0.0.1:3001";
          proxyWebsockets = true;
        };
      };

      # ── Immich Photos ──
      "photos.${domain}" = {
        forceSSL = true;
        useACMEHost = domain;
        locations."/" = {
          proxyPass = "http://127.0.0.1:2283";
          proxyWebsockets = true;
          extraConfig = ''
            client_max_body_size 50000M;
            proxy_read_timeout 600s;
            proxy_send_timeout 600s;
          '';
        };
      };

      # ── Sonarr ──
      "sonarr.${domain}" = {
        forceSSL = true;
        useACMEHost = domain;
        locations."/" = {
          proxyPass = "http://127.0.0.1:8989";
          proxyWebsockets = true;
        };
      };

      # ── Radarr ──
      "radarr.${domain}" = {
        forceSSL = true;
        useACMEHost = domain;
        locations."/" = {
          proxyPass = "http://127.0.0.1:7878";
          proxyWebsockets = true;
        };
      };

      # ── Prowlarr ──
      "prowlarr.${domain}" = {
        forceSSL = true;
        useACMEHost = domain;
        locations."/" = {
          proxyPass = "http://127.0.0.1:9696";
          proxyWebsockets = true;
        };
      };

      # ── Bazarr ──
      "bazarr.${domain}" = {
        forceSSL = true;
        useACMEHost = domain;
        locations."/" = {
          proxyPass = "http://127.0.0.1:6767";
          proxyWebsockets = true;
        };
      };

      # ── Lidarr ──
      "lidarr.${domain}" = {
        forceSSL = true;
        useACMEHost = domain;
        locations."/" = {
          proxyPass = "http://127.0.0.1:8686";
          proxyWebsockets = true;
        };
      };

      # ── Transmission ──
      "torrent.${domain}" = {
        forceSSL = true;
        useACMEHost = domain;
        locations."/" = {
          proxyPass = "http://127.0.0.1:9091";
          proxyWebsockets = true;
        };
      };

      # ── File Browser ──
      "files.${domain}" = {
        forceSSL = true;
        useACMEHost = domain;
        locations."/" = {
          proxyPass = "http://127.0.0.1:8092";
          proxyWebsockets = true;
        };
      };

      # ── Syncthing ──
      "sync.${domain}" = {
        forceSSL = true;
        useACMEHost = domain;
        locations."/" = {
          proxyPass = "http://127.0.0.1:8384";
          proxyWebsockets = true;
        };
      };
    };
  };

  # ── Blocky — DNS with ad blocking ───────────────────────────────
  services.blocky = {
    enable = true;
    settings = {
      ports = {
        dns = 53;
      };
      upstreams.groups.default = [
        "https://one.one.one.one/dns-query"  # Cloudflare DNS
        "https://dns.google/dns-query"       # Google DNS
      ];
      
      # Enable DNS caching
      caching = {
        minTime = "5m";
        maxTime = "30m";
        prefetching = true;
      };

      # Ad blocking
      blocking = {
        blackLists.ads = [
          "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
        ];
        clientGroupsBlock = {
          default = [ "ads" ];
        };
      };

      # Custom DNS entries — all subdomains → server IP
      customDNS = {
        mapping = {
          "${domain}" = serverIP;
          "media.${domain}" = serverIP;
          "monitor.${domain}" = serverIP;
          "docker.${domain}" = serverIP;
          "status.${domain}" = serverIP;
          "photos.${domain}" = serverIP;
          "sonarr.${domain}" = serverIP;
          "radarr.${domain}" = serverIP;
          "prowlarr.${domain}" = serverIP;
          "bazarr.${domain}" = serverIP;
          "lidarr.${domain}" = serverIP;
          "torrent.${domain}" = serverIP;
          "files.${domain}" = serverIP;
          "sync.${domain}" = serverIP;
        };
      };
    };
  };
  
  # # WireGuard VPN - Access your homelab remotely
  # #
  # # Note: Direct WireGuard server requires a public IPv4.  
  # # ISPs using CGNAT (e.g. Airtel India, which is sadly my ISP) block inbound traffic.  
  # # Use Tailscale or a VPS relay instead.
  # #
  # networking.wireguard.interfaces = {
  #   wg0 = {
  #     ips = [ "10.100.0.1/24" ];
  #     listenPort = 51820;
  #
  #     # Generate with: wg genkey
  #     privateKeyFile = "/root/wireguard-keys/private";
  #
  #     peers = [
  #       # Phone
  #       # {
  #       #   publicKey = "CLIENT_PUBLIC_KEY";
  #       #   allowedIPs = [ "10.100.0.2/32" ];
  #       # }
  #       # Laptop
  #       # {
  #       #   publicKey = "CLIENT_PUBLIC_KEY";
  #       #   allowedIPs = [ "10.100.0.3/32" ];
  #       # }
  #     ];
  #   };
  # };
  #
  # networking.nat = {
  #   enable = true;
  #   externalInterface = "wlo1";  # Change to your external interface
  #   internalInterfaces = [ "wg0" ];
  # };
  #
  # networking.firewall.allowedUDPPorts = [ 51820 ];

  # Fail2ban - Intrusion prevention
  services.fail2ban = {
    enable = true;
    maxretry = 5;
    bantime = "1h";
    ignoreIP = [
      "127.0.0.1/8"
      localNet
    ];
    jails = {
      sshd.settings = {
        enabled = true;
        port = "22";
        filter = "sshd";
        backend = "systemd";
        maxretry = 3;
        bantime = "1d";
      };
    };
  };

  # Tailscale - Easy zero-config VPN alternative
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "server";
  };
}
