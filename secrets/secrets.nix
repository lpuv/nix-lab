let
  luna = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK/5d3jAjWq1fOIyPk3jHMafTLJH6xqHv2bAZalQ/GaL luna@craftcat.dev";
  panel = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA55f+d/8U6RmUkyAFFTFJCFJZNc3wzFbt372AQvRhTW root@panel.internal.craftcat.dev";
  dns = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILSsbpk5MPFi/r1J9bL6wusL+MgCMjmM5GMel5zmlfwm root@dns.internal.craftcat.dev";
  media = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII/uOFftIZeJwH8Uzdhp8/dNuB99LgLbkCBUTrvgr1zk root@media.internal.craftcat.dev";
  cfproxy = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB4yG5KMgJEoQIEvmjO/mPRbdEa3XgqXVPmo4XbyyQhs root@cfproxy.internal.craftcat.dev";
in
{
  "pyrodactyl-db.env.age".publicKeys = [
    panel
    luna
  ];
  "pyrodactyl-panel.env.age".publicKeys = [
    panel
    luna
  ];
  "wings-config.yml.age".publicKeys = [
    panel
    luna
  ];
  "cloudflare.age".publicKeys = [
    panel
    dns
    luna
  ];
  "playit-tunnel.env.age".publicKeys = [
    panel
    luna
  ];
  "caddy.age".publicKeys = [
    media
    luna
  ];
  "transmission.env.age".publicKeys = [
    media
    luna
  ];
  "cloudflared.age".publicKeys = [
    cfproxy
    luna
  ];
}
