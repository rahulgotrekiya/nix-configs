# Docker - local container runtime (rootful daemon)
{ pkgs, username, ... }:

{
  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;   # weekly prune of unused images/containers (keeps disk in check)
  };

  # Let the user run docker without sudo (docker group == root-equivalent, standard for a dev box)
  users.users.${username}.extraGroups = [ "docker" ];

  # docker compose files (both `docker compose` and standalone `docker-compose`)
  environment.systemPackages = [ pkgs.docker-compose ];
}
