{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # Shell tools (zsh, zoxide, oh-my-posh are managed via programs.* in shell.nix)
    eza
    bat
    fzf
    btop

    # Terminal
    alacritty
    tmux

    # Password manager
    pass
    gnupg
    pinentry-tty

    # Other
    obsidian
    lazygit
    telegram-desktop
    libnotify
    dysk
    docker-compose
    antigravity
    
    # Nodejs
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
      }
    )
  ];
}
