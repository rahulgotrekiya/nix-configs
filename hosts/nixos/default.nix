# Laptop-specific NixOS configuration
{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware.nix

    # Desktop environment & window manager
    ../../modules/desktop

    # Laptop-specific modules
    ./battery-monitor.nix
  ];

  # Bootloader (GRUB for dual-boot)
  boot = {
    loader = {
      timeout = 1;
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        default = "saved";
        devices = [ "nodev" ];
        efiSupport = true;
        useOSProber = true;
      };
    };
    kernelParams = [ "quiet" "loglevel=3" ];
  };

  # Lid switch behavior
  services.logind.settings.Login = {
    HandleLidSwitch = "suspend";
    HandleLidSwitchExternalPower = "suspend";
    HandleLidSwitchDocked = "ignore";
  };

  # Auto upgrade
  system.autoUpgrade = {
    enable = true;
    dates = "weekly";
  };

  # Extended locale settings
  i18n.supportedLocales = [ "en_US.UTF-8/UTF-8" "en_IN/UTF-8" ];
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Tailscale as client
  services.tailscale.useRoutingFeatures = "client";
  systemd.services.NetworkManager-wait-online.enable = false;

  # Shell
  environment.shells = with pkgs; [ zsh ];
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;

  # User account
  users.users.rahul = {
    isNormalUser = true;
    description = "Rahul Gotrekiya";
    extraGroups = [ "networkmanager" "wheel" "docker" "input" "uinput" ];
    shell = pkgs.zsh;
  };

  # Audio (PipeWire)
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # SSH & GPG
  services.openssh.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Flatpak
  services.flatpak.enable = true;

  # Docker
  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
  };

  # Kanata keyboard remapping
  boot.kernelModules = [ "uinput" ];
  users.groups.uinput = {};
  services.udev.extraRules = ''
    KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"
  '';

  # VirtualBox
  virtualisation.virtualbox.host = {
    enable = true;
    enableExtensionPack = true;
  };
  users.extraGroups.vboxusers.members = [ "rahul" ];

  # NTFS work partition
  fileSystems."/mnt/work" = {
    device = "/dev/disk/by-uuid/8246945646944D33";
    fsType = "ntfs-3g";
    options = [ "rw" "uid=1000" "gid=100" "dmask=022" "fmask=133" "nofail" "windows_names" ];
  };
  systemd.tmpfiles.rules = [ "d /mnt/work 0755 root root -" ];

  # LAMP stack for development
  networking.firewall.allowedTCPPorts = [ 80 443 ];
  services.httpd = {
    enable = true;
    enablePHP = true;
    phpPackage = pkgs.php83;
    extraModules = [ "alias" ];
    virtualHosts."localhost" = {
      documentRoot = "/mnt/work/study/projects/php-root";
    };
    extraConfig = ''
      DirectoryIndex index.php index.html
      <Directory "/mnt/work/study/projects/php-root">
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
      </Directory>

      Alias /phpmyadmin "/var/www/php-projects/phpmyadmin"
      <Directory "/var/www/php-projects/phpmyadmin">
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
      </Directory>
    '';
  };
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
    ensureDatabases = [ "phpmyadmin" ];
    ensureUsers = [{
      name = "phpmyadmin";
      ensurePermissions = { "*.*" = "ALL PRIVILEGES"; };
    }];
  };

  environment.systemPackages = with pkgs; [
    kanata
    fastfetch
    vscodium
    bibata-cursors
    dosbox
    gcc
    docker-compose
    awscli
    easyeffects
    vagrant
    php
    mariadb
  ];

  # HP Victus firmware
  hardware.firmware = with pkgs; [ sof-firmware ];
  programs.firefox.enable = true;

  # Battery monitor service
  services.battery-monitor = {
    enable = true;
    normalLevels = [ 30 20 15 ];
    criticalLevel = 10;
    criticalIntervalSeconds = 1;
    hibernateLevel = 5;
    chargerNotifications = true;
  };

  system.stateVersion = "24.11";
}
