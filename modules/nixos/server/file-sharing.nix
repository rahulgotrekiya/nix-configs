{ config, pkgs, meta, ... }:

let
  localNet = "192.168.1.0/24";
  user = meta.user;
  userHome = "/home/${user}";
in
{
 # NFS file sharing (Linux/Unix)
  services.nfs.server = {
    enable = true;
    exports = ''
      /media    ${localNet}(ro,sync,no_subtree_check)
    '';
  };

  # Syncthing - Sync files between devices
  services.syncthing = {
    enable = true;
    user = user;
    dataDir = "${userHome}/sync";
    configDir = "${userHome}/.config/syncthing";
    openDefaultPorts = true;
    overrideDevices = true;
    overrideFolders = true;
    guiAddress = "0.0.0.0:8384";
    settings = {
      devices = {
        # devices
        "phone" = { id = "JRV7NGD-JCPOAEA-4C6J6D3-BFMKFC4-AOCIMHT-27XX6HH-J2MIRGR-FTTUOQU"; };
        # "laptop" = { id = "DEVICE-ID-HERE"; };
      };
      folders = {
        "Documents" = {
          path = "${userHome}/sync/Documents";
          devices = [ "phone" ];
        };
        "Photos" = {
          path = "${userHome}/sync/Photos";
          devices = [ "phone" ];
        };
      };
    };
  };

  # Create necessary directories
  systemd.tmpfiles.rules = [
    "d /media/public 0777 nobody nogroup -"
    "d ${userHome}/private 0700 ${user} ${user} -"
    "d ${userHome}/sync 0755 ${user} ${user} -"
    "d ${userHome}/sync/Documents 0755 ${user} ${user} -"
    "d ${userHome}/sync/Photos 0755 ${user} ${user} -"
  ];
}
