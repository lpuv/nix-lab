 { lib, config, pkgs, ... }:
 {
  config.virtualisation.oci-containers.containers = {
    whisper = {
      image = "docker.io/mccloud/subgen";
      ports = ["9000:9000"];
      labels = { "io.containers.autoupdate" = "registry"; };
     };
   };
 }
