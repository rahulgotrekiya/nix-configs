{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, sops-nix, ... }:
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      nixosConfigurations = {
        # Laptop/desktop configuration
        nixos = lib.nixosSystem {
          inherit system;
          modules = [
	    ./nixos/configuration.nix
	    sops-nix.nixosModules.sops  # sops module
 	  ];
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
	    sops-nix.nixosModules.sops  # sops module
          ];
        };
      };

      homeConfigurations = {
        rahul = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ 
	    ./home/home.nix 
	    sops-nix.homeManagerModules.sops 
	  ];
        };
        
        # Optional: separate home-manager config for homelab user
        # neo = home-manager.lib.homeManagerConfiguration {
        #   inherit pkgs;
        #   modules = [ ./homelab/home.nix ];
        # };
      };
    };
}
