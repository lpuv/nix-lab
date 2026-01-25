 { lib, config, pkgs, ... }:
 {
  virtualisation.oci-containers.containers = {
    lingarr = {
      image = "docker.io/lingarr/lingarr:latest";
      ports = ["9876:9876"];
      volumes = [
        "/media/media:/media/media/"
        "/media/config/lingarr/:/app/config"
      ];
      environment = {
        ASPNETCORE_URLS = "http://+:9876";
      };
      extraOptions = [ "--dns=192.168.2.3" ];
      labels = { "io.containers.autoupdate" = "registry"; };
     };
   };

   services.caddy.virtualHosts."lingarr.media.internal.craftcat.dev" = {
    extraConfig = ''
      import ${config.age.secrets.caddy.path}
      reverse_proxy http://localhost:9876
    '';
  };
 }
