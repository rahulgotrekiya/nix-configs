# Laptop-specific NixOS configuration
{ config, pkgs, lib, meta, ... }:

{
  imports = [
    ./hardware.nix

    # Desktop environment & window manager
    ../../modules/nixos/desktop

    # LAMP stack for local web development
    ../../modules/nixos/desktop/lamp.nix

    # Laptop-specific modules
    ./battery-monitor.nix
   ];

  # NVIDIA Prime — hardware-specific PCI bus IDs for HP Victus (i5-12450H + RTX 2050)
  hardware.nvidia.prime = {
    offload = {
      enable = true;
      enableOffloadCmd = true;
    };
    intelBusId = "PCI:0:2:0";   # integrated
    nvidiaBusId = "PCI:1:0:0";  # dedicated
  };
  hardware.nvidia.forceFullCompositionPipeline = true;

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
    kernelParams = [ "quiet" "loglevel=3" "resume=/dev/disk/by-uuid/9b315aed-860d-42e9-8519-aead7b91b6c0" ];
  };

  # Lid switch behavior — using hibernate instead of suspend
  # (HP Victus BIOS doesn't support S3 sleep properly with NVIDIA)
  services.logind.settings.Login = {
    HandleLidSwitch = "hibernate";
    HandleLidSwitchExternalPower = "hibernate";
    HandleLidSwitchDocked = "ignore";
    HandlePowerKey = "hibernate";
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

  # User account — uses meta.user instead of hardcoded name
  users.users.${meta.user} = {
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

  # SSH
  services.openssh.enable = true;

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

  # NTFS work partition
  fileSystems."/mnt/work" = {
    device = "/dev/disk/by-uuid/8246945646944D33";
    fsType = "ntfs-3g";
    options = [ "rw" "uid=1000" "gid=100" "dmask=022" "fmask=133" "nofail" "windows_names" ];
  };
  systemd.tmpfiles.rules = [ "d /mnt/work 0755 root root -" ];

  environment.systemPackages = with pkgs; [
    kanata
    fastfetch
    vscodium
    bibata-cursors
    dosbox
    gcc
    awscli
    easyeffects
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
