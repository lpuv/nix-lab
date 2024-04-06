{
  inputs,
  lib,
  pkgs,
  config,
  ...
}:
{
  imports = [
    ./hardware.nix
    ./secrets.nix
    ./networking.nix
  ];

  system.stateVersion = "23.11"; # DO NOT EDIT
}
