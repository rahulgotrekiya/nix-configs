# HP Victus — laptop-specific NixOS configuration
{ pkgs, username, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/desktop/nvidia.nix
    ../../modules/desktop/virtualisation.nix
    ../../modules/desktop/flatpak.nix
    ../../modules/desktop/kanata.nix
    ../../modules/desktop/packet-tracer.nix
    ../../modules/desktop/lamp.nix
    # DevOps toolchains — uncomment when needed
    # ../../modules/desktop/terraform.nix
    # ../../modules/desktop/ansible.nix
  ];

  # Bootloader (GRUB for dual-boot)
  boot = {
    loader = {
      timeout = 1;
      efi.canTouchEfiVariables = true;
      grub = {
        enable       = true;
        device       = "nodev";
        efiSupport   = true;
        useOSProber  = true;
        default      = "saved";
      };
    };

    kernelPackages = pkgs.linuxPackages_latest;

    # Quiet boot + NVIDIA suspend/resume fix
    kernelParams = [
      "quiet"
      "loglevel=3"
      "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
      "nvidia.NVreg_EnableS0ixPowerManagement=1"
      "nvidia-drm.fbdev=1"                              # enable dGPU framebuffer for HDMI output
    ];

    # Required for KVM virtualisation
    kernelModules  = [ "kvm-intel" ];

    # Explicitly set resume device to the swap partition so the swapfile below isn't picked by mistake
    resumeDevice = "/dev/disk/by-uuid/b19c406e-409c-4350-914d-772a1b62e88e";
  };

  # Lid switch behavior — using hibernate instead of suspend
  # (HP Victus BIOS doesn't support S3 sleep properly with NVIDIA)
  services.logind.settings.Login = {
    HandleLidSwitch = "hibernate";
    HandleLidSwitchExternalPower = "hibernate";
    HandleLidSwitchDocked = "ignore";
    HandlePowerKey = "hibernate";
  };

  # NTFS work partition
  fileSystems."/mnt/work" = {
    device = "/dev/disk/by-uuid/8246945646944D33";
    fsType = "ntfs-3g";
    options = [ "rw" "uid=1000" "gid=100" "dmask=022" "fmask=133" "nofail" "windows_names" ];
  };
  systemd.tmpfiles.rules = [ "d /mnt/work 0755 root root -" ];

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

  # Shell
  # Must be enabled at system level alongside home-manager's programs.zsh
  programs.zsh.enable        = true;
  environment.shells         = with pkgs; [ zsh ];
  users.defaultUserShell     = pkgs.zsh;

  # User account
  users.users.${username} = {
    isNormalUser = true;
    description  = "Rahul Gotrekiya";
    extraGroups  = [ "networkmanager" "wheel" ];
    shell        = pkgs.zsh;
  };

  # GNOME Desktop
  services.xserver = {
    enable = true;
    xkb = {
      layout  = "us";
      variant = "";
    };
  };

  services.displayManager.gdm.enable   = true;
  services.desktopManager.gnome.enable = true;

  # Audio (PipeWire)
  services.pulseaudio.enable = false;
  security.rtkit.enable      = true;
  services.pipewire = {
    enable            = true;
    alsa.enable       = true;
    alsa.support32Bit = true;
    pulse.enable      = true;
  };

  # HP Victus firmware
  # SOF firmware — required for HP Victus audio (Intel HDA codec)
  hardware.firmware = with pkgs; [ sof-firmware ];

  # Printing
  services.printing.enable = true;

  # Grant WebHID access to the Cosmic Byte Helios mouse (config interface is
  # root-only hidraw by default). VID a8a4 = Helios (YJX-CHIP controller); a8a5
  # covers the dongle/BT variant. We grant via GROUP="users" + MODE 0660 (rahul
  # is in "users"), which works regardless of rule ordering. uaccess is kept as
  # a bonus but is unreliable from 99-local.rules (seat-late runs earlier).
  services.udev.extraRules = ''
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="a8a4", GROUP="users", MODE="0660", TAG+="uaccess"
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="a8a5", GROUP="users", MODE="0660", TAG+="uaccess"
  '';

  # Firefox
  programs.firefox.enable = true;

  # System packages
  # Keep this minimal — user packages go in home/packages.nix via home-manager
  environment.systemPackages = with pkgs; [
    fastfetch
  ];

  # Add a swap file to avoid hibernation ENOSPC errors (-28)
  # This gives normal system usage a place to swap, leaving the partition empty for hibernation.
  swapDevices = [{
    device = "/var/lib/swapfile";
    size = 8192; # 8 GB
    priority = 100; # Higher priority ensures this is used before the partition
  }];

  system.stateVersion = "26.05";
}
