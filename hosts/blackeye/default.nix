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
    ./services/misc/tailscale.nix

    # Media
    ./services/media/caddy.nix
    ./services/media/transmission.nix
    ./services/media/sonarr.nix
    ./services/media/radarr.nix
    ./services/media/jellyfin.nix
    ./services/media/prowlarr.nix
    ./services/media/flaresolverr.nix

    ./services/git/forgejo.nix

    ./services/languagetool/libregrammar.nix
  ];

  system.stateVersion = "23.11"; # DO NOT EDIT
}
