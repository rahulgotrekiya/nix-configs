{ lib, desktop, ... }:

{
  imports = [
    ./git.nix
    ./tmux.nix
    ./neovim.nix
    ./direnv.nix
  ] ++ lib.optionals desktop [
    ./alacritty.nix   # GUI terminal emulators - laptop only
    ./kitty.nix
  ];
}
