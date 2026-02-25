{ config, pkgs, inputs, ... }:

{
  virtualisation.oci-containers.containers."grafana" = {
    image = "docker.io/grafana/grafana-oss:latest";
    ports = [
      "3000:3000"
    ];
    volumes = [
      "grafana_data:/var/lib/grafana"
    ];
    environment = {
      # This tells Grafana to automatically download the Checkmk plugin on startup!
      GF_INSTALL_PLUGINS = "checkmk-cloud-datasource"; 
    };
    labels = { "io.containers.autoupdate" = "registry"; };
  };
}
