{ config, pkgs, modulesPath, ... }:

{

  imports = [
    (modulesPath + "/virtualisation/proxmox-lxc.nix")
  ];
  boot.isContainer = true;
  # Supress systemd units that don't work because of LXC
  systemd.suppressedSystemUnits = [
    "dev-mqueue.mount"
    "sys-kernel-debug.mount"
    "sys-fs-fuse-connections.mount"
  ];
  # ============================================================================
  # Secret Management (agenix)
  # ============================================================================

  
  # Tell agenix to use the host's SSH key for decryption.
  # This is the standard and most secure way to identify a machine.
  age.identityPaths = [
    "/etc/ssh/ssh_host_ed25519_key"
  ];

  # ============================================================================
  # Users and SSH
  # ============================================================================
  nix.settings.trusted-users = [ "luna" ];
  users.users.luna =
    {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK/5d3jAjWq1fOIyPk3jHMafTLJH6xqHv2bAZalQ/GaL luna@craftcat.dev"
      ];
    };
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
    settings.PermitRootLogin = "no";
  };
  security.sudo.wheelNeedsPassword = false;
  

  # ============================================================================
  # Common Packages
  # ============================================================================
  # Install a set of useful command-line tools on every container.
  environment.systemPackages = with pkgs; [
    helix     # A powerful text editor
    git       # Version control system
    btop      # An interactive process viewer
    wget      # A tool for downloading files from the web
    curl      # A tool for transferring data with URLs
    unzip     # A tool for extracting archives
    dig       # A tool for testing DNS
    unrar     # A tool for extracting rar files
  ];

  # ============================================================================
  # System Settings
  # ============================================================================
  # Set the timezone for all containers.
  time.timeZone = "America/Toronto";

  # This is required for NixOS to manage the system.
  system.stateVersion = "25.11"; # Set this to the version you are using.
}
