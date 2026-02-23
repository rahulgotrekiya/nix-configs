{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, sops-nix, ... }:
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;
      pkgs = nixpkgs.legacyPackages.${system};

      # Helper — define a host in one line
      mkHost = { hostname, user ? "rahul", homeModule ? null, extraModules ? [] }:
        lib.nixosSystem {
          inherit system;
          specialArgs = { meta = { inherit hostname; }; };
          modules = [
            ./hosts/${hostname}
            ./modules/base.nix
            sops-nix.nixosModules.sops
          ]
          ++ lib.optionals (homeModule != null) [
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${user} = import homeModule;
            }
          ]
          ++ extraModules;
        };
    in {
      nixosConfigurations = {
        # Laptop (HP Victus)
        nixos = mkHost {
          hostname = "nixos";
          homeModule = ./home;
          extraModules = [];
        };

        # Homelab (HP ENVY x360)
        homelab = mkHost {
          hostname = "homelab";
          user = "neo";
          extraModules = [
            ./modules/server/docker.nix
            ./modules/server/media-server.nix
            ./modules/server/monitoring.nix
            ./modules/server/networking.nix
            ./modules/server/file-sharing.nix
            ./modules/server/cloudflare-tunnel.nix
            ./modules/server/filebrowser.nix
            ./modules/server/glance.nix
            ./secrets/sops.nix
          ];
        };

        # To add a new host:
        # myhost = mkHost {
        #   hostname = "myhost";
        #   homeModule = ./home;             # optional
        #   extraModules = [ ./modules/server/docker.nix ];
        # };
      };
    };
}
