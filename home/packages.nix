{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Password manager
    pass
    gnupg
    pinentry-tty

    # Other
    obsidian

    # Fonts
    nerd-fonts.jetbrains-mono

    (google-fonts.override {
      fonts = [
        "Bricolage Grotesque"
        "Libre Baskerville"
      ];
    })
  ];

  # Refresh font cache after install
  fonts.fontconfig.enable = true;

  # gpg-agent
  programs.gpg.enable = true;
  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry-tty;
    enableSshSupport = false;
  };
}
