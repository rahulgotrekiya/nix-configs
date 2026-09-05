{ config, pkgs, ... }:

let
  colors = import ./themes/colors.nix;
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

    # NixOS rebuild shortcuts (home-manager rebuilds together with the system)
    nrs = "sudo nixos-rebuild switch --flake ~/dotfiles#victus";
    nrb = "sudo nixos-rebuild boot   --flake ~/dotfiles#victus";
  };
in

{
  home.packages = with pkgs; [
    eza
    lazygit
    fd       # fast find - fzf file/dir search
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

    initContent = ''
      # Plugins (Nix store, no network)
      # zsh-completions - extra fpath entries (before compinit)
      fpath+=(${pkgs.zsh-completions}/share/zsh/site-functions)

      # fzf-tab     - must be after compinit, before other wrappers
      source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
      # autosuggestions
      source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
      # syntax-highlighting - always last
      source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

      # fzf layout - set directly here so it always takes effect
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

      # Word / line navigation - restores what oh-my-zsh used to bind
      bindkey '^[[1;5C' forward-word        # Ctrl+Right
      bindkey '^[[1;5D' backward-word       # Ctrl+Left
      bindkey '^[[1;3C' forward-word        # Alt+Right
      bindkey '^[[1;3D' backward-word       # Alt+Left
      bindkey '^[[H'    beginning-of-line   # Home
      bindkey '^[[F'    end-of-line         # End
      bindkey '^[[1~'   beginning-of-line   # Home (alt terminfo)
      bindkey '^[[4~'   end-of-line         # End (alt terminfo)
      bindkey '^[[3~'   delete-char         # Delete
      bindkey '^[[3;5~' kill-word           # Ctrl+Delete
      bindkey '^H'      backward-kill-word  # Ctrl+Backspace
      # Esc Esc - prepend sudo to current command (replaces OMZ sudo plugin)
      sudo-command-line() { [[ -z $BUFFER ]] && zle up-history; BUFFER="sudo $BUFFER"; zle end-of-line; }
      zle -N sudo-command-line
      bindkey '\e\e' sudo-command-line

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
    fileWidget.command     = "fd --type f --hidden --exclude .git";
    fileWidget.options     = [
      "--preview 'bat --color=always --style=numbers --line-range=:100 {}'"
      "--preview-window 'right:55%'"
      "--bind 'ctrl-/:toggle-preview'"
    ];
    changeDirWidget.command = "fd --type d --hidden --exclude .git";
    changeDirWidget.options = [
      "--preview 'eza -1 --color=always {}'"
      "--preview-window 'right:40%'"
    ];
    historyWidget.options = [
      "--sort"
      "--exact"
      "--preview 'echo {}'"
      "--preview-window 'down:3:wrap'"
      "--bind 'ctrl-/:toggle-preview'"
    ];

    # Tokyo Night colours
    colors = {
      "fg"      = colors.fgBright;
      "fg+"     = colors.fgBright;
      "bg+"     = colors.bg;
      "hl"      = colors.blue;
      "hl+"     = colors.cyanLight;
      "info"    = colors.blue;
      "prompt"  = colors.blue;
      "pointer" = colors.brightMagenta;
      "marker"  = colors.green;
      "spinner" = colors.brightMagenta;
      "header"  = colors.comment;
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