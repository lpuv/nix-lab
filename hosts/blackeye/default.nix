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
    ./storage.nix


    # Services
    ./services/misc/cachix.nix
    ./services/misc/cloudflared.nix

    # Media
    ./services/media/caddy.nix
    ./services/media/transmission.nix
    ./services/media/sonarr.nix
    ./services/media/jellyfin.nix
    ./services/media/prowlarr.nix
    ./services/flaresolverr.nix
  ];

  system.stateVersion = "23.11"; # DO NOT EDIT
}
