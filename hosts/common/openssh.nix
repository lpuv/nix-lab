# Better defaults for OpenSSH
{ config, lib, ... }:
{
  services.openssh = {
    settings.X11Forwarding = false;
    settings.KbdInteractiveAuthentication = false;
    settings.PasswordAuthentication = false;
    settings.UseDns = false;
    # unbind gnupg sockets if they exists
    settings.StreamLocalBindUnlink = true;

    # Use key exchange algorithms recommended by `nixpkgs#ssh-audit`
    settings.KexAlgorithms = [
      "curve25519-sha256"
      "curve25519-sha256@libssh.org"
      "diffie-hellman-group16-sha512"
      "diffie-hellman-group18-sha512"
      "sntrup761x25519-sha512@openssh.com"
    ];
    # NOT NEEDED, WE USE FORGEJO
    # Only allow system-level authorized_keys to avoid injections.
    # We currently don't enable this when git-based software that relies on this
 is enabled.
    # It would be nicer to make it more granular using `Match`.
    # However those match blocks cannot be put after other `extraConfig` lines
    # with the current sshd config module, which is however something the sshd
    # config parser mandates.
    authorizedKeysFiles =
      let
        # Default value for authorizedKeysFiles
        defaultAuthorizedKeys = [ "/etc/ssh/authorized_keys.d/%u" ];
      in
      lib.mkIf (config.services.forgejo.enable) (defaultAuthorizedKeys ++ [ "${config.services.forgejo.stateDir}/.ssh/authorized_keys" ])
      else defaultAuthorizedKeys;
  };
}