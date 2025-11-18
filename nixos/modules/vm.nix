{ config, pkgs, ... }:

{
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  users.users.rahul = {
    isNormalUser = true;
    extraGroups = [ "libvirtd" "kvm" ];
  };
}
