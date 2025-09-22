{ config, pkgs, ... }:

{
  # Open firewall for the analytics web interface
  networking.firewall = {
    allowedTCPPorts = [
      5000  # Analytics web interface
    ];
  };

  # Enable Docker for running the Twitch Channel Points Miner container
  virtualisation.docker.enable = true;

  # Define the Twitch Channel Points Miner container
  virtualisation.oci-containers.containers = {
    twitch-miner = {
      image = "rdavidoff/twitch-channel-points-miner-v2:latest";
      ports = [ "5000:5000" ];  # Analytics web interface
      volumes = [
        "/srv/twitch-miner/analytics:/usr/src/app/analytics"
        "/srv/twitch-miner/cookies:/usr/src/app/cookies"
        "/srv/twitch-miner/logs:/usr/src/app/logs"
        "/srv/twitch-miner/run.py:/usr/src/app/run.py:ro"
      ];
      environment = {
        TERM = "xterm-256color";
      };
      # Allow interactive mode for login if needed
      extraOptions = [
        "--tty"
        "--interactive"
      ];
    };
  };

  # Create necessary directories and set permissions
  systemd.tmpfiles.rules = [
    "d /srv/twitch-miner 0755 root root -"
    "d /srv/twitch-miner/analytics 0755 root root -"
    "d /srv/twitch-miner/cookies 0755 root root -"
    "d /srv/twitch-miner/logs 0755 root root -"
  ];

  # Create a basic run.py configuration file if it doesn't exist
  systemd.services.create-twitch-miner-config = {
    description = "Create Twitch Miner configuration if missing";
    wantedBy = [ "multi-user.target" ];
    before = [ "podman-twitch-miner.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      if [ ! -f /srv/twitch-miner/run.py ]; then
        cat > /srv/twitch-miner/run.py << 'EOF'
# -*- coding: utf-8 -*-

import logging
from TwitchChannelPointsMiner import TwitchChannelPointsMiner
from TwitchChannelPointsMiner.logger import LoggerSettings
from TwitchChannelPointsMiner.classes.Settings import Priority, FollowersOrder

# Initialize the miner
twitch_miner = TwitchChannelPointsMiner(
    username="your-twitch-username",  # Change this to your Twitch username
    claim_drops_startup=False,
    priority=[
        Priority.STREAK,
        Priority.DROPS,
        Priority.ORDER
    ],
    enable_analytics=True,  # Enable analytics for web interface
    logger_settings=LoggerSettings(
        save=True,
        console_level=logging.INFO,
        file_level=logging.DEBUG,
        emoji=True,
        less=False,
        colored=True
    )
)

# Start analytics web server
twitch_miner.analytics(host="0.0.0.0", port=5000, refresh=5, days_ago=7)

# Start mining - replace with your streamers or use followers
twitch_miner.mine(
    followers=True,
    followers_order=FollowersOrder.ASC
)
EOF
        chmod 644 /srv/twitch-miner/run.py
        echo "Created default run.py configuration. Please edit /srv/twitch-miner/run.py with your settings."
      fi
    '';
  };
}