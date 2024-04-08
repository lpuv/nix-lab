 { config, pkgs, ... }:
 {
   config.virtualisation.oci-containers.containers = {
     transmission = {
       image = "haugene/transmission-openvpn:5.3";
       ports = ["9091:9091"];
       volumes = [
         "/mnt/media/torrents:/data/torrents"
         "/mnt/media/config/transmission:/config"
       ];
       environment = {
        CREATE_TUN_DEVICE = "false";
        TZ = "America/Los_Angeles";
        OPENVPN_PROVIDER = "mullvad";
        OPENVPN_CONFIG = "us_lax";
        TRANSMISSION_WEB_HOME = "/config/flood-for-transmission/";
        LOCAL_NETWORK = "192.168.2.0/24";
        WHITELIST = "*.*.*.*";
       };
       environmentFiles = [
        config.age.secrets.transmission.path
       ];
       extraOptions = [
        "--cap-add NET_ADMIN"
        "--device=/dev/net/tun"
       ];
     };
   };
 }
