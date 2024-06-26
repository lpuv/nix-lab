{ pkgs, config, ... }:
{
  services.radarr = {
    enable = true;
    group = "media";
    # Sonarr hates config over NFS (sqlite issue apparently)
    #dataDir = "/mnt/media-config/sonarr-hd/";
  };

  services.caddy.virtualHosts."radarr.media.internal.craftcat.dev" = {
    extraConfig = ''
      import ${config.age.secrets.caddy.path}
      reverse_proxy http://localhost:7878
    '';
  };

  # Ensure that radarr waits for the downloads and media directories to be
  # available.
  systemd.services.radarr = {
    wantedBy = [ "multi-user.target" ];
    after = [
      "network.target"
      "mnt-media.automount"
    ];
  };
}
