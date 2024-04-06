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
    ./openssh.nix
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

  security.sudo.enable = true;

  services = {
    resolved.enable = lib.mkDefault true; # mkDefault lets it be overridden
    openssh.enable = true;
    qemuGuest.enable = true;
  };

  security.pam.sshAgentAuth.enable = true; # enable password-less sudo (using SSH keys)
  security.pam.services.sudo.sshAgentAuth = true;

  users = {
    mutableUsers = false;
    users.root.openssh.authorizedKeys.keys = (import ./keys.nix).leo;
  };

}