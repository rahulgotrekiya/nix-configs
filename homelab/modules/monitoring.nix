{ config, pkgs, ... }:

{
  # Prometheus - Metrics collection
  services.prometheus = {
    enable = false;
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
    enable = false;
    settings = {
      server = {
        http_addr = "0.0.0.0";
        http_port = 3000;
        domain = "homelab.local";
      };
      
      security = {
        admin_user = "admin";
        admin_password = "admin123";  # Change this 
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
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/uptime-kuma 0755 root root -"
  ];
}
