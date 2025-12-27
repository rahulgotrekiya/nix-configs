{ config, pkgs, ... }:

{
  # Networking configuration
  networking = {
    hostName = "nixos";
    # wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    networkmanager.enable = true;

    # Configure network proxy if necessary
    # proxy = {
    #   default = "http://user:password@proxy:port/";
    #   noProxy = "127.0.0.1,localhost,internal.domain";
    # };

    # Open ports in the firewall.
    # firewall = {
    #   enable = false;
    #   allowedTCPPorts = [ ... ];
    #   allowedUDPPorts = [ ... ];
    # };
  };
  
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";
  };

  systemd.services.NetworkManager-wait-online.enable = false;
}