{ config, lib, ... }:
{
  age.identityPaths =
    [
      # make sure this key is copied from 1password prior to running agenix
      "/home/leo/.ssh/id_ed25519"
      # key to use for new installs, prior to generation of hostKeys
      "/etc/agenixKey"
    ]
    ++ map (e: e.path) (
      lib.filter (e: e.type == "rsa" || e.type == "ed25519") config.services.openssh.hostKeys
    );

  age.secrets = {
    cachix-token.file = ../../secrets/cachix.age;
    cloudflared-token = {
      file = ../../secrets/cloudflared.age;
      owner = "cloudflared";
      mode = "600";
    };
    smb.file = ../../secrets/smb.age;
  };
}