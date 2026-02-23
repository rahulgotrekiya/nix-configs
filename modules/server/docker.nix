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

  virtualisation.oci-containers.backend = "docker";

  # Portainer - Docker management UI
  virtualisation.oci-containers = {
    containers = {
      portainer = {
        image = "portainer/portainer-ce:latest";
        ports = [ "9000:9000" ];
        volumes = [
          "/var/run/docker.sock:/var/run/docker.sock"
          "/var/lib/docker-data/portainer:/data"
        ];
      };
    };
  };
}
