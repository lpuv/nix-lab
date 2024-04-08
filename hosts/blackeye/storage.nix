{ config, ... }:
{
  # fileSystems."/mnt/media" = {
  #   device = "//192.168.1.5/media";
  #   fsType = "cifs";
  #   options = [
  #     "x-systemd.automount"
  #     "noauto"
  #     "x-systemd.idle-timeout=600"
  #     "x-systemd.device-timeout=5s"
  #     "x-systemd.mount-timeout=5s"
  #     "file_mode=0775"
  #     "dir_mode=0775"
  #     "uid=240"
  #     "credentials=${config.age.secrets.smb.path}"
  #   ];
  # };
  services.rpcbind.enable = true; # needed for NFS
  fileSystems."/mnt/media" = {
    fsType = "nfs";
    device = "192.168.1.5:/local-zfs/media";
    options = [ "nfsvers=4.2" ];
  };
}