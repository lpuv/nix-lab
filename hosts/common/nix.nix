{
  lib,
  pkgs,
  ...
}:
{
  # Fallback quickly if substituters are not available.
  nix.settings.connect-timeout = 5;

  # Enable flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
    "repl-flake"
  ];

  # The default at 10 is rarely enough.
  nix.settings.log-lines = lib.mkDefault 25;

  # Avoid disk full issues
  nix.settings.max-free = lib.mkDefault (3000 * 1000 * 1000);
  nix.settings.min-free = lib.mkDefault (128 * 1000 * 1000);

  # Avoid copying unnecessary stuff over SSH
  nix.settings.builders-use-substitutes = true;

  # garbage collection
  nix.gc.automatic = true;
  nix.gc.options = "--delete-older-than 7d";

  # Needed to compile caddy, but should not have much effect as flake is built in Github Actions
  nix.settings.sandbox = false;
}