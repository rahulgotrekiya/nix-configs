{ config, pkgs, ... }:

{
  sops = {
    defaultSopsFile = ./homelab/services.yaml;
    
    age = {
      keyFile = "/home/neo/.config/sops/age/keys.txt";
      
      # Generate key from SSH key if it doesn't exist
      generateKey = true;
    };

    # Define which secrets to extract
    secrets = {
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
