{
  inputs,
  lib,
  pkgs,
  config,
  ...
}:
{
  imports = [

    # Server Setup
    ./hardware.nix
    ./secrets.nix
    ./networking.nix


    # Services
    ./services/misc/cachix.nix
  ];

  system.stateVersion = "23.11"; # DO NOT EDIT
}
