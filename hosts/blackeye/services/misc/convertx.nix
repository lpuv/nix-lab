 { config, pkgs, ... }:
 {


  config.virtualisation.oci-containers.containers = {
    convertx = {
      image = "ghcr.io/c4illin/convertx";
      ports = ["3033:3000"];
      volumes = [
        "/mnt/media/convertx:/app/data"
      ];
      environment = {
        AUTO_DELETE_EVERY_N_HOURS = "24";
        ACCOUNT_REGISTRATION = "false";
        ALLOW_UNAUTHENTICATED = "false";
      };
      user = "root";
    };
  };

 }
