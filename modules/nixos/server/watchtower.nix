# Watchtower - Automatic Docker container updates
{ config, pkgs, ... }:

{
  virtualisation.oci-containers.containers.watchtower = {
    image = "containrrr/watchtower";
    volumes = [
      "/var/run/docker.sock:/var/run/docker.sock"
    ];
    environment = {
      WATCHTOWER_CLEANUP = "true";      # Removes old images after update
      WATCHTOWER_POLL_INTERVAL = "300"; # Check for updates every 5 minutes
      TZ = "Asia/Kolkata";
    };
  };
}
