{
  config,
  pkgs,
  inputs,
  ...
}:

{
  # Import shared configurations and the specific service module.
  imports = [
    ../modules/common.nix
    ../modules/services/checkmk-agent.nix
    ../modules/services/changedetection.nix
  ];

  systemd.tmpfiles.rules = [
    "d /srv/changedetection 0770 root root -"
  ];


  virtualisation.docker.enable = true;
  systemd.timers.podman-auto-update.wantedBy = [ "multi-user.target" ];

  # Set the hostname for this container.
  # This must match the node name in your flake.nix.
  networking.hostName = "changes";

}
