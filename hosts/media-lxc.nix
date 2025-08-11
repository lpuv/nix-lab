{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ../modules/common.nix
    ../modules/services/media/bazarr.nix
    ../modules/services/media/caddy.nix
    ../modules/services/media/flaresolverr.nix
    ../modules/services/media/jellyfin.nix
    ../modules/services/media/prowlarr.nix
    ../modules/services/media/radarr.nix
    ../modules/services/media/sonarr.nix
    ../modules/services/media/transmission.nix
  ];

  networking.hostName = "media.internal.craftcat.dev";
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  # Enable OpenGL and add transcoding drivers
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      mesa
    ];
  };

  hardware.graphics.enable = true;

  environment.systemPackages = [
    pkgs.jellyfin
    pkgs.jellyfin-web
    pkgs.jellyfin-ffmpeg
  ];


  users.users = {
    bazarr = {
      isSystemUser = true;
      group = "media";
    };
    jellyfin = {
      isSystemUser = true;
      group = "media";
      extraGroups = [
        "render"
        "video"
      ];
    };
    prowlarr = {
      isSystemUser = true;
      group = "media";
    };
    radarr = {
      isSystemUser = true;
      group = "media";
    };
    sonarr = {
      isSystemUser = true;
      group = "media";
    };
    transmission = {
      isSystemUser = true;
      group = "media";
    };
  };
  users.groups.media = {
    gid = 992;
  };

  virtualisation.docker.enable = true;

  age.secrets = {
    "caddy" = {
      file = ../secrets/caddy.age;
      owner = "caddy";
      mode = "600";
    };
    "transmission.env".file = ../secrets/transmission.env.age;
  };
}
