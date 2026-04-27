{ config, pkgs, meta, ... }:

{
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  users.users.${meta.user} = {
    extraGroups = [ "libvirtd" "kvm" ];
  };

  environment.systemPackages = with pkgs; [
    vagrant
  ];
}
