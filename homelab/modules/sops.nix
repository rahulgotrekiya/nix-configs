{ config, pkgs, ... }:

{
  sops = {
    defaultSopsFile = ../../secrets/homelab/services.yaml;
    
    age = {
      keyFile = "/home/neo/.config/sops/age/keys.txt";
      
      # Generate key from SSH key if it doesn't exist
      generateKey = true;
    };

    # Define which secrets to extract
    secrets = {
      # Syncthing
      "syncthing/gui_password" = {
        owner = "neo";
        mode = "0400";  # Read-only for owner
      };
      
      # Transmission
      "transmission/env" = {
        owner = "neo";
        mode = "0400";
      };

      # Grafana 
      "grafana/admin_password" = {
        owner = "grafana";
        group = "grafana";
        mode = "0400";
        # Restart Grafana when password changes
        restartUnits = [ "grafana.service" ];
      };
      
      # User password
      "neo_user/hashed_password" = {
        neededForUsers = true;  # Available during user creation
      };
      
      # Cloudflare tunnel token
      "cloudflare/tunnel_token" = {
        owner = "cloudflared";
        mode = "0400";
      };
    };
  };
}
