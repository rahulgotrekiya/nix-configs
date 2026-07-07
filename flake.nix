{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nix-index-database, ... }:
    let
      system = "x86_64-linux";
      lib    = nixpkgs.lib;
    in {
      nixosConfigurations.victus = lib.nixosSystem {
        inherit system;
        modules = [
          ./hosts/victus
          ./modules/base.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs   = true;
            home-manager.useUserPackages = true;
            home-manager.users.rahul     = import ./home;
            # inject nix-index-database module into every HM user
            home-manager.sharedModules   = [
              nix-index-database.homeModules.nix-index
            ];
          }
        ];
      };
    };
}
