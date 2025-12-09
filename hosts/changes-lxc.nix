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
    ../modules/services/changedetection.nix
  ];

  virtualisation.docker.enable = true;

  # Set the hostname for this container.
  # This must match the node name in your flake.nix.
  networking.hostName = "changes";

}
