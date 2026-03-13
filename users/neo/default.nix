# User profile for Neo — homelab server (minimal, no desktop/WM/GUI)
{ config, pkgs, meta, ... }:

{
  imports = [
    ../../modules/home                 # common CLI packages
    ../../modules/home/shell-server.nix # minimal server shell (starship, basic zsh)
    ../../modules/home/programs        # common programs (git, neovim, tmux, yazi)
    # No desktop programs, WM, or GNOME config — this is a server
  ];

  home.username = meta.user;
  home.homeDirectory = "/home/${meta.user}";
  home.stateVersion = "24.05";

  home.sessionVariables = {
    LANG   = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
  };

  # Personal git identity
  programs.git.settings.user = {
    name = "rahul gotrekiya";
    email = "121397381+RahulGotrekiya@users.noreply.github.com";
  };

  programs.home-manager.enable = true;
  programs.zsh.enable = true;
}
