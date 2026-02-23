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

  # Editor
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
  };

  # Git (system-level)
  programs.git = {
    enable = true;
    config = {
      user.name = "rahul gotrekiya";
      user.email = "121397381+RahulGotrekiya@users.noreply.github.com";
      init.defaultBranch = "master";
      pull.rebase = false;
      push.autoSetupRemote = true;
      core.editor = "nvim";
    };
  };

  # Tailscale — zero-config VPN on every host
  services.tailscale.enable = true;

  # Base packages available on every machine
  environment.systemPackages = with pkgs; [
    git
    wget
    htop
    btop
    tree
    neovim

    # sops tools
    sops
    age
    ssh-to-age
  ];

  # Allow unfree
  nixpkgs.config.allowUnfree = true;
}
