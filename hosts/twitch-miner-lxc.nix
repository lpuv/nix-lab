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
    ../modules/services/twitch-miner.nix
    ../modules/services/media/caddy.nix
  ];

  # Set the hostname for this container.
  # This must match the node name in your flake.nix.
  networking.hostName = "twitch-miner";

  # Allow HTTP and HTTPS traffic for Caddy
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  # Configure age secret for Caddy
  age.secrets."caddy" = {
    file = ../secrets/caddy.age;
    owner = "caddy";
    mode = "600";
  };
}