{ config, pkgs, ... }:

{

  networking.firewall = {
    allowedTCPPorts = [
      80
      443
    ];
  };

  virtualisation.docker.enable = true;

  # Declaratively define all containers needed for the Receipt Wrangler stack.
  virtualisation.oci-containers.containers = {

    # -- Database Container --
    database = {
      image = "mariadb:10";
      ports = [ "3306:3306" ];
      volumes = [ "/srv/receipts/database:/var/lib/mysql" ];
      # Load database credentials securely from the agenix-decrypted file.
      environmentFiles = [ config.age.secrets."receipt-wrangler-db".path ];
    };

    # -- Cache Container --
    cache = {
      ports = [ "6379:6379" ];
      image = "redis:alpine";
      environmentFiles = [ config.age.secrets."receipt-wrangler-redis".path ];
    };

    # -- Receipt Wrangler Container --
    pyro-panel = {
      image = "noah231515/receipt-wrangler:latest";
      entrypoint = "./entrypoint.sh";
      dependsOn = [
        "database"
        "cache"
      ];
      volumes = [
        "/srv/receipts/data:/app/receipt-wrangler-api/data"
        "/srv/receipts/sqlite:/app/receipt-wrangler-api/sqlite"
      ];
      # Expose the panel's port 80 only to the host on port 8081 for Nginx.
      ports = [ "80:80" ];
      # Load panel configuration from the agenix-decrypted file.
      environmentFiles = [ config.age.secrets."receipt-wrangler".path ];
    };

  };

}
