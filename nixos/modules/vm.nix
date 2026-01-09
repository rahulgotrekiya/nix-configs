{ config, pkgs, ... }:

{
  virtualisation.virtualbox.host = {
    enable = true;
    enableExtensionPack = true;
  };

  users.extraGroups.vboxusers.members = [ "rahul" ];

  environment.systemPackages = with pkgs; [
    vagrant
  ];
}
