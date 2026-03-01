{ lib, config, ... }:
{
  services.radarr = {
    enable = true;
    group = "media";
    user = "radarr";
  };

  systemd.services.radarr.serviceConfig = {
    # Revert #483483
    # LXC handles the isolation; systemd trying to do it again breaks .NET for some reason
    PrivateDevices = lib.mkForce false;
    PrivateUsers = lib.mkForce false;
    ProtectProc = lib.mkForce "default";
    RestrictNamespaces = lib.mkForce false;
  
    # Allow .NET to access the host's entropy/randomness
    SystemCallFilter = lib.mkForce [ ];
  
    # Required for .NET JIT in restricted environments
    MemoryDenyWriteExecute = lib.mkForce false;
  };

  services.caddy.virtualHosts."radarr.media.internal.craftcat.dev" = {
    extraConfig = ''
      import ${config.age.secrets.caddy.path}
      reverse_proxy http://localhost:7878
    '';
  };

}
