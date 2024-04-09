{ pkgs, config, ... }:
{
  services.caddy = {
    enable = true;
    # Custom package to allow for plugins, once https://github.com/NixOS/nixpkgs/pull/259275 is merged, delete this!
    package = (pkgs.callPackage ../../../../packages/caddy.nix {
      externalPlugins = [
        { name = "caddy-dns/cloudflare"; repo = "github.com/caddy-dns/cloudflare"; version = "44030f9306f4815aceed3b042c7f3d2c2b110c97"; }
      ];
      vendorHash = "sha256-XucTo6zMHXQfyAQU/V/eveQTZh4hzLhkUFv2mD3Jxi0=";  # Add this, as explained in https://github.com/NixOS/nixpkgs/pull/259275#issuecomment-1763478985
    });
    globalConfig = ''
      servers {
        metrics
      }
    '';
    # extraConfig = ''
    #   import ${config.age.secrets.caddy.path}
    # '';
    # service-specific config for Caddy reverse-proxying located
    # in each service file (ie sabnzbd.nix, etc.)
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}