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
    ../modules/services/trilium.nix
  ];

  # Set the hostname for this container.
  # This must match the node name in your flake.nix.
  networking.hostName = "trilium";

}
