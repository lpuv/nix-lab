{ pkgs, config, ... }:
{
  services.bazarr = {
    enable = true;
    user = "bazarr";
    group = "media";
  };

  services.caddy.virtualHosts."bazarr.media.internal.craftcat.dev" = {
    extraConfig = ''
      import ${config.age.secrets.caddy.path}
      reverse_proxy http://localhost:6767
    '';
  };

}
