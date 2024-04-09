{ pkgs, config, ... }:
{
  services.jellyfin = {
    enable = true;
    group = "media";
    openFirewall = true;
    dataDir = "/mnt/media-config/jellyfin";
    configDir = "/mnt/media-config/jellyfin";
  };

  # Ensure that jellyfin waits for the downloads and media directories to be
  # available.
  systemd.services.jellyfin = {
    after = [
      "network.target"
      "mnt-media.automount"
    ];
    serviceConfig = {
      TimeoutStopSec = 5;
      # hardening
      # NoNewPrivileges = true;
      # PrivateTmp = true;
      # PrivateDevices = true;
      # DevicePolicy = "closed";
      # ProtectSystem = "strict";
      # ReadWritePaths = cfg.dataDir;
      # ProtectHome = "read-only";
      # ProtectControlGroups = true;
      # ProtectKernelModules = true;
      # ProtectKernelTunables = true;
      # RestrictAddressFamilies= [ "AF_UNIX" "AF_INET" "AF_INET6" "AF_NETLINK" ];
      # RestrictNamespaces = true; # can't use because of need for FHS env
      # RestrictRealtime = true;
      # RestrictSUIDSGID = true;
      # MemoryDenyWriteExecute = true;
      # LockPersonality = true;
    };
  };
}