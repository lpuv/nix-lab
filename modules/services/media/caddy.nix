{ pkgs, config, lib, ... }:

{
  services.caddy = {
    enable = true;
    package = pkgs.caddy.withPlugins {
      plugins = [ "github.com/caddy-dns/cloudflare@v0.2.4" ];
      hash = "sha256-7GoH8YLCoPmPExQxoga2FHB58zQDoZVf1BBwkVi0SsQ=";
    };

    globalConfig = ''
      servers {
        metrics
      }
    '';
    logFormat = lib.mkForce "level INFO";
    # service-specific config for Caddy reverse-proxying located
    # in each service file (ie sonarr.nix, etc.)
  };
}
