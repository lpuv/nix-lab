 { config, pkgs, ... }:
 {
  config.virtualisation.oci-containers.containers = {
    transmission = {
      image = "docker.io/haugene/transmission-wireguard:main";
      ports = ["9091:9091"];
      volumes = [
        "/media/torrents:/media/torrents"
        "/media/config/transmission:/config"
        "/media/config/transmission/wg-config:/wg-config"
      ];
      environment = {
        TZ = "America/Toronto";
        TRANSMISSION_WEB_HOME = "/config/flood-for-transmission/";
        LOCAL_NETWORK = "192.168.2.0/24";
        WHITELIST = "*.*.*.*";
        CONFIG_FILE = "/wg-config/ca-mtr-001.conf";
      };
      user = "root";
      extraOptions = [
        "--cap-add=NET_ADMIN"
        "--device=/dev/net/tun"
      ];
      privileged = true;
      labels = { "io.containers.autoupdate" = "registry"; };
     };
   };

  config.services.caddy.virtualHosts."dl.media.internal.craftcat.dev" = {
    extraConfig = ''
      import ${config.age.secrets.caddy.path}
      reverse_proxy http://127.0.0.1:9091
    '';
  };

  config.systemd.services."podman-transmission".serviceConfig = {
    # Wait 5 minutes before trying to restart the service after a failure.
    RestartSec = "5min";
  };
 }
