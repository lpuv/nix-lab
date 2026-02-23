{ config, pkgs, ... }:

{

  networking.firewall = {
    allowedTCPPorts = [
      8123
    ];
  };

    virtualisation.oci-containers.containers.homeassistant = {
      volumes = [
        "/var/lib/homeassistant:/config"
        "/etc/localtime:/etc/localtime:ro"
        "/run/dbus:/run/dbus:ro"
      ];
      environment.TZ = "America/Toronto";
      image = "ghcr.io/home-assistant/home-assistant:stable"; # Warning: if the tag does not change, the image will not be updated
      extraOptions = [ 
        "--network=host" 
      ];
      labels = { "io.containers.autoupdate" = "registry"; };
      user = "root";
    };



}
