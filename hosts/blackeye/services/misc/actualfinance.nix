 { config, pkgs, ... }:
 {


  config.virtualisation.oci-containers.containers = {
    actual_server = {
      image = "docker.io/actualbudget/actual-server:latest";
      ports = ["5006:5006"];
      volumes = [
        "/mnt/media/actual:/data"
      ];
      environment = {
      };
      user = "root";
    };
  };

 }
