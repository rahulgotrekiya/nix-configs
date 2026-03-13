# Minimal shell config for servers — lightweight zsh, no eye candy
# For the full desktop shell (oh-my-posh, zplug, zoxide), use shell.nix instead.
{ config, pkgs, ... }:

let
  myAliases = {
    v = "nvim";
    c = "clear";
    lg = "lazygit";
    ls = "eza --icons";
    lsa = "eza -a --icons";
    lsl = "eza -l --icons=always";
    lsla = "eza -la --icons=always";
    lt = "eza -al --sort=modified";
    ".." = "cd ..";
    "..." = "cd ../..";
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

    initContent = ''
      # Minimal completion
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

      # Keybindings
      bindkey -e
      bindkey '^p' history-search-backward
      bindkey '^n' history-search-forward

      # History
      setopt appendhistory
      setopt sharehistory
      setopt hist_ignore_all_dups
      setopt hist_save_no_dups
    '';

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "sudo"
        "docker"
        "command-not-found"
      ];
    };
  };

  # Simple prompt — just username@host with path
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = false;
      format = "$username$hostname$directory$git_branch$git_status$character";
      username = {
        show_always = true;
        format = "[$user]($style)";
        style_user = "bold green";
      };
      hostname = {
        ssh_only = false;
        format = "@[$hostname]($style) ";
        style = "bold blue";
      };
      directory = {
        truncation_length = 3;
        format = "[$path]($style) ";
        style = "bold cyan";
      };
      git_branch.format = "[$branch]($style) ";
      git_status.format = "[$all_status$ahead_behind]($style) ";
      character = {
        success_symbol = "[❯](bold green)";
        error_symbol = "[❯](bold red)";
      };
    };
  };
}
