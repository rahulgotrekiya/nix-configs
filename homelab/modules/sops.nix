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
      "syncthing/gui_password" = {
        owner = "neo";
        mode = "0400";  # Read-only for owner
      };
      "transmission/env" = {
        owner = "neo";
        mode = "0400";
      };
      "grafana/admin_password" = {
        owner = "root";
        mode = "0400";
      };
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
