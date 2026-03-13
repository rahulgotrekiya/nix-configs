{ config, pkgs, meta, ... }:

let
  user = meta.user;
  userHome = "/home/${user}";
in
{
  virtualisation.oci-containers.containers.filebrowser = {
    image = "filebrowser/filebrowser:latest";
    ports = [ "8092:80" ];
    volumes = [
      "/var/lib/filebrowser:/database"
      "${userHome}/sync/file-uploads:/srv"
    ];
    cmd = [
      "--address"
      "0.0.0.0"
      "--port"
      "80"
      "--database"
      "/database/filebrowser.db"
      "--root"
      "/srv"
    ];
  };

  # Create necessary directories with proper permissions
  systemd.tmpfiles.rules = [
    "d /var/lib/filebrowser 0777 root root -"
    "d ${userHome}/sync/file-uploads 0755 ${user} users -"
    "d ${userHome}/sync/file-uploads/shared 0755 ${user} users -"
  ];

  # Open firewall
  networking.firewall.allowedTCPPorts = [ 8092 ];
}