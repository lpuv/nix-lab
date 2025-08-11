{ config, pkgs, inputs, ... }:

{
  imports = [
    # Import the common configuration for all hosts.
    ../modules/common.nix
    ../modules/services/cloudflared.nix
  ];

  # Set the hostname for this container.
  networking.hostName = "cfproxy.internal.craftcat.dev";

  # Define the agenix secrets for Cloudflared.
  age.secrets = {
    # This secret contains the Cloudflare Tunnel token.
    "cloudflared-token" = {
      file = ../secrets/cloudflared.age;
      owner = "cloudflared";
      mode = "600";
    };
  };
}

