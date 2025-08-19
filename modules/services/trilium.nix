{ config, pkgs, ... }:

{

  networking.firewall = {
    allowedTCPPorts = [
      8080
    ];
  };

  services.trilium-server = {
    enable = true;
    host = "0.0.0.0";
  };
}
