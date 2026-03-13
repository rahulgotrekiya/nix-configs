# Common programs — safe for ALL machines (desktop + server)
{ ... }:

{
  imports = [
    ./neovim.nix
    ./git.nix
    ./tmux.nix
    ./yazi.nix
  ];
}
