{ config, pkgs, inputs, ... }:

{
  # Import shared configurations and the specific service module.
  imports = [
    ../modules/common.nix  
    ../modules/services/receipts.nix
  ];

  # Set the hostname for this container.
  # This must match the node name in your flake.nix.
  networking.hostName = "receipts";

  systemd.tmpfiles.rules = [
    "d /srv/receipts/database 0770 root root -"
    "d /srv/receipts/data 0770 root root -"
    "d /srv/endings/sqlite 0770 root root -"
  ];
  
  # This secret will be decrypted on this host and placed in the specified file.
  age.secrets = {
    "receipt-wrangler-db" = {
      file = ../secrets/receipt-wrangler-db.env.age;
      owner = "root"; # The user defined in the service module
      group = "root"; # The group defined in the service module
    };
    "receipt-wrangler-redis" = {
      file = ../secrets/receipt-wrangler-redis.env.age;
      owner = "root";
      group = "root";
    };
    "receipt-wrangler" = {
      file = ../secrets/receipt-wrangler.env.age;
      owner = "root";
      group = "root";
    };
  };
}

