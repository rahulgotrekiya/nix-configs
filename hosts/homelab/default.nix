# Homelab server configuration (HP ENVY x360 repurposed)
{ config, pkgs, lib, meta, ... }:

{
  imports = [
    ./hardware.nix
  ];

  # systemd-boot (simpler than GRUB for a server)
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # NVMe stability
  boot.kernelParams = [
    "nvme.noacpi=1"
    "nvme_core.default_ps_max_latency_us=0"
  ];

  # Server: never sleep, ignore lid
  services.logind.settings.Login = {
    HandleLidSwitch = "ignore";
    HandleLidSwitchExternalPower = "ignore";
    HandleLidSwitchDocked = "ignore";
  };
  systemd.sleep.extraConfig = ''
    AllowSuspend=no
    AllowHibernation=no
    AllowHybridSleep=no
    AllowSuspendThenHibernate=no
  '';

  # Tailscale as exit node / subnet router
  services.tailscale.useRoutingFeatures = "server";

  # Console
  console.font = "Lat2-Terminus16";

  # User account
  users.users.neo = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "networkmanager" ];
    packages = with pkgs; [ tree ];
    hashedPasswordFile = config.sops.secrets."neo_user/hashed_password".path;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJBQ/hs58QFvy3tebRmRcvnxqj87zAY9AXsIfVYiITiM rgotrekiya2603@gmail.com"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKhgU+fyofY/2xfmyPZflpLG172Gjze5V5T74/+R8AO3 u0_a324@localhost"
    ];
  };

  # SSH hardened
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
      KbdInteractiveAuthentication = false;
    };
  };

  # Hardware transcoding (Intel HD 520)
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-vaapi-driver
      libva-vdpau-driver
      libvdpau-va-gl
    ];
  };

  # Server packages (on top of base.nix)
  environment.systemPackages = with pkgs; [
    cifs-utils
    nfs-utils
    docker-compose
  ];

  # Firewall
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      22    # SSH
      80    # HTTP
      53    # Blocky
      443   # HTTPS
      8096  # Jellyfin
      8384  # Syncthing
      9091  # Transmission
      51413 # Transmission
      8989  # Sonarr
      7878  # Radarr
      9696  # Prowlarr
      8686  # Lidarr
      8191  # Flaresolverr
      6767  # Bazarr
      3000  # Grafana
      9090  # Prometheus
    ];
    allowedUDPPorts = [
      51413 # Transmission
      53    # Blocky
    ];
  };

  system.stateVersion = "23.11";
}
