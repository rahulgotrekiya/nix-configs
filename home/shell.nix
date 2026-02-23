{ config, pkgs, ... }:

let
  myAliases = {
    v = "nvim";
    c = "clear";
    lg = "lazygit";
    ls = "eza --icons";
    lsa = "eza -a --icons";
    ld = "eza -lD --icons";
    lda = "eza -al --group-directories-first";
    lf = "eza -lf --color=always | grep -v /";
    lh = "eza -dl .* --group-directories-first";
    lsl = "eza -l --icons=always";
    lsla = "eza -la --icons=always";
    lt = "eza -al --sort=modified";
    ".." = "cd ..";
    "..." = "cd ../..";
    ".3" = "cd ../../..";
    ".4" = "cd ../../../..";
    ".5" = "cd ../../../../..";
    mkdir = "mkdir -p";
  };
in

{
  programs.bash = {
    enable = true;
    shellAliases = myAliases;
  };

  programs.zsh = {
    enable = true;
    history.size = 10000;
    history.path = "${config.xdg.dataHome}/zsh/history";
    shellAliases = myAliases;
    zplug = {
      enable = true;
      plugins = [
        { name = "zsh-users/zsh-syntax-highlighting"; } 
        { name = "zsh-users/zsh-autosuggestions"; } 
        { name = "zsh-users/zsh-completions"; }
        { name = "Aloxaf/fzf-tab"; }
      ];
    };
    initContent = ''
      ZSH_DISABLE_COMPFIX=true
      export EDITOR=nvim

      # Completion styling
	    zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
    	zstyle ':completion:*' menu no
    	zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
    	zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'
       
      # disable sort when completing `git checkout`
    	zstyle ':completion:*:git-checkout:*' sort false
      
      # set descriptions format to enable group support
    	# NOTE: don't use escape sequences here, fzf-tab will ignore them
      zstyle ':completion:*:descriptions' format '[%d]'

    	# set list-colors to enable filename colorizing
    	zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}

    	# preview directory's content with eza when completing cd
    	zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza -1 --color=always $realpath'
    	zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
    	zstyle ':fzf-tab:complete:ls:*' fzf-preview 'cat $realpath'

    	# switch group using `<` and `>`
    	zstyle ':fzf-tab:*' switch-group '<' '>'

	    # Keybindings
    	bindkey -e
    	bindkey '^p' history-search-backward
    	bindkey '^n' history-search-forward
    	bindkey '^[w' kill-region

    	setopt appendhistory
    	setopt sharehistory
    	setopt hist_ignore_space
    	setopt hist_ignore_all_dups
    	setopt hist_save_no_dups
    	setopt hist_ignore_dups
    	setopt hist_find_no_dups
    '';

    oh-my-zsh = {
      enable = true;
      plugins = [
       "git"
       "sudo"
       "docker"
       "command-not-found"
       "pass"
      ];
    };
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = ["--cmd cd"];
  };

  programs.oh-my-posh = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    settings = builtins.fromTOML (builtins.unsafeDiscardStringContext (builtins.readFile ./themes/ohmyposh.toml));
  };
}
