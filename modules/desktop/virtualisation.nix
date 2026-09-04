{ pkgs, username, ... }:

{
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        package      = pkgs.qemu_kvm;
        runAsRoot    = true;
        swtpm.enable = true;
      };
    };

    spiceUSBRedirection.enable = true;
  };

  users.users.${username}.extraGroups = [ "libvirtd" "kvm" ];

  environment.systemPackages = with pkgs; [
    virt-manager
    virt-viewer
    virtio-win
    spice-gtk
    swtpm
  ];

  services.spice-vdagentd.enable = true;
}