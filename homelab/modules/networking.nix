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
      # Dashboard
      "homelab.local" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:8080"; 
          proxyWebsockets = true;
        };
      };

      # Jellyfin
      "media.homelab.local" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:8096";
          proxyWebsockets = true;
          extraConfig = ''
            proxy_buffering off;
          '';
        };
      };

      # Grafana
      "monitor.homelab.local" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:3000";
          proxyWebsockets = true;
        };
      };

      # Portainer
      "docker.homelab.local" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:9000";
          proxyWebsockets = true;
        };
      };
    };
  };

  # Pi-hole / AdGuard Home alternative - DNS with ad blocking
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

      # Optional: Custom DNS entries
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
      "192.168.1.0/24" 
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
