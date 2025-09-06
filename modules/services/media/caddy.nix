{ pkgs, config, lib, ... }:

{
  services.caddy = {
    enable = true;
    package = pkgs.caddy.withPlugins {
      plugins = [ "github.com/caddy-dns/cloudflare@v0.2.1" ];
      hash = "sha256-AcWko5513hO8I0lvbCLqVbM1eWegAhoM0J0qXoWL/vI=";
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
