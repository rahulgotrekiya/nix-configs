{ pkgs, config, ... }:

let
  # Session switcher: live sessions + zoxide dirs in one fzf list.
  # Picking a dir with no session yet creates it. Uses fzf/zoxide already
  # installed in shell.nix - no new dependency.
  tmux-jump = pkgs.writeShellScriptBin "tmux-jump" ''
    sel=$({ tmux list-sessions -F '#{session_name}'; zoxide query -l; } \
          | fzf --prompt='session> ') || exit 0

    # Exact match (-t=) so a dir sharing a session's name resolves to the session
    if tmux has-session -t="$sel" 2>/dev/null; then
      tmux switch-client -t "$sel"
    else
      # tmux treats . and : as target separators in session names
      name=$(basename "$sel" | tr '.:' '__')
      tmux has-session -t="$name" 2>/dev/null \
        || tmux new-session -ds "$name" -c "$sel"
      tmux switch-client -t "$name"
    fi
  '';
in

{
  home.packages = [ tmux-jump ];

  # Start the tmux server at login so continuum restores sessions before the
  # first terminal is opened.
  # ponytail: no ExecStop save; the 5-min continuum interval caps loss at 5 min.
  # Add resurrect's save.sh to ExecStop (needs a PATH closure) if that's too coarse.
  systemd.user.services.tmux = {
    Unit = {
      Description   = "tmux server (detached)";
      Documentation = "man:tmux(1)";
    };
    Service = {
      Type       = "forking";
      ExecStart  = "${config.programs.tmux.package}/bin/tmux new-session -d -s _boot";
      ExecStop   = "${config.programs.tmux.package}/bin/tmux kill-server";
      KillMode   = "none";
      RestartSec = 2;
    };
    Install.WantedBy = [ "default.target" ];
  };

  programs.tmux = {
    enable    = true;
    mouse     = true;
    prefix    = "C-Space";
    keyMode   = "vi";
    baseIndex = 1;
    terminal  = "xterm-256color";

    plugins = with pkgs.tmuxPlugins; [
      {
        plugin = tokyo-night-tmux;
        extraConfig = ''
          set -g @tokyo-night-tmux_show_battery_widget 0
          set -g @tokyo-night-tmux_battery_name "BAT0"
          set -g @tokyo-night-tmux_battery_low_threshold 21
          set -g @tokyo-night-tmux_show_hostname 0
          set -g @tokyo-night-tmux_show_datetime 0
          set -g @tokyo-night-tmux_show_path 0
          set -g @tokyo-night-tmux_path_format relative
          set -g @tokyo-night-tmux_window_id_style fsquare
          set -g @tokyo-night-tmux_show_git 0
        '';
      }
      sensible
      vim-tmux-navigator
      yank
      {
        plugin = resurrect;
        extraConfig = ''
          set -g @resurrect-capture-pane-contents 'on'
          # Additive to resurrect's default list (nvim, htop, less, ...)
          set -g @resurrect-processes 'lazygit'
        '';
      }
      {
        # Options must be set before continuum.tmux runs - it reads
        # @continuum-restore at load time, not lazily. Home Manager emits a
        # plugin's extraConfig immediately before its run-shell, so this is safe.
        plugin = continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '5'
        '';
      }
    ];

    extraConfig = ''
      set-option -sa terminal-overrides ",xterm*:Tc"

      # Vim-style pane navigation
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      # Status bar at bottom
      set-option -g status-position bottom

      # Pane base index
      set -g pane-base-index 1
      set-window-option -g pane-base-index 1
      set-option -g renumber-windows on

      # Killing a session lands you in the next one, not out of tmux
      set -g detach-on-destroy off

      # Alt+arrow - switch pane without prefix
      bind -n M-Left  select-pane -L
      bind -n M-Right select-pane -R
      bind -n M-Up    select-pane -U
      bind -n M-Down  select-pane -D

      # Shift+arrow - switch windows
      bind -n S-Left  previous-window
      bind -n S-Right next-window

      # Shift+Alt+vim - switch windows
      bind -n M-H previous-window
      bind -n M-L next-window

      # prefix + l was last-window before h/j/k/l took it over
      bind Tab last-window

      # Session switcher popup (sessions + zoxide dirs)
      bind o display-popup -E -w 60% -h 60% "tmux-jump"

      # Reload after nixos-rebuild - the file changes, the running server doesn't
      bind r source-file ~/.config/tmux/tmux.conf \; display-message "config reloaded"

      # Repeatable pane resize (prefix table, no clash with M-H/M-L or C-h/C-l)
      bind -r H resize-pane -L 5
      bind -r J resize-pane -D 5
      bind -r K resize-pane -U 5
      bind -r L resize-pane -R 5

      # lazygit popup, current pane's repo
      bind -n M-g display-popup -E -d "#{pane_current_path}" -w 90% -h 90% lazygit

      # vi copy-mode bindings
      bind-key -T copy-mode-vi v   send-keys -X begin-selection
      bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
      bind-key -T copy-mode-vi y   send-keys -X copy-selection-and-cancel

      # Split keeping current path
      bind '"' split-window -v -c "#{pane_current_path}"
      bind %   split-window -h -c "#{pane_current_path}"
      bind c   new-window      -c "#{pane_current_path}"
    '';
  };
}
