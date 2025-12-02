# Docker configuration for homelab
{ config, pkgs, ... }:

{
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    autoPrune = {
      enable = true;
      dates = "weekly";
    };
  };

  # Create docker networks and base directories
  systemd.tmpfiles.rules = [
    "d /var/lib/docker-data 0755 root root -"
    "d /var/lib/docker-data/traefik 0755 root root -"
    "d /var/lib/docker-data/portainer 0755 root root -"
    "d /var/lib/docker-data/homepage 0755 root root -"
  ];

  # Portainer - Docker management UI
  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      portainer = {
        image = "portainer/portainer-ce:latest";
        ports = [ "9000:9000" ];
        volumes = [
          "/var/run/docker.sock:/var/run/docker.sock"
          "/var/lib/docker-data/portainer:/data"
        ];
        extraOptions = [ "--restart=unless-stopped" ];
      };

      # Homepage Dashboard - Beautiful dashboard for your services
      homepage = {
        image = "ghcr.io/gethomepage/homepage:latest";
        ports = [ "3030:3000" ];
        volumes = [
          "/var/lib/docker-data/homepage:/app/config"
          "/var/run/docker.sock:/var/run/docker.sock:ro"
        ];
        environment = {
          PUID = "1000";
          PGID = "1000";
        };
        extraOptions = [ "--restart=unless-stopped" ];
      };
    };
  };

  # Create initial homepage configuration
  environment.etc."docker-data/homepage/services.yaml".text = ''
    - Media:
        - Jellyfin:
            href: http://localhost:8096
            description: Media Server
            icon: jellyfin.png
        - Transmission:
            href: http://localhost:9091
            description: Torrent Client
            icon: transmission.png
        
    - *arr Stack:
        - Sonarr:
            href: http://localhost:8989
            description: TV Shows
            icon: sonarr.png
        - Radarr:
            href: http://localhost:7878
            description: Movies
            icon: radarr.png
        - Prowlarr:
            href: http://localhost:9696
            description: Indexer Manager
            icon: prowlarr.png
            
    - Management:
        - Portainer:
            href: http://localhost:9000
            description: Docker Management
            icon: portainer.png
  '';
}
