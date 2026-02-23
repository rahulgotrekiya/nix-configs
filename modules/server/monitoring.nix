{ config, pkgs, lib, ... }:

{
  # Prometheus - Metrics collection
  services.prometheus = {
    enable = true;
    port = 9090;
    
    exporters = {
      node = {
        enable = true;
        enabledCollectors = [ "systemd" ];
        port = 9100;
      };
    };

    scrapeConfigs = [
      {
        job_name = "homelab";
        static_configs = [{
          targets = [ 
            "127.0.0.1:9100"  # Node exporter
            "127.0.0.1:9090"  # Prometheus itself
          ];
        }];
      }
      {
        job_name = "docker";
        static_configs = [{
          targets = [ "127.0.0.1:9323" ];
        }];
      }
    ];
  };

  # Grafana - Visualization
  services.grafana = {
    enable = true;
    settings = {
      server = {
        http_addr = "0.0.0.0";
        http_port = 3000;
        domain = "homelab.local";
      };
      
      security = {
        admin_user = "admin";
        admin_password = "$__file{${config.sops.secrets."grafana/admin_password".path}}";
      };

      analytics.reporting_enabled = false;
    };

    provision = {
      enable = true;
      datasources.settings.datasources = [
        {
          name = "Prometheus";
          type = "prometheus";
          access = "proxy";
          url = "http://127.0.0.1:9090";
          isDefault = true;
        }
      ];
    };
  };

 # Uptime Kuma - Uptime monitoring (via Docker)
  virtualisation.oci-containers.containers.uptime-kuma = {
    image = "louislam/uptime-kuma:latest";
    ports = [ "3001:3001" ];
    volumes = [
      "/var/lib/uptime-kuma:/app/data"
    ];
    extraOptions = [
      "--add-host=host.docker.internal:host-gateway"
    ];
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/uptime-kuma 0755 root root -"
  ];


   systemd.services.grafana.preStart = lib.mkAfter ''
    # If Grafana database exists, reset admin password from secret
    if [ -f /var/lib/grafana/grafana.db ]; then
      PASSWORD=$(cat ${config.sops.secrets."grafana/admin_password".path})
      
      # Use Grafana's binary to reset password
      ${pkgs.grafana}/bin/grafana cli \
        --homepath ${pkgs.grafana}/share/grafana \
        --config /nix/store/*-grafana.ini/grafana.ini \
        admin reset-admin-password "$PASSWORD" 2>/dev/null || true
    fi
  '';
}
