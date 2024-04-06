{
  description = "Homelab NixOS configuration";

  inputs = {
    # repos
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";
    cachix-deploy.url = "github:cachix/cachix-deploy-flake";

    # agenix
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    agenix,
    nixpkgs-stable,
    cachix-deploy
  }:
    let 
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      cachix-deploy-lib = cachix-deploy.lib pkgs;

    in 
    {
      nixosConfigurations = {
        blackeye = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = 
          [
            agenix.nixosModules.default
            ./hosts/common
            ./hosts/blackeye
          ];

        };
      };

      packages.${system} = with pkgs; {
        cachix-deploy-spec = cachix-deploy-lib.spec {
          agents = {
            blackeye = self.nixosConfigurations.blackeye.config.system.build.toplevel;
          };
        };
      };
    };
}