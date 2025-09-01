{ config, pkgs, ... }:

{

  services.postgresql = {
    enable = true;
    # enable trust-based authentication for the firefly III user
    authentication = ''
      local all all trust
    '';
    initialDatabases = [
      {
        owner = "firefly";
        name = "firefly";
      }
    ];
  };

  networking.firewall = {
    allowedTCPPorts = [
      80
      8081
    ];
  };

  services.firefly-iii = {
    enable = true;
    user = "firefly";
    group = "firefly";
    dataDir = "/var/lib/firefly-iii";

    # Configure the connection to the local PostgreSQL database.
    settings = {
      APP_KEY_FILE = config.age.secrets."firefly-app-key".path;
      SITE_OWNER = "luna@craftcat.dev";

      DB_CONNECTION = "pgsql";
      DB_HOST = "/run/postgresql"; # Use the local socket for performance and security
      DB_PORT = 5432;
      DB_DATABASE = "firefly";
      DB_USERNAME = "firefly";
      # Firefly III doesn't need a password when connecting via a local socket
      # with trust authentication, but the setting is still required.
      # We can point it to an empty file or a dummy secret.
      DB_PASSWORD = "";
    };

  };
  services.firefly-iii-data-importer = {
    enable = true;
  };
}
