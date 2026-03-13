{ config, pkgs, ... }:

{
  programs.yazi = {
    enable = true;
    shellWrapperName = "y";
    settings = {
      manager = {
        ratio= [
          1
          4
          3
        ];
        sort_by = "natural";
        sort_sensitive = true;
        sort_reverse = false;
        sort_dir_first = true;
        linemode = "size";
        show_hidden = true;
        show_symlink = true;
      };
      opener = {
        play = [
	        {
            run = "flatpak run org.videolan.VLC \"$@\"";
            orphan = true;
            for = "unix";
          }
        ];
      };
    };
  };
}