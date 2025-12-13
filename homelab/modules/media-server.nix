# Media server configuration - Jellyfin + *arr stack
{ config, pkgs, lib, ... }:

{
  # Create media directories

  systemd.tmpfiles.rules = lib.mkAfter [
   "d /media 0755 root root -"
   "d /media/movies 0755 neo root -"
   "d /media/tv 0755 neo root -"
   "d /media/music 0755 neo root -"
   "d /media/books 0755 neo root -"
   "d /media/downloads 0755 neo root -"
   "d /var/lib/jellyfin 0755 jellyfin jellyfin -"

   "d /var/lib/sonarr 0755 neo root -"
   "d /var/lib/radarr 0755 neo root -"
   "d /var/lib/prowlarr 0755 neo root -"
   "d /var/lib/bazarr 0755 neo root -"
   "d /var/lib/lidarr 0755 neo root -"
   "d /var/lib/transmission 0755 neo root -"
  ];


  # Jellyfin Media Server (Native - better performance)
  services.jellyfin = {
    enable = true;
    openFirewall = true;
    user = "jellyfin";
    group = "jellyfin";
  };

  # Add neo user to jellyfin group for file access
  users.users.neo.extraGroups = [ "jellyfin" ];
  users.users.jellyfin.extraGroups = [ "video" "render" ];

  # *arr Stack using Docker Compose
  virtualisation.oci-containers = {
    backend = "docker";
    
    containers = {
      # Sonarr - TV Show management
      sonarr = {
        image = "lscr.io/linuxserver/sonarr:latest";
        ports = [ "8989:8989" ];
        environment = {
          PUID = "1000";
          PGID = "1000";
          TZ = "Asia/Kolkata";
        };
        volumes = [
          "/var/lib/sonarr:/config"
          "/media:/media"
          "/media/downloads:/downloads"
        ];
      };

      # Radarr - Movie management
      radarr = {
        image = "lscr.io/linuxserver/radarr:latest";
        ports = [ "7878:7878" ];
        environment = {
          PUID = "1000";
          PGID = "1000";
          TZ = "Asia/Kolkata";
        };
        volumes = [
          "/var/lib/radarr:/config"
          "/media:/media"
          "/media/downloads:/downloads"
        ];
      };

      # Prowlarr - Indexer manager
      prowlarr = {
        image = "lscr.io/linuxserver/prowlarr:latest";
        ports = [ "9696:9696" ];
        environment = {
          PUID = "1000";
          PGID = "1000";
          TZ = "Asia/Kolkata";
        };
        volumes = [
          "/var/lib/prowlarr:/config"
        ];
      };

      # Flaresolverr - Bypasses cloudfare solver
      flaresolverr = {
        image = "ghcr.io/flaresolverr/flaresolverr:latest";
        ports = [ "8191:8191" ];
        extraOptions = [ "--network=host" ];
        environment = {
    	  LOG_LEVEL = "info";
        };
      };

      # Bazarr - Subtitle management
      bazarr = {
        image = "lscr.io/linuxserver/bazarr:latest";
        ports = [ "6767:6767" ];
        environment = {
          PUID = "1000";
          PGID = "1000";
          TZ = "Asia/Kolkata";
        };
        volumes = [
          "/var/lib/bazarr:/config"
          "/media:/media"
        ];
      };

      # Lidarr - Music management
      lidarr = {
        image = "lscr.io/linuxserver/lidarr:latest";
        ports = [ "8686:8686" ];
        environment = {
          PUID = "1000";
          PGID = "1000";
          TZ = "Asia/Kolkata";
        };
        volumes = [
          "/var/lib/lidarr:/config"
          "/media:/media"
        ];
      };

      # Transmission - Torrent client
      transmission = {
        image = "lscr.io/linuxserver/transmission:latest";
        ports = [ 
          "9091:9091"
          "51413:51413"
          "51413:51413/udp"
        ];
        environment = {
          PUID = "1000";
          PGID = "1000";
          TZ = "Asia/Kolkata";
          USER = "admin";
          PASS = "admin123";  # Change this!
        };
        volumes = [
          "/var/lib/transmission:/config"
          "/media/downloads:/downloads"
        ];
      };
    };
  };
}
