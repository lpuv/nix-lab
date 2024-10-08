 { config, pkgs, ... }:
 {


  config.virtualisation.oci-containers.containers = {
    libregrammar = {
      image = "registry.gitlab.com/py_crash/docker-libregrammar";
      ports = ["8081:8081"];
      volumes = [
        "/mnt/media/ngrams/:/ngrams"
      ];
      environment = {
        langtool_maxCheckTimeWithApiKeyMillis = "1000000";
        langtool_languageModel = "/ngrams";
        langtool_maxCheckTimeMillis = "1000000";
        Java_Xms = "512m";
        Java_Xmx = "2g";
      };
      user = "root";
     };
   };

 }
