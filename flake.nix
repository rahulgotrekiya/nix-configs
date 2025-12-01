{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      nixosConfigurations = {
        # Laptop/desktop configuration
        nixos = lib.nixosSystem {
          inherit system;
          modules = [ ./nixos/configuration.nix ];
        };

        # home server configuration
        homelab = lib.nixosSystem {
          inherit system;
          specialArgs = {
            meta = { 
              hostname = "homelab";
            };
          };
          modules = [
            ./homelab/configuration.nix
          ];
        };
      };

      homeConfigurations = {
        rahul = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./home/home.nix ];
        };
        
        # Optional: separate home-manager config for homelab user
        # neo = home-manager.lib.homeManagerConfiguration {
        #   inherit pkgs;
        #   modules = [ ./homelab/home.nix ];
        # };
      };
    };
}