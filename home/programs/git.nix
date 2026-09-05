_:

{
  programs.git = {
    enable = true;

    settings = {
      user.name  = "rahul gotrekiya";
      user.email = "121397381+RahulGotrekiya@users.noreply.github.com";

      init.defaultBranch   = "master";
      pull.rebase          = false;
      push.autoSetupRemote = true;
      core.editor          = "nvim";
      alias.lg             = "log --oneline --graph --decorate --all";
    };
  };

  # delta - beautiful diffs (separate top-level program in this HM version)
  programs.delta = {
    enable                = true;
    enableGitIntegration  = true;
    options = {
      navigate     = true;
      side-by-side = true;
      line-numbers = true;
      syntax-theme = "TwoDark";
    };
  };
}

