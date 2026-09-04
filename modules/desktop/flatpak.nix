# Flatpak — declarative app sandbox runtime
# Flathub remote is added via a systemd oneshot so it survives rebuilds
{ pkgs, ... }:

{
  services.flatpak.enable = true;

  xdg.portal = {
    enable      = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Add Flathub remote on first boot (idempotent — safe to re-run)
  systemd.services.flatpak-add-flathub = {
    description   = "Add Flathub remote for Flatpak";
    wantedBy      = [ "multi-user.target" ];
    after         = [ "network-online.target" "flatpak.service" ];
    wants         = [ "network-online.target" ];
    serviceConfig = {
      Type            = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.flatpak}/bin/flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo";
    };
  };
}
