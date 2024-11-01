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

    # lix (https://lix.systems)
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.1-1.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    agenix,
    lix-module,
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
            lix-module.nixosModules.default
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
