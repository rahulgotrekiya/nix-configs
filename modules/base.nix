# Shared base config — applied to ALL hosts
{ pkgs, meta, ... }:

{
  # Nix daemon settings
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
    };
    # Deduplicate identical store paths (replaces deprecated auto-optimise-store)
    optimise.automatic = true;
    # Garbage collect old generations automatically
    gc = {
      automatic = true;
      dates     = "weekly";
      options   = "--delete-older-than 7d";
    };
  };

  # Timezone & locale
  time.timeZone      = "Asia/Kolkata";
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap     = "us";

  # Networking
  networking.hostName              = meta.hostname;
  networking.networkmanager.enable = true;

  # Allow unfree
  nixpkgs.config.allowUnfree = true;

  # Minimal packages available on every machine
  environment.systemPackages = with pkgs; [
    git
    wget
    curl
    htop
    tree
    wl-clipboard
  ];
}
