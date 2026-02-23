{ config, pkgs, ... }:

{
  # Bootloader configuration
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
    kernelParams = [
      "quiet"
      "loglevel=3"
    ];
  };

  services.logind.settings = {
    Login = {
      HandleLidSwitch = "suspend";
      HandleLidSwitchExternalPower = "suspend";
      HandleLidSwitchDocked = "ignore";
    };
  };

  # Automatic updating
  system.autoUpgrade = {
    enable = true;
    dates = "weekly";
  };

  # Automatic cleaning
  nix = {
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 3d";
    };
    settings.auto-optimise-store = true;
  };

  # Set time zone
  time.timeZone = "Asia/Kolkata";

  # Select internationalization properties
  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [ "en_US.UTF-8/UTF-8" "en_IN/UTF-8" ];
  };

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

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # This value determines the NixOS release
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11";
}
