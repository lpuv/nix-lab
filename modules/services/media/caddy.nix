{ pkgs, config, lib, ... }:

{
  services.caddy = {
    enable = true;
    package = pkgs.caddy.withPlugins {
      plugins = [ "github.com/caddy-dns/cloudflare@v0.2.2" ];
      hash = "sha256-VBmICI1wklu02jmgDRmmlfNc9ftK7a74uF280xzx8uc=";
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
