# User profile for Rahul — laptop (full desktop + WM)
{ config, pkgs, meta, ... }:

{
  imports = [
    ../../modules/home                      # common CLI packages
    ../../modules/home/shell.nix            # full desktop shell (oh-my-posh, zplug, zoxide)
    ../../modules/home/theme.nix            # font configuration
    ../../modules/home/programs             # common programs (git, neovim, tmux, yazi)
    ../../modules/home/programs/desktop.nix # desktop programs (alacritty, kitty, kanata)
    ../../modules/home/desktop              # GNOME dconf settings
    ../../modules/home/wm                   # Hyprland, waybar, dunst
  ];

  home.username = meta.user;
  home.homeDirectory = "/home/${meta.user}";
  home.stateVersion = "24.05";

  home.sessionVariables = {
    LANG   = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
  };

  # GTK dark theme for older GTK3 apps (libadwaita apps use dconf color-scheme instead)
  gtk = {
    enable = true;
    gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
  };

  # Desktop-only packages (not on server)
  home.packages = with pkgs; [
    # GUI apps
    vscode
    obsidian
    telegram-desktop
    libnotify
    antigravity

    # Development
    nodejs

    # Fonts
    inter
    pkgs.nerd-fonts.jetbrains-mono
    google-fonts
    (google-fonts.override {
      fonts = [
        "Bricolage Grotesque"
        "Libre Baskerville"
      ];
    })
  ];

  # Personal git identity (moved from shared git.nix module)
  programs.git.settings = {
    user = {
      name = "rahul gotrekiya";
      email = "121397381+RahulGotrekiya@users.noreply.github.com";
    };
    safe.directory = [
      "/mnt/work/personal/Obsidian Vault"
      "/mnt/work/study/Projects/PSDs/MacaulayTreeHouse"
      "/mnt/work/study/material/Courses/00 Practice/JavaScript/complete-javascript-course-master/js-small-projects"
      "/mnt/work/study/Projects/php-root/clg/mow"
      "/mnt/work/study/Projects/snake-game"
      "/mnt/work/study/Projects/nixpkgs"
      "~/tc/BIN/PROJECT/chat/"
      "/mnt/work/study/MCA/JavaScript/food"
      "/mnt/work/study/MCA/clg-lab"
    ];
  };

  programs.home-manager.enable = true;
  programs.zsh.enable = true;
}
