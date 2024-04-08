let
  leo = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK/5d3jAjWq1fOIyPk3jHMafTLJH6xqHv2bAZalQ/GaL";
  users = [ leo ];

  blackeye = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA5hZ7aKNTfQHgbs1zesY+Xl9sWNKxHcxtYmt43KXofs leo@blackeye";
  systems = [ blackeye ];
in
{
  "cachix.age".publicKeys = users ++ systems;
  "cloudflared.age".publicKeys = users ++ systems;
  "smb.age".publicKeys = users ++ systems;
  "caddy.age".publicKeys = users ++ systems;
}