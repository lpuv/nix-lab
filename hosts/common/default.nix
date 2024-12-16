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
    ./certs.nix
  ];

  i18n.defaultLocale = "en_US.UTF-8";

  time.timeZone = "America/Los_Angeles";

  nix = {
    package = pkgs.nixVersions.latest;
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

  environment = {
    variables = {
      LANG = "en_US.UTF-8";
      EDITOR = "nano";
      VISUAL = "nano";
    };
    systemPackages = with pkgs; [
      cloudflared
      bashInteractive
      binutils
      coreutils
      curl
      file
      git
      gptfdisk
      mkpasswd
      nano
      openssh
      rclone
      vim
      wget
      zsh
    ];
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

  nixpkgs.config.permittedInsecurePackages = [
    "aspnetcore-runtime-6.0.36"
    "aspnetcore-runtime-wrapped-6.0.36"
    "dotnet-sdk-6.0.428"
    "dotnet-sdk-wrapped-6.0.428"
  ];

}
