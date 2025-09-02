{
  config,
  pkgs,
  inputs,
  ...
}:

{
  # Import shared configurations and the specific service module.
  imports = [
    ../modules/common.nix
    ../modules/services/firefly.nix
  ];

  # Set the hostname for this container.
  # This must match the node name in your flake.nix.
  networking.hostName = "finance";

  users.groups.firefly = {};
  users.users.firefly = {
    isSystemUser = true; # It's a service user, not a person.
    group = "firefly";
    # The user needs a home directory to write data to.
    home = config.services.firefly-iii.dataDir;
  };

  # secrets
  age.secrets = {
    "firefly-app-key" = {
      # This file will contain the 32-character random key for Firefly III.
      file = ../secrets/firefly-app-key.age;
      owner = "firefly";
      group = "firefly";
    };
  };
}
