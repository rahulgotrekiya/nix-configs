# Shared base config — applied to ALL hosts
{ config, pkgs, meta, ... }:

{
  nix = {
    package = pkgs.nix;
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  # Timezone & locale
  time.timeZone = "Asia/Kolkata";
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "us";

  # Hostname from specialArgs
  networking.hostName = meta.hostname;
  networking.networkmanager.enable = true;

  # Default editor (system-wide)
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
  };

  # Tailscale — zero-config VPN on every host
  services.tailscale.enable = true;

  # Base packages available on every machine
  environment.systemPackages = with pkgs; [
    git
    wget
    htop
    tree

    # sops tools
    sops
    age
    ssh-to-age
  ];

  # Allow unfree
  nixpkgs.config.allowUnfree = true;
}
