{ config, pkgs, lib, ... }:

{
  # Enable the AdGuard Home service and automatically open the
  # required firewall ports for the DNS server and the web UI.
  # All specific configuration will be done in the host file.
  services.adguardhome = {
    enable = true;
    openFirewall = true; # This handles both TCP and UDP ports automatically.
  };
}

