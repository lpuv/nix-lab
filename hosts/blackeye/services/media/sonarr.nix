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

  # Ensure that sonarr waits for the downloads and media directories to be
  # available.
  systemd.services.sonarr = {
    wantedBy = [ "multi-user.target" ];
    after = [
      "network.target"
      "mnt-media.automount"
    ];
  };
}