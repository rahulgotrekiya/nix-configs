# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, meta, ... }:

{
  imports = [
    # Include the results of the hardware scan
    ./hardware-configuration.nix
  ];

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # Use the systemd-boot EFI boot loader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = meta.hostname;
  # Pick only one of the below networking options
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default

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
    extraGroups = [ "wheel" ]; # Enable 'sudo' for the user
    packages = with pkgs; [
      tree
    ];
    # Created using mkpasswd
    hashedPassword = "$6$ZfLXV/9Kczid8V55$76pdYdfd2yjVmxqYuv82m9ePJJ4GkjdBifsFPi/GNPN2PbwLjfJW8qJZdyFkwjeKDLCCi1YfZlCsr6iOUJHAu/";
  };

  # List packages installed in system profile
  environment.systemPackages = with pkgs; [
    neovim
    cifs-utils
    nfs-utils
    git
    wget
    htop
    btop
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
 
  # Open ports in the firewall
  # networking.firewall.allowedTCPPorts = [ 80 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether
  networking.firewall.enable = false;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?
}
