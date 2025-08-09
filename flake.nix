{
  description = "A NixOS flake for managing my homelab";


  # ============================================================================
  # Flake Inputs
  # ============================================================================
  # Inputs are the external dependencies of your flake.
  # These are pinned in flake.lock to ensure reproducibility.
  inputs = {
    # The primary package set
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # A utility library to make flakes easier to write
    flake-utils.url = "github:numtide/flake-utils";

    # The deployment tool
    colmena = {
      url = "github:zhaofengli/colmena";
      # We need to follow the nixpkgs input of colmena to ensure
      # everything uses the same version of nixpkgs.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # agenix for secret management
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # ============================================================================
  # Flake Outputs
  # ============================================================================
  # Outputs are the "products" of your flake. These can be packages,
  # NixOS configurations, or, in our case, a Colmena hive.
# ============================================================================
  # Flake Outputs
  # ============================================================================
  # Outputs are the "products" of your flake. These can be packages,
  # NixOS configurations, or, in our case, a Colmena hive.
  outputs = { self, nixpkgs, agenix, colmena, ... }@inputs:
    let
      # Define the system architecture you are deploying to.
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      # The primary output for Colmena v0.5+
      # It must be named `colmenaHive`.
      colmenaHive = colmena.lib.makeHive self.outputs.colmena; 
      colmena = {
        meta = {
          # This allows Colmena to pass flake inputs to your configurations.
          # It's essential for accessing things like agenix.
          # flake-inputs = inputs;
          nixpkgs = pkgs;
        };

        # Default settings for all nodes in the hive.
        # You can override these per-node.
        defaults = {
          deployment.targetUser = "luna";

          # Special arguments that will be passed to all configurations.
          # This is useful for passing down `pkgs` or other global values.
          # specialArgs = 
          # { 
          #   inherit inputs system pkgs;
          # };

          imports = [
            agenix.nixosModules.default
          ];

          networking.domain = "internal.craftcat.dev";
        };

        # ====================================================================
        # Define each LXC as a "node" in the hive
        # ====================================================================
        # The key for each node must match the actual hostname of the container.
          # "media.media.internal.craftcat.dev" = {
          #   imports = [ ./hosts/media-lxc.nix ];
          #   # Colmena will SSH directly into this host to deploy.
          #   deployment.targetHost = "media.media.internal.craftcat.dev";
          # };

          # "languagetool.internal.craftcat.dev" = {
          #   imports = [ ./hosts/languagetool-lxc.nix ];
          #   deployment.targetHost = "languagetool.internal.craftcat.dev";
          # };

          # "open-webui.internal.craftcat.dev" = {
          #   imports = [ ./hosts/open-webui-lxc.nix ];
          #   deployment.targetHost = "open-webui.internal.craftcat.dev";
          # };

          # "trilium.internal.craftcat.dev" = {
          #   imports = [ ./hosts/trilium-lxc.nix ];
          #   deployment.targetHost = "trilium.internal.craftcat.dev";
          # };
        panel = {name, nodes, ...}: {
          imports = [ ./hosts/panel-lxc.nix ];
          deployment.targetHost = "panel.internal.craftcat.dev";
        };

        dns = {name, nodes, ...}: {
          imports = [ ./hosts/dns-lxc.nix ];
          deployment.targetHost = "dns.internal.craftcat.dev";
        };
      };

      # It's also good practice to expose the raw NixOS configurations.
      # This allows you to build them manually with `nixos-rebuild` if you ever need to.
      nixosConfigurations = {
        # "media-lxc" = nixpkgs.lib.nixosSystem {
        #   inherit system;
        #   specialArgs = { inherit inputs; };
        #   modules = [ ./hosts/media-lxc.nix ];
        # };
        # "languagetool-lxc" = nixpkgs.lib.nixosSystem {
        #   inherit system;
        #   specialArgs = { inherit inputs; };
        #   modules = [ ./hosts/languagetool-lxc.nix ];
        # };
        # "open-webui-lxc" = nixpkgs.lib.nixosSystem {
        #   inherit system;
        #   specialArgs = { inherit inputs; };
        #   modules = [ ./hosts/open-webui-lxc.nix ];
        # };
        # "trilium-lxc" = nixpkgs.lib.nixosSystem {
        #   inherit system;
        #   specialArgs = { inherit inputs; };
        #   modules = [ ./hosts/trilium-lxc.nix ];
        # };
        "panel-lxc" = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [ ./hosts/panel-lxc.nix ];
        };
        "dns-lxc" = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [ ./hosts/dns-lxc.nix ];
        };
      };
    };
}

