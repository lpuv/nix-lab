{ config, pkgs, ... }:

{


  networking.firewall = {
    allowedTCPPorts = [
      5000
    ];
  };

  services.changedetection-io = {
    enable = true;
    playwrightSupport = true;
    behindProxy = true;
    listenAddress = "0.0.0.0";
    baseURL = "https://changes.craftcat.dev";
  };

}
