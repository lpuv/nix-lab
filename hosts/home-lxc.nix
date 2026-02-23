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
    ../modules/services/homeassistant.nix
  ];

  # Set the hostname for this container.
  # This must match the node name in your flake.nix.
  networking.hostName = "home";

  systemd.tmpfiles.rules = [
    "d /var/lib/homeassistant 0770 root 82 -"
  ];

}
