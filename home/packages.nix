{ pkgs, lib, desktop, ... }:

{
  home.packages = with pkgs; [
    # Password manager (CLI - useful everywhere)
    pass
    gnupg
    pinentry-tty
  ] ++ lib.optionals desktop [
    # GUI apps / dev tooling - laptop only
    obsidian
    gnome-tweaks

    antigravity-ide
    vscode
    claude-code
    nodejs # required by claude-code plugins (e.g. ponytail) whose hooks run `node`
    google-chrome

    # Fonts (rendered client-side over SSH, so not needed on the server)
    nerd-fonts.jetbrains-mono

    (google-fonts.override {
      fonts = [
        "Bricolage Grotesque"
        "Libre Baskerville"
      ];
    })
  ];

  # Refresh font cache after install (only where fonts are installed)
  fonts.fontconfig.enable = desktop;

  # gpg-agent
  programs.gpg.enable = true;
  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry-tty;
    enableSshSupport = false;
  };
}
