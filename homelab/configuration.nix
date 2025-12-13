# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, meta, ... }:

{
  imports = [
    # Include the results of the hardware scan
    ./hardware-configuration.nix
    ./modules/docker.nix
    ./modules/media-server.nix
    ./modules/file-sharing.nix
    ./modules/monitoring.nix
    ./modules/networking.nix
    ./modules/glance.nix
  ];

  nix = {
 	package = pkgs.nix;
  	settings.experimental-features = [ "nix-command" "flakes" ];
  };

  # Use the systemd-boot EFI boot loader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = meta.hostname;
  # Pick only one of the below networking options
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default
  
  services.logind.settings = {
    Login = {
      HandleLidSwitch = "ignore";
      HandleLidSwitchExternalPower = "ignore";
      HandleLidSwitchDocked = "ignore";
    };
  };

  systemd.sleep.extraConfig = ''
    AllowSuspend=no
    AllowHibernation=no
    AllowHybridSleep=no
    AllowSuspendThenHibernate=no
  '';

  boot.kernelParams = [
    "nvme.noacpi=1"
    "nvme_core.default_ps_max_latency_us=0"
  ];


  # Set your time zone
  time.timeZone = "Asia/Kolkata";

  # Select internationalisation properties
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Define a user account. Don't forget to set a password with 'passwd'
  users.users.neo = {
    isNormalUser = true;
    extraGroups = [ 
      "wheel"
      "docker"
      "networkmanager"
    ];
    packages = with pkgs; [
      tree
    ];
    hashedPassword = "$6$ZfLXV/9Kczid8V55$76pdYdfd2yjVmxqYuv82m9ePJJ4GkjdBifsFPi/GNPN2PbwLjfJW8qJZdyFkwjeKDLCCi1YfZlCsr6iOUJHAu/";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJBQ/hs58QFvy3tebRmRcvnxqj87zAY9AXsIfVYiITiM rgotrekiya2603@gmail.com"
    ];
  };

  # List packages installed in system profile
  environment.systemPackages = with pkgs; [
    neovim
    btop
    cifs-utils
    nfs-utils
    git
    wget
    htop
    btop
    docker-compose
  ];

  # Enable the OpenSSH daemon
  services.openssh.enable = true;

  programs.git = {
    enable = true;

    config = {
     user = {
      name = "rahul gotrekiya";
      email = "121397381+RahulGotrekiya@users.noreply.github.com";
     };

     init.defaultBranch = "master";
     pull.rebase = false;
     push.autoSetupRemote = true;

     core.editor = "nvim";
    };
  };
 
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

 system.stateVersion = "23.11"; # Did you read the comment?
}
