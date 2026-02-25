{ config, pkgs, inputs, ... }:

{
  virtualisation.oci-containers.containers."checkmk" = {
    image = "checkmk/check-mk-raw:2.4.0-latest";
    
    ports = [
      "8080:5000"
      "8000:8000"
    ];
    
    volumes = [
      "checkmk_sites:/omd/sites"
      "/etc/localtime:/etc/localtime:ro"
    ];
    
    extraOptions = [ 
      "--tmpfs" "/opt/omd/sites/cmk/tmp" 
      "--cap-add=NET_RAW"
    ];
  };

  networking.firewall.allowedTCPPorts = [ 8080 8000 ];
}
