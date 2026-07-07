{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "rahul gotrekiya";
        email = "121397381+RahulGotrekiya@users.noreply.github.com";
      };

      init.defaultBranch = "master";
      pull.rebase = false;
      push.autoSetupRemote = true;
      core.editor = "nvim";

      alias = {
        lg = "log --oneline --graph --decorate --all";
      };
    };
  };
}
