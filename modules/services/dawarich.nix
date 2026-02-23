{ config, pkgs, ... }:

{


  networking.firewall = {
    allowedTCPPorts = [
      3000
    ];
  };

  services.dawarich = {
    enable = true;
    user = "dawarich";
    group = "dawarich";
    localDomain = "timeline.craftcat.dev";
    environment = {
      TIME_ZONE = "America/Toronto";
      PHOTON_API_HOST = "photon.komoot.io";
      PHOTON_API_USE_HTTPS = "true";
    };
  };
}
