# Common home-manager config — imported by ALL user profiles.
# Shell config is NOT included here — each user picks their own:
#   shell.nix         → full desktop shell (oh-my-posh, zplug, zoxide)
#   shell-server.nix  → minimal server shell (starship, basic zsh)
{ config, pkgs, meta, ... }:

{

  # Common CLI packages (available on every machine)
  home.packages = with pkgs; [
    eza
    bat
    fzf
    btop
    lazygit
    dysk

    # Password manager
    pass
    gnupg
    pinentry-tty
  ];
}
