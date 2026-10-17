{ pkgs, config, lib, ... }:

{
  services.caddy = {
    enable = true;
    package = pkgs.caddy.withPlugins {
      plugins = [ "github.com/caddy-dns/cloudflare@v0.2.4" ];
      hash = "sha256-Oirb6ZtU/c6C/SfICWpfBAEGDTepWShPQdWW0LlhF20=";
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
