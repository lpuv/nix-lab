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


    # Infrastructure
    ./services/misc/cachix.nix
    ./services/misc/cloudflared.nix

    # Media
    ./services/media/caddy.nix
    ./services/media/transmission.nix
    ./services/media/sonarr.nix
    ./services/media/jellyfin.nix
    ./services/media/prowlarr.nix
    ./services/media/flaresolverr.nix

    ./services/git/forgejo.nix
  ];

  system.stateVersion = "23.11"; # DO NOT EDIT
}
