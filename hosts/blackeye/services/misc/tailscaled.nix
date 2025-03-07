
{ config, pkgs, ... }:

{
  services.tailscale = {
    enable = true;
    
    # Enable IP forwarding for subnet routing
    useRoutingFeatures = "server";
    
    extraUpFlags = [
      "--advertise-routes=192.168.2.0/24"
    ];
  };
  
  # Enable IP forwarding at the system level
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };
  
  # Ensure tailscale is accessible through the firewall
  networking.firewall = {
    enable = true;
    allowedUDPPorts = [ 41641 ]; # Tailscale's default port
    checkReversePath = "loose"; # Important for correct routing
    trustedInterfaces = [ "tailscale0" ];
  };
}
