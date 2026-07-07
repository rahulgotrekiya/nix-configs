# Shared base config — applied to ALL hosts
{ pkgs, ... }:

{
  # Nix daemon settings
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store   = true;
    };
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
  networking.networkmanager.enable = true;

  # Editor
  programs.neovim = {
    enable        = true;
    defaultEditor = true;
    vimAlias      = true;
  };

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
