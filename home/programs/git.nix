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
  };
}