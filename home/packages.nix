{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Password manager
    pass
    gnupg
    pinentry-tty

    # Other
    obsidian
    gnome-tweaks

    antigravity-ide
    vscode
    claude-code
    nodejs # required by claude-code plugins (e.g. ponytail) whose hooks run `node`
    google-chrome

    # Fonts
    nerd-fonts.jetbrains-mono
    mona-sans

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
