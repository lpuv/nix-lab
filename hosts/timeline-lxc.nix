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
    ../modules/services/dawarich.nix
  ];

  # Set the hostname for this container.
  # This must match the node name in your flake.nix.
  networking.hostName = "timeline";

  users.groups.dawarich = {};
  users.users.dawarich = {
    isSystemUser = true; # It's a service user, not a person.
    group = "dawarich";
    # The user needs a home directory to write data to.
  };
  users.users.nginx.extraGroups = [ "dawarich" ];

}
