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
        "/srv/twitch-miner/blacklist.txt:/srv/twitch-miner/blacklist.txt:ro"
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
      # Create blacklist file if it doesn't exist
      if [ ! -f /srv/twitch-miner/blacklist.txt ]; then
        cat > /srv/twitch-miner/blacklist.txt << 'EOF'
# Twitch Channel Points Miner - Blacklist Configuration
# 
# Add usernames (one per line) that you want to exclude from point farming.
# Lines starting with # are comments and will be ignored.
#
# Example:
# annoying_streamer
# another_username
# 
# This file is automatically read by the miner on startup.

EOF
        chmod 644 /srv/twitch-miner/blacklist.txt
        echo "Created blacklist.txt file at /srv/twitch-miner/blacklist.txt"
      fi

      if [ ! -f /srv/twitch-miner/run.py ]; then
        cat > /srv/twitch-miner/run.py << 'EOF'
# -*- coding: utf-8 -*-
# Twitch Channel Points Miner v2 Configuration
# 
# This is a basic configuration file for the Twitch Channel Points Miner.
# Edit this file to customize your settings.
#
# For full documentation, see:
# https://github.com/rdavydov/Twitch-Channel-Points-Miner-v2

import logging
from TwitchChannelPointsMiner import TwitchChannelPointsMiner
from TwitchChannelPointsMiner.logger import LoggerSettings
from TwitchChannelPointsMiner.classes.Settings import Priority, FollowersOrder
from TwitchChannelPointsMiner.classes.entities.Bet import Strategy, BetSettings, Condition, OutcomeKeys, FilterCondition
from TwitchChannelPointsMiner.classes.entities.Streamer import Streamer, StreamerSettings

# Initialize the miner
twitch_miner = TwitchChannelPointsMiner(
    username="lunapuv",  # Twitch username
    # password="your-password",  # Optional: If not provided, you'll be prompted for login
    claim_drops_startup=False,
    priority=[
        Priority.STREAK,    # Prioritize watch streaks
        Priority.DROPS,     # Claim drops when available  
        Priority.ORDER      # Follow the order of streamers in the list
    ],
    enable_analytics=True,  # Enable analytics for web interface on port 5000
    logger_settings=LoggerSettings(
        save=True,
        console_level=logging.INFO,
        file_level=logging.DEBUG,
        emoji=True,
        less=False,
        colored=True
    )
)

# Start analytics web server (accessible on port 5000)
twitch_miner.analytics(host="0.0.0.0", port=5000, refresh=5, days_ago=7)

# Start mining points
# Option 1: Use your followers list automatically with blacklist support
try:
    # Try to read blacklist from file
    with open('/srv/twitch-miner/blacklist.txt', 'r') as f:
        blacklist = [line.strip() for line in f.readlines() if line.strip() and not line.startswith('#')]
except FileNotFoundError:
    blacklist = []

twitch_miner.mine(
    followers=True,
    followers_order=FollowersOrder.ASC,
    blacklist=blacklist
)

# Option 2: Specify streamers manually (uncomment and modify)
# twitch_miner.mine([
#     "streamer1",
#     "streamer2", 
#     "streamer3",
#     Streamer("streamer4", settings=StreamerSettings(
#         make_predictions=True,
#         follow_raid=True,
#         bet=BetSettings(
#             strategy=Strategy.SMART,
#             percentage=5,
#             max_points=50000
#         )
#     ))
# ], blacklist=blacklist)  # Can also use blacklist with manual streamer lists

# To exclude streamers from farming, edit /srv/twitch-miner/blacklist.txt
# Add one username per line to prevent farming from those streamers
EOF
        chmod 644 /srv/twitch-miner/run.py
        echo "Created default run.py configuration. Please edit /srv/twitch-miner/run.py with your settings."
      fi
    '';
  };

  # Configure service restart behavior
  systemd.services."podman-twitch-miner".serviceConfig = {
    # Wait 2 minutes before trying to restart the service after a failure.
    RestartSec = "2min";
  };

  # Configure Caddy reverse proxy for the analytics web interface
  services.caddy.virtualHosts."twitch-miner.internal.craftcat.dev" = {
    extraConfig = ''
      import ${config.age.secrets.caddy.path}
      reverse_proxy http://localhost:5000
    '';
  };
}
