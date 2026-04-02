{ config, pkgs, inputs, ... }:

{
  # Import shared configurations and the specific service module.
  imports = [
    ../modules/common.nix  
    ../modules/services/checkmk-agent.nix
    ../modules/services/panel.nix
  ];

  # Set the hostname for this container.
  # This must match the node name in your flake.nix.
  networking.hostName = "panel";

  systemd.timers.podman-auto-update.wantedBy = [ "multi-user.target" ];


  environment.systemPackages = with pkgs; [
    tcpdump
  ];
  
  boot.kernel.sysctl = {
    # Disable strict reverse path filtering
    "net.ipv4.conf.all.rp_filter" = 0;
    "net.ipv4.conf.default.rp_filter" = 0;
    "net.ipv4.conf.eth0.rp_filter" = 0;

    # Allow the kernel to handle the local routing of these packets
    "net.ipv4.ip_forward" = 1;
  };

  systemd.tmpfiles.rules = [
    "d /srv/pyrodactyl 0770 root 82 -"
    "d /srv/pyrodactyl/database 0770 nscd nscd -"
    "d /srv/pyrodactyl/var 0770 root 82 -"
    "d /srv/pyrodactyl/nginx 0770 root 82 -"
    "d /srv/pyrodactyl/certs 0770 root 82 -"
    "d /srv/pyrodactyl/logs 0770 root 82 -"
    "d /var/lib/pterodactyl 0770 988 988 -"
    "d /var/log/pterodactyl 0770 988 988 -"
    "d /tmp/pterodactyl 0770 988 988 -"
  ];
  
  # This secret will be decrypted on this host and placed in the specified file.
  age.secrets = {
    "pyrodactyl-db" = {
      file = ../secrets/pyrodactyl-db.env.age;
      owner = "root"; # The user defined in the service module
      group = "root"; # The group defined in the service module
    };
    "pyrodactyl-panel" = {
      file = ../secrets/pyrodactyl-panel.env.age;
      owner = "root";
      group = "root";
    };
    "wings-config" = {
      file = ../secrets/wings-config.yml.age;
      owner = "root";
      group = "root";
    };
    "cloudflare" = {
      file = ../secrets/cloudflare.age;
      owner = "root";
      group = "root";
    };
    "playit-tunnel" = {
      file = ../secrets/playit-tunnel.env.age;
      owner = "root";
      group = "root";
    };
  };
}

