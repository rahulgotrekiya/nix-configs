{ config, pkgs, ... }:

{
  virtualisation.oci-containers.containers.filebrowser = {
    image = "filebrowser/filebrowser:latest";
    ports = [ "8092:80" ];
    volumes = [
      "/var/lib/filebrowser:/database"
      "/home/neo/sync/file-uploads:/srv"
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
    "d /home/neo/sync/file-uploads 0755 neo users -"
    "d /home/neo/sync/file-uploads/shared 0755 neo users -"
  ];

  # Open firewall
  networking.firewall.allowedTCPPorts = [ 8092 ];
}