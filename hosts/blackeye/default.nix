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
  ];

  system.stateVersion = "23.11"; # DO NOT EDIT
}
