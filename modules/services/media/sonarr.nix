{ pkgs, config, ... }:
{
  services.sonarr = {
    enable = true;
    group = "media";
  };

  services.caddy.virtualHosts."sonarr.media.internal.craftcat.dev" = {
    extraConfig = ''
      import ${config.age.secrets.caddy.path}
      reverse_proxy http://localhost:8989
    '';
  };
}
