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

  # secrets
  age.secrets = {
    "firefly-app-key" = {
      # This file will contain the 32-character random key for Firefly III.
      file = ../secrets/firefly-app-key.age;
      owner = config.services.firefly-iii.user;
      group = config.services.firefly-iii.group;
    };
  };
}
