{ config, pkgs, ... }:

{


  networking.firewall = {
    allowedTCPPorts = [
      5000
    ];
  };

  # services.changedetection-io = {
  #   enable = true;
  #   webDriverSupport = true;
  #   behindProxy = true;
  #   listenAddress = "0.0.0.0";
  #   baseURL = "https://changes.craftcat.dev";
  # };
  virtualisation.oci-containers.containers = {
    changedetection-io = {
      image = "docker.io/dgtlmoon/changedetection.io";
      ports = [
        "5000:5000"
      ];
      environment = {
        PLAYWRIGHT_DRIVER_URL = "ws://host.containers.internal:3000/?stealth=1&--disable-web-security=true";
      };
      volumes = [ "/srv/changedetection:/datastore" ];
      labels = { "io.containers.autoupdate" = "registry"; };
    };
    playwright-chrome = {
      #image = "docker.io/browserless/chrome:latest";
      image = "docker.io/dgtlmoon/sockpuppetbrowser:latest";
      ports = [
        "3000:3000"
      ];
      environment = {
        SCREEN_WIDTH = "1920";
        SCREEN_HEIGHT = "1080";
        SCREEN_DEPTH = "16";
        ENABLE_DEBUGGER = "true";
        PREBOOT_CHROME = "true";
        CONNECTION_TIMEOUT = "300000";
        MAX_CONCURRENT_SESSIONS = "10";
        CHROME_REFRESH_TIME = "600000";
        DEFAULT_BLOCK_ADS = "true";
        DEFAULT_STEALTH = "true";
        DEFAULT_IGNORE_HTTPS_ERRORS = "true";
      };
      extraOptions = ["--shm-size=2g"];
      labels = { "io.containers.autoupdate" = "registry"; };
    };
  };
}
