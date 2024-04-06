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
    ./services/misc/cloudflared.nix
  ];

  system.stateVersion = "23.11"; # DO NOT EDIT
}
