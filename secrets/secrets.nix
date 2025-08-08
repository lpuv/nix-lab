let
  luna = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK/5d3jAjWq1fOIyPk3jHMafTLJH6xqHv2bAZalQ/GaL luna@craftcat.dev";
  panel = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA55f+d/8U6RmUkyAFFTFJCFJZNc3wzFbt372AQvRhTW root@panel.internal.craftcat.dev";
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
    luna
  ];
}
