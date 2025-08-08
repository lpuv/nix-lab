{ config, pkgs, inputs, agenixModule, ... }:

{
  # Import shared configurations and the specific service module.
  imports = [
    ../modules/common.nix  
    ../modules/services/panel.nix
  ];

  # Set the hostname for this container.
  # This must match the node name in your flake.nix.
  networking.hostName = "panel";

  systemd.tmpfiles.rules = [
    "d /srv/pyrodactyl 0770 root 82 -"
    "d /srv/pyrodactyl/database 0770 nscd nscd -"
    "d /srv/pyrodactyl/var 0770 root 82 -"
    "d /srv/pyrodactyl/nginx 0770 root 82 -"
    "d /srv/pyrodactyl/certs 0770 root 82 -"
    "d /srv/pyrodactyl/logs 0770 root 82 -"
    "d /var/lib/pterodactyl 0770 988 988 -"
    "d /var/log/pterodactyl 0770 988 988 -"
    "d /tmp/pterodactyl 0770 988 988 -"
  ];
  
  # This secret will be decrypted on this host and placed in the specified file.
  age.secrets = {
    "pyrodactyl-db" = {
      file = ../secrets/pyrodactyl-db.env.age;
      owner = "root"; # The user defined in the service module
      group = "root"; # The group defined in the service module
    };
    "pyrodactyl-panel" = {
      file = ../secrets/pyrodactyl-panel.env.age;
      owner = "root";
      group = "root";
    };
    "wings-config" = {
      file = ../secrets/wings-config.yml.age;
      owner = "root";
      group = "root";
    };
    "cloudflare" = {
      file = ../secrets/cloudflare.age;
      owner = "root";
      group = "root";
    };
  };
}

