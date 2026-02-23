{ config, pkgs, ... }:

let
  localNet = "192.168.0.0/24";
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
    user = "neo";
    dataDir = "/home/neo/sync";
    configDir = "/home/neo/.config/syncthing";
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
          path = "/home/neo/sync/Documents";
          devices = [ "phone" ];
        };
        "Photos" = {
          path = "/home/neo/sync/Photos";
          devices = [ "phone" ];
        };
      };
    };
  };

  # Create necessary directories
  systemd.tmpfiles.rules = [
    "d /media/public 0777 nobody nogroup -"
    "d /home/neo/private 0700 neo neo -"
    "d /home/neo/sync 0755 neo neo -"
    "d /home/neo/sync/Documents 0755 neo neo -"
    "d /home/neo/sync/Photos 0755 neo neo -"
  ];
}
