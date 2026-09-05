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

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, nix-index-database, sops-nix, ... }:
    let
      system = "x86_64-linux";
      inherit (nixpkgs) lib;

      # Helper — define a host in one line.
      # hostname   → ./hosts/${hostname}
      # user       → login user (threaded to modules + home-manager as `username`)
      # homeModule → home-manager entry (null = no home-manager, e.g. servers)
      # extraModules → opt-in feature modules (server services, etc.)
      mkHost = { hostname, user ? "rahul", homeModule ? null, extraModules ? [] }:
        lib.nixosSystem {
          inherit system;
          specialArgs = { meta = { inherit hostname; }; username = user; };
          modules = [
            ./hosts/${hostname}
            ./modules/base.nix
            sops-nix.nixosModules.sops
          ]
          ++ lib.optionals (homeModule != null) [
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs       = true;
              home-manager.useUserPackages     = true;
              home-manager.backupFileExtension = "backup";
              home-manager.extraSpecialArgs    = { username = user; };
              home-manager.users.${user}       = import homeModule;
              home-manager.sharedModules       = [
                nix-index-database.homeModules.nix-index
              ];
            }
          ]
          ++ extraModules;
        };
    in {
      nixosConfigurations = {
        # Laptop (HP Victus)
        victus = mkHost {
          hostname   = "victus";
          user       = "rahul";
          homeModule = ./home;
        };

        # Homelab (HP ENVY x360 repurposed as a server)
        homelab = mkHost {
          hostname     = "homelab";
          user         = "neo";
          extraModules = [
            ./modules/server/docker.nix
            ./modules/server/media-server.nix
            ./modules/server/monitoring.nix
            ./modules/server/networking.nix
            ./modules/server/file-sharing.nix
            ./modules/server/cloudflare-tunnel.nix
            ./modules/server/filebrowser.nix
            ./modules/server/glance.nix
            ./modules/server/immich.nix
            ./modules/server/utsuru.nix
            ./secrets/sops.nix
          ];
        };
      };
    };
}
