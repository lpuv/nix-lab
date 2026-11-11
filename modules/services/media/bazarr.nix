{
  pkgs,
  config,
  lib,
  ...
}:
{
  services.bazarr = {
    enable = true;
    user = "bazarr";
    group = "media";
  };

  # The upstream module's sandboxing (PrivateDevices/PrivateUsers) breaks
  # access to /dev/null inside this LXC container.
  systemd.services.bazarr.serviceConfig = {
    PrivateDevices = lib.mkForce false;
    PrivateUsers = lib.mkForce false;
  };

  services.caddy.virtualHosts."bazarr.media.internal.craftcat.dev" = {
    extraConfig = ''
      import ${config.age.secrets.caddy.path}
      reverse_proxy http://localhost:6767
    '';
  };

}
