{
  pkgs,
  config,
  lib,
  ...
}:
{
  imports = [
    ./nix.nix
    ./trusted-nix-caches.nix
    ./well-known-hosts.nix
  ];

  i18n.defaultLocale = "en_US.UTF-8";

  time.timeZone = "America/Los_Angeles";

  nix = {
    package = pkgs.nixUnstable;
    settings = {
      auto-optimise-store = true;
      cores = lib.mkDefault 0;
      max-jobs = lib.mkDefault "auto";
      trusted-users = [
        "root"
        "leo"
        "@wheel"
      ];
      allowed-users = [ "*" ];
    };
  };

  users = {
    mutableUsers = false;
    users.root.openssh.authorizedKeys.keys = (import ./keys.nix).leo;
  };

}