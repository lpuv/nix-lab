{ lib, config, pkgs, ... }:

let
  # The configuration for the dnscrypt-proxy binary inside the container
  dnscryptConfig = ''
    listen_addresses = ['0.0.0.0:5053']
    
    # Use the static server defined below
    server_names = ['cloudflare']

    # Security and Privacy settings
    dnscrypt_servers = false
    doh_servers = true
    require_dnssec = false
    require_nolog = true
    require_nofilter = true
    ignore_system_dns = false

    [static]
      [static.'cloudflare']
      stamp = 'sdns://AgcAAAAAAAAABzEuMS4xLjEAEmRucy5jbG91ZGZsYXJlLmNvbQovZG5zLXF1ZXJ5'
  '';
in
{
  # 1. Create the config file
  environment.etc."dnscrypt-proxy/dnscrypt-proxy.toml".text = dnscryptConfig;

  virtualisation.oci-containers.containers = {
    "dns-doh-forwarder" = {
      image = "docker.io/klutchell/dnscrypt-proxy:latest";
      autoStart = true;
      ports = [
        "5353:5053/udp"
        "5353:5053/tcp"
      ];
      volumes = [
        # Mount the file directly from the resolved etc path
        "/etc/dnscrypt-proxy/dnscrypt-proxy.toml:/config/dnscrypt-proxy.toml:ro"
      ];
      environment = {
        TZ = "America/Toronto";
      };
      # Ensure the path in 'cmd' matches the mount point exactly
      cmd = [ "-config" "/config/dnscrypt-proxy.toml" ];
      labels = { "io.containers.autoupdate" = "registry"; };
    };
  };

  # 2. Corrected service name for the override
  systemd.services."podman-dns-doh-forwarder" = {
    serviceConfig = {
      RestartSec = "30s";
    };
    # Ensure the config file exists before the container starts
    after = [ "etc-dnscrypt-proxy-dnscrypt-proxy.toml.mount" ];
  };
}
