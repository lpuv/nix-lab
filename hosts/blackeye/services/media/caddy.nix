{ pkgs, config, ... }:
{
  services.caddy = {
    enable = true;
    # Custom package to allow for plugins
    package = (pkgs.callPackage ../../../../packages/caddy.nix {
    plugins = [
        "github.com/caddy-dns/cloudflare"
        "github.com/caddyserver/forwardproxy"
      ];
    });
    globalConfig = ''
      servers {
        metrics
      }
    '';
    extraConfig = ''
      import ${config.age.secrets.caddy.path}
    '';
    # service-specific config for Caddy reverse-proxying located
    # in each service file (ie sabnzbd.nix, etc.)
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}