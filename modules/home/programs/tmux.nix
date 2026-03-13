{ config, pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    mouse = true;
    prefix = "C-Space";
    keyMode = "vi";
    baseIndex = 1;
    terminal = "xterm-256color";
      plugins = with pkgs.tmuxPlugins; [
        {
          plugin = tokyo-night-tmux;
          extraConfig = ''
            # Tokyo Night theme configuration
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
        resurrect
        continuum
      ];
    extraConfig = ''
      set-option -sa terminal-overrides ",xterm*:Tc"

      # Vim style pane selection
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      # status bar position
      set-option -g status-position bottom

      # Set pane base index
      set -g pane-base-index 1
      set-window-option -g pane-base-index 1
      set-option -g renumber-windows on

      # Use Alt-arrow keys without prefix key to switch panes
      bind -n M-Left select-pane -L
      bind -n M-Right select-pane -R
      bind -n M-Up select-pane -U
      bind -n M-Down select-pane -D

      # Shift arrow to switch windows
      bind -n S-Left previous-window
      bind -n S-Right next-window

      # Shift Alt vim keys to switch windows
      bind -n M-H previous-window
      bind -n M-L next-window

      # keybindings
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

      # Split windows with current path
      bind '"' split-window -v -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"
      bind c new-window -c "#{pane_current_path}"
    '';
  };
}
