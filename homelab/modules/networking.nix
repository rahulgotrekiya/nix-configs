# Advanced networking - Reverse proxy, DNS, VPN
{ config, pkgs, ... }:

{
  # Nginx - Reverse proxy
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;

    virtualHosts = {
      "homelab.local" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:3030";
          proxyWebsockets = true;
        };
      };

      "media.homelab.local" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:8096";
          proxyWebsockets = true;
          extraConfig = "proxy_buffering off;";
        };
      };

      "monitor.homelab.local" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:3000";
          proxyWebsockets = true;
        };
      };

      "docker.homelab.local" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:9000";
          proxyWebsockets = true;
        };
      };
    };
  };

  # DNS server (Blocky)
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

      customDNS = {
        mapping = {
          "homelab.local" = "192.168.1.13";
          "media.homelab.local" = "192.168.1.13";
          "monitor.homelab.local" = "192.168.1.13";
          "docker.homelab.local" = "192.168.1.13";
        };
      };
    };
  };

  # WireGuard Server
  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "10.100.0.1/24" ];
      listenPort = 51820;
      privateKeyFile = "/root/wireguard-keys/private";
    };
  };

  # NAT for VPN
  networking.nat = {
    enable = true;
    externalInterface = "wlo1";  
    internalInterfaces = [ "wg0" ];
  };

  networking.firewall.allowedUDPPorts = [ 51820 ];

  # Fail2ban (SSH brute-force protection)
  services.fail2ban = {
    enable = true;
    maxretry = 5;
    bantime = "1h";
    ignoreIP = [
      "127.0.0.1/8"
      "192.168.1.0/24"
    ];
    jails.sshd.settings = {
      enabled = true;
      port = "22";
      filter = "sshd";
      logpath = "/var/log/auth.log";
      maxretry = 3;
      bantime = "1d";
    };
  };

  # Tailscale (optional VPN)
  services.tailscale = {
    enable = false;
    useRoutingFeatures = "server";
  };
}

