# direnv + nix-direnv: auto-load a project's dev environment on `cd`
# Drop a `.envrc` with `use flake` in a project, run `direnv allow`, and its
# `nix develop` shell loads automatically when you enter the directory.
_:

{
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;   # fast, cached nix flake dev shells
  };
}
