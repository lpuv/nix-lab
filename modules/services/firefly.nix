{ config, pkgs, ... }:

{

  services.postgresql = {
    enable = true;
    # enable trust-based authentication for the firefly III user
    authentication = ''
      local all all trust
    '';
    ensureDatabases = [ "firefly" ];
    ensureUsers = [
      {
        name = "firefly";
        ensureDBOwnership = true;
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
    enableNginx = true;
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

      TRUSTED_PROXIES = "*";
    };

    virtualHost = "finance.craftcat.dev";

  };
  services.firefly-iii-data-importer = {
    enable = true;
  };

  # Firefly III cron jobs using systemd timers
  # These correspond to the official cron documentation at:
  # https://docs.firefly-iii.org/how-to/firefly-iii/advanced/cron/

  systemd.services.firefly-cron-recurring = {
    description = "Firefly III recurring transactions";
    serviceConfig = {
      Type = "oneshot";
      User = "firefly";
      Group = "firefly";
      ExecStart = "${pkgs.php}/bin/php ${config.services.firefly-iii.dataDir}/artisan firefly:cron-recurring";
      WorkingDirectory = config.services.firefly-iii.dataDir;
    };
  };

  systemd.timers.firefly-cron-recurring = {
    description = "Run Firefly III recurring transactions daily";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
      RandomizedDelaySec = "15m";
    };
  };

  systemd.services.firefly-cron-auto-budget = {
    description = "Firefly III auto-budget";
    serviceConfig = {
      Type = "oneshot";
      User = "firefly";
      Group = "firefly";
      ExecStart = "${pkgs.php}/bin/php ${config.services.firefly-iii.dataDir}/artisan firefly:cron-auto-budget";
      WorkingDirectory = config.services.firefly-iii.dataDir;
    };
  };

  systemd.timers.firefly-cron-auto-budget = {
    description = "Run Firefly III auto-budget daily";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
      RandomizedDelaySec = "15m";
    };
  };

  systemd.services.firefly-cron-exchange-rates = {
    description = "Firefly III exchange rates update";
    serviceConfig = {
      Type = "oneshot";
      User = "firefly";
      Group = "firefly";
      ExecStart = "${pkgs.php}/bin/php ${config.services.firefly-iii.dataDir}/artisan firefly:cron-exchange-rates";
      WorkingDirectory = config.services.firefly-iii.dataDir;
    };
  };

  systemd.timers.firefly-cron-exchange-rates = {
    description = "Run Firefly III exchange rates update daily";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
      RandomizedDelaySec = "15m";
    };
  };

  systemd.services.firefly-cron-cleanup = {
    description = "Firefly III cleanup old entries";
    serviceConfig = {
      Type = "oneshot";
      User = "firefly";
      Group = "firefly";
      ExecStart = "${pkgs.php}/bin/php ${config.services.firefly-iii.dataDir}/artisan firefly:cron-cleanup";
      WorkingDirectory = config.services.firefly-iii.dataDir;
    };
  };

  systemd.timers.firefly-cron-cleanup = {
    description = "Run Firefly III cleanup weekly";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "weekly";
      Persistent = true;
      RandomizedDelaySec = "30m";
    };
  };
}
