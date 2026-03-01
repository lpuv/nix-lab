{ pkgs, config, ... }:
{
  services.sonarr = {
    enable = true;
    group = "media";
  };

  systemd.services.sonarr.serviceConfig = {
    SystemCallFilter = [ "@system-service" ];
  };

  services.caddy.virtualHosts."sonarr.media.internal.craftcat.dev" = {
    extraConfig = ''
      import ${config.age.secrets.caddy.path}
      reverse_proxy http://localhost:8989
    '';
  };
}
