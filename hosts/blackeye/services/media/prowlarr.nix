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

  # if https://github.com/NixOS/nixpkgs/pull/302919 gets merged, will not need this anymore
  systemd.services.prowlarr = {
    serviceConfig = {
      ExecStart = lib.mkForce "${lib.getExe pkgs.prowlarr} -nobrowser -data=/mnt/media-config/prowlarr";
    };
  };
}