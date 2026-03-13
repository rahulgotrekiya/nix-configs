# Server module aggregator — import this once to get all server services.
# To add a new service: create a .nix file in this directory and add it below.
{ ... }:

{
  imports = [
    ./docker.nix
    ./media-server.nix
    ./monitoring.nix
    ./networking.nix
    ./file-sharing.nix
    ./cloudflare-tunnel.nix
    ./filebrowser.nix
    ./glance.nix
    ./immich.nix
  ];
}
