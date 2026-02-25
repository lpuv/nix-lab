{ config, pkgs, inputs, ... }:

{
  virtualisation.oci-containers.containers."checkmk" = {
    image = "docker.io/checkmk/check-mk-raw:2.4.0-latest";
    
    ports = [
      "8080:5000"
      "8000:8000"
    ];
    
    volumes = [
      # Using a named volume isolates the data from host user
      "checkmk_sites:/omd/sites"
      "/etc/localtime:/etc/localtime:ro"
    ];
    
    extraOptions = [ 
      # Grants Checkmk the ability to ping other containers
      "--cap-add=NET_RAW"    
    ];
    labels = { "io.containers.autoupdate" = "registry"; };
  };

  networking.firewall.allowedTCPPorts = [ 8080 8000 3000 ];
}
