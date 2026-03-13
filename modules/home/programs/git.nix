# Generic git settings — applies to ALL users
# User-specific config (name, email, safe.directory) goes in users/<name>/default.nix
{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;

    settings = {
      init.defaultBranch = "master";
      pull.rebase = false;
      push.autoSetupRemote = true;
      core.editor = "nvim";
    };
  };
}