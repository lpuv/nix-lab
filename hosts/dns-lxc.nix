{ config, pkgs, inputs, ... }:

{
  imports = [
    ../modules/common.nix
    ../modules/services/dns.nix
    ../modules/services/dns-over-tls-forwarder.nix
  ];

  services.resolved.enable = false;

  # Enable Docker for running OCI containers (DNS over TLS forwarder)
  virtualisation.docker.enable = true;
  systemd.timers.podman-auto-update.wantedBy = [ "multi-user.target" ];

  age.secrets."cloudflare" = {
    file = ../secrets/cloudflare.age;
    owner = "root";
    group = "root";
  };

  # Set the hostname for this container.
  networking = {
    hostName = "dns.internal.craftcat.dev";
    firewall.allowedTCPPorts = [
      80
      443
      53
      5353  # DNS over TLS forwarder
    ];
    firewall.allowedUDPPorts = [
      53
      5353  # DNS over TLS forwarder
    ];
  };

  # --- Local Recursive DNS (Unbound) ---
  # Enable the Unbound service. AdGuard Home will use this as its upstream.
  # Port 5335: Unbound (recursive DNS)
  # Port 5353: DNS over TLS forwarder (proxies to Cloudflare via HTTPS/TLS)
  services.unbound = {
    enable = true;
    settings = {
      server = {
        interface = [ "127.0.0.1" ];
        port = 5335;
        access-control = [ "127.0.0.1 allow" ];
        # Based on recommended settings in https://docs.pi-hole.net/guides/dns/unbound/#configure-unbound
        harden-glue = true;
        harden-dnssec-stripped = true;
        use-caps-for-id = false;
        prefetch = true;
        edns-buffer-size = 1232;

        # Custom settings
        hide-identity = true;
        hide-version = true;
      };
      forward-zone = [
        {
          name = ".";
          forward-addr = [
            "1.1.1.1@853#cloudflare-dns.com"
            "1.0.0.1@853#cloudflare-dns.com"
          ];
          forward-tls-upstream = true;  # Protected DNS
        }
      ];
    };
  };


  # --- ACME SSL Certificate Configuration ---
  security.acme = {
    acceptTerms = true;
    defaults.email = "luna@craftcat.dev"; # For certificate renewal notices

    certs."dns.internal.craftcat.dev" = {
      dnsProvider = "cloudflare";
      # Use the agenix secret for the Cloudflare API token.
      environmentFile = config.age.secrets."cloudflare".path;
      # The AdGuard Home service runs as the 'adguardhome' user.
      # This group permission ensures it can read the generated certificate.
      group = "adguardhome";
      extraLegoFlags = ["--dns.propagation-wait=100s"];
      dnsResolver = "192.168.2.5:5353"; # outside network blocks UDP and we need to bypass unbound
    };
  };

  # Configure the AdGuard Home service using the settings from the wiki.
  services.adguardhome.settings = {
    http = {
      # Listen on port 80 for initial setup and HTTP redirects.
      address = "0.0.0.0:80";
    };
    tls = {
      enabled = true;
      server_name = "dns.internal.craftcat.dev";
      port_https = 443;
      certificate_path = "${config.security.acme.certs."dns.internal.craftcat.dev".directory}/full.pem";
      private_key_path = "${config.security.acme.certs."dns.internal.craftcat.dev".directory}/key.pem";
    };
    dns = {
      # Use the local Unbound instance as the upstream DNS provider.
      # Unbound listens on 127.0.0.1 port 53 by default.
      upstream_dns = [
        "127.0.0.1:5335"
      ];
    };
    filtering = {
      protection_enabled = true;
      filtering_enabled = true;
      parental_enabled = false;
      safe_search.enabled = false;
    };
    # Add some default filter lists.
    filters = map (url: { enabled = true; url = url; }) [
      "https://adguardteam.github.io/HostlistsRegistry/assets/filter_9.txt"
      "https://adguardteam.github.io/HostlistsRegistry/assets/filter_11.txt"
      "https://adguardteam.github.io/HostlistsRegistry/assets/filter_45.txt"
      "https://adguardteam.github.io/HostlistsRegistry/assets/filter_51.txt"
      "https://adguardteam.github.io/HostlistsRegistry/assets/filter_44.txt"
    ];
  };
}

