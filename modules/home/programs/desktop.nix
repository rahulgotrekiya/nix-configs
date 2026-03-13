# Desktop-only programs — terminals, keyboard remapper
# NOT imported by server users
{ ... }:

{
  imports = [
    ./alacritty.nix
    ./kitty.nix
    ./kanata.nix
  ];
}
