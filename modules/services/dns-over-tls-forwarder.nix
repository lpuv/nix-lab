{ lib, config, pkgs, ... }:

{
  # Create a DNS over TLS forwarder service using cloudflared in DNS proxy mode
  # This will listen on a dedicated port and forward DNS queries to Cloudflare over TLS
  
  virtualisation.oci-containers.containers = {
    dns-over-tls-forwarder = {
      image = "cloudflare/cloudflared:latest";
      autoStart = true;
      ports = [
        "127.0.0.1:5353:5353/udp"
        "127.0.0.1:5353:5353/tcp"
      ];
      cmd = [
        "proxy-dns"
        "--address"
        "0.0.0.0"
        "--port"
        "5353"
        "--upstream"
        "https://1.1.1.1/dns-query"
        "--upstream"
        "https://1.0.0.1/dns-query"
      ];
      environment = {
        TZ = "America/Toronto";
      };
    };
  };
}