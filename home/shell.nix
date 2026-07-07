{ config, pkgs, ... }:

let
  myAliases = {
    # Editor
    v  = "nvim";
    c  = "clear";

    # Git
    lg = "lazygit";

    # ls replacements (eza)
    ls   = "eza --icons";
    lsa  = "eza -a --icons";
    ld   = "eza -lD --icons";
    lda  = "eza -al --group-directories-first";
    lf   = "eza -lf --color=always | grep -v /";
    lh   = "eza -dl .* --group-directories-first";
    lsl  = "eza -l --icons=always";
    lsla = "eza -la --icons=always";
    lt   = "eza -al --sort=modified";

    # Navigation
    ".."  = "cd ..";
    "..." = "cd ../..";
    ".3"  = "cd ../../..";
    ".4"  = "cd ../../../..";
    ".5"  = "cd ../../../../..";

    # Safer defaults
    mkdir = "mkdir -p";

    # NixOS rebuild shortcuts
    nrs = "sudo nixos-rebuild switch --flake ~/dotfiles#victus";
    nrb = "sudo nixos-rebuild boot   --flake ~/dotfiles#victus";
    hms = "home-manager switch       --flake ~/dotfiles#rahul";
  };
in

{
  home.packages = with pkgs; [
    eza
    lazygit
    fd       # fast find — fzf file/dir search
    bat      # syntax-highlighted previews
  ];

  programs.bash = {
    enable       = true;
    shellAliases = myAliases;
  };

  programs.zsh = {
    enable = true;

    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };

    shellAliases = myAliases;

    # Plugins via zplug
    zplug = {
      enable  = true;
      plugins = [
        { name = "zsh-users/zsh-syntax-highlighting"; }
        { name = "zsh-users/zsh-autosuggestions"; }
        { name = "zsh-users/zsh-completions"; }
        { name = "Aloxaf/fzf-tab"; }
      ];
    };

    oh-my-zsh = {
      enable  = true;
      plugins = [
        "git"
        "sudo"
        "docker"
        "command-not-found"
      ];
    };

    initContent = ''
      ZSH_DISABLE_COMPFIX=true
      export EDITOR=nvim

      # fzf layout — set directly here so it always takes effect
      export FZF_DEFAULT_OPTS='--layout=reverse --height=~10 --no-border'

      # Completion styling
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
      zstyle ':completion:*:descriptions' format '[%d]'
      zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}

      # disable sort when completing git checkout
      zstyle ':completion:*:git-checkout:*' sort false

      # fzf-tab previews
      zstyle ':fzf-tab:complete:cd:*'          fzf-preview 'eza -1 --color=always $realpath'
      zstyle ':fzf-tab:complete:__zoxide_z:*'  fzf-preview 'eza -1 --color=always $realpath'
      zstyle ':fzf-tab:complete:ls:*'          fzf-preview 'cat $realpath'

      # switch group with < and >
      zstyle ':fzf-tab:*' switch-group '<' '>'

      # Pass layout flags to fzf-tab (it ignores FZF_DEFAULT_OPTS)
      zstyle ':fzf-tab:*' fzf-flags '--layout=reverse' '--height=~10' '--no-border'

      # Keybindings
      bindkey -e
      bindkey '^[w' kill-region
      bindkey '^p' history-search-backward
      bindkey '^n' history-search-forward

      # History options
      setopt appendhistory
      setopt sharehistory
      setopt hist_ignore_space
      setopt hist_ignore_all_dups
      setopt hist_save_no_dups
      setopt hist_find_no_dups
    '';
  };

  programs.fzf = {
    enable               = true;
    enableZshIntegration = true;

    defaultCommand        = "fd --type f --hidden --exclude .git";
    fileWidgetCommand     = "fd --type f --hidden --exclude .git";
    fileWidgetOptions     = [
      "--preview 'bat --color=always --style=numbers --line-range=:100 {}'"
      "--preview-window 'right:55%'"
      "--bind 'ctrl-/:toggle-preview'"
    ];
    changeDirWidgetCommand = "fd --type d --hidden --exclude .git";
    changeDirWidgetOptions = [
      "--preview 'eza -1 --color=always {}'"
      "--preview-window 'right:40%'"
    ];
    historyWidgetOptions = [
      "--sort"
      "--exact"
      "--preview 'echo {}'"
      "--preview-window 'down:3:wrap'"
      "--bind 'ctrl-/:toggle-preview'"
    ];

    # Tokyo Night colours
    colors = {
      "fg"      = "#c0caf5";
      "fg+"     = "#c0caf5";
      "bg+"     = "#1a1b26";
      "hl"      = "#7aa2f7";
      "hl+"     = "#7dcfff";
      "info"    = "#7aa2f7";
      "prompt"  = "#7aa2f7";
      "pointer" = "#bb9af7";
      "marker"  = "#9ece6a";
      "spinner" = "#bb9af7";
      "header"  = "#565f89";
    };
  };

  # Zoxide
  programs.zoxide = {
    enable               = true;
    enableZshIntegration = true;
    options              = [ "--cmd cd" ];
  };

  # oh-my-posh prompt
  programs.oh-my-posh = {
    enable                = true;
    enableZshIntegration  = true;
    enableBashIntegration = true;
    settings = builtins.fromTOML (
      builtins.unsafeDiscardStringContext (
        builtins.readFile ./themes/ohmyposh.toml
      )
    );
  };
}