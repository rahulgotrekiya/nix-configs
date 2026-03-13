{
  description = "NixOS configs — multi-host, multi-user";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, sops-nix, ... }:
    let
      myLib = import ./lib {
        inherit nixpkgs home-manager sops-nix;
        src = self;
      };
    in {
      nixosConfigurations = {
        # Laptop (HP Victus)
        victus = myLib.mkHost {
          hostname = "victus";
          user     = "rahul";
          homeModule = ./users/rahul;
        };

        # Homelab (HP ENVY x360)
        homelab = myLib.mkHost {
          hostname = "homelab";
          user     = "neo";
          homeModule = ./users/neo;
          extraModules = [
            ./modules/nixos/server
            ./secrets/sops.nix
          ];
        };

        # To add a new host:
        # myhost = myLib.mkHost {
        #   hostname    = "myhost";
        #   user        = "username";
        #   homeModule  = ./users/username;    # optional
        #   extraModules = [];                 # optional
        # };
      };
    };
}
