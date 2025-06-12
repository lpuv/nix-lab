{ pkgs, config, ... }:
{
  services.bazarr = {
    enable = true;
    group = "media";
    # Bazarr hates config over NFS (sqlite issue apparently)
    #dataDir = "/mnt/media-config/sonarr-hd/";
  };

  services.caddy.virtualHosts."bazarr.media.internal.craftcat.dev" = {
    extraConfig = ''
      import ${config.age.secrets.caddy.path}
      reverse_proxy http://localhost:6767
    '';
  };

  # Ensure that bazarr waits for the downloads and media directories to be
  # available.
  systemd.services.bazarr = {
    wantedBy = [ "multi-user.target" ];
    after = [
      "network.target"
      "mnt-media.automount"
    ];
  };
}
