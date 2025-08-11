{ pkgs, config, ... }:
{
  services.radarr = {
    enable = true;
    group = "media";
    user = "radarr";
  };

  services.caddy.virtualHosts."radarr.media.internal.craftcat.dev" = {
    extraConfig = ''
      import ${config.age.secrets.caddy.path}
      reverse_proxy http://localhost:7878
    '';
  };

}
