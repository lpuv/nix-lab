 { config, pkgs, ... }:
 {
  config.virtualisation.oci-containers.containers = {
    transmission = {
      image = "docker.io/haugene/transmission-openvpn:5.3";
      ports = ["9091:9091"];
      volumes = [
        "/media/torrents:/media/torrents"
        "/media/config/transmission:/config"
      ];
      environment = {
        CREATE_TUN_DEVICE = "false";
        TZ = "America/Toronto";
        OPENVPN_PROVIDER = "mullvad";
        OPENVPN_CONFIG = "ca_mtr";
        TRANSMISSION_WEB_HOME = "/config/flood-for-transmission/";
        LOCAL_NETWORK = "192.168.2.0/24";
        WHITELIST = "*.*.*.*";
      };
      user = "root";
      environmentFiles = [
        config.age.secrets."transmission.env".path
      ];
      extraOptions = [
        "--cap-add=NET_ADMIN"
        "--device=/dev/net/tun"
      ];
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
