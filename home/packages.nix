{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [
    # shell dependency
    eza
    zsh
    zoxide
    oh-my-posh
    bat
    fzf

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
    btop
    vscode
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


    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];
}
