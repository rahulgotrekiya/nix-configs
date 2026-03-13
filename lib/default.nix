# Shared helper functions for the flake
{ nixpkgs, home-manager, sops-nix, src }:

let
  system = "x86_64-linux";
  lib = nixpkgs.lib;
  pkgs = nixpkgs.legacyPackages.${system};
in
{
  # mkHost
  # Build a full NixOS + home-manager system in one call.
  #
  #   mkHost {
  #     hostname     = "nixos";          # matches hosts/<hostname>
  #     user         = "rahul";          # primary user account name
  #     homeModule   = ../users/rahul;   # home-manager entry (null = no HM)
  #     extraModules = [];               # any additional NixOS modules
  #   }
  mkHost = {
    hostname,
    user ? "rahul",
    homeModule ? null,
    extraModules ? [],
  }:
    lib.nixosSystem {
      inherit system;
      specialArgs = {
        meta = {
          inherit hostname user;
        };
      };
      modules = [
        (src + "/hosts/${hostname}")
        (src + "/modules/nixos/base.nix")
        sops-nix.nixosModules.sops
      ]
      ++ lib.optionals (homeModule != null) [
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.${user} = import homeModule;
          home-manager.extraSpecialArgs = {
            meta = {
              inherit hostname user;
            };
          };
        }
      ]
      ++ extraModules;
    };
}
