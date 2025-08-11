{ config, lib, pkgs, ... }:
{
  services.prowlarr = {
    enable = true;
  };

  services.caddy.virtualHosts."prowlarr.media.internal.craftcat.dev" = {
    extraConfig = ''
      import ${config.age.secrets.caddy.path}
      reverse_proxy http://localhost:9696
    '';
  };
}
