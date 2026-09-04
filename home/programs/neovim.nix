{ ... }:

{
  programs.neovim = {
    enable        = true;
    defaultEditor = true;
    vimAlias      = true;
    viAlias       = true;

    # Add plugins here when you migrate your neovim config:
    # plugins = with pkgs.vimPlugins; [
    #   lazy-nvim
    # ];
  };
}
