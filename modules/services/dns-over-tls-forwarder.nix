{ lib, config, pkgs, ... }:

let
  dnscryptConfig = ''
    listen_addresses = ['0.0.0.0:5053']

    dnscrypt_servers = false
    doh_servers = true

    require_dnssec = false
    require_nolog = true
    require_nofilter = true

    ignore_system_dns = false
    bootstrap_resolvers = []
  '';
in
{
  environment.etc."dnscrypt-proxy/dnscrypt-proxy.toml".text = dnscryptConfig;
  # Create a DNS over TLS forwarder service using cloudflared in DNS proxy mode
  # This will listen on a dedicated port and forward DNS queries to Cloudflare over TLS
  
  virtualisation.oci-containers.containers = {
    dns-doh-forwarder = {
      image = "docker.io/klutchell/dnscrypt-proxy:latest";
      autoStart = true;
      ports = [
        "5353:5053/udp"
        "5353:5053/tcp"
      ];
      volumes = [
        "/etc/dnscrypt-proxy:/config"
      ];
      environment = {
        TZ = "America/Toronto";
      };
      labels = { "io.containers.autoupdate" = "registry"; };
    };
  };

  # Configure service restart behavior for reliability
  systemd.services."podman-dns-over-tls-forwarder".serviceConfig = {
    # Wait 30 seconds before trying to restart the service after a failure
    RestartSec = "30s";
  };
}
