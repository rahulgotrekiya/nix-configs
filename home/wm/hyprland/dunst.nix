{
  pkgs,
  config,
  lib,
  ...
}: {
  services.dunst = {
    enable = true;

    settings = {
      global = {
        # ── Layout & Position ──────────────────────────
        monitor = 0;
        follow = "keyboard";
        width = 320;
        height = 120;
        origin = "top-right";
        offset = "12x12";
        gap_size = 6;

        # ── Progress Bar ───────────────────────────────
        progress_bar = true;
        progress_bar_height = 6;
        progress_bar_frame_width = 0;
        progress_bar_min_width = 280;
        progress_bar_max_width = 320;
        progress_bar_corner_radius = 3;

        # ── Minimal Appearance ─────────────────────────
        transparency = 0;
        separator_height = 0;
        padding = 12;
        horizontal_padding = 14;
        frame_width = 0;
        separator_color = "auto";
        corner_radius = 3;

        # ── Typography (matching Waybar) ───────────────
        font = "Space Grotesk Bold 12";
        markup = "full";
        format = "<b>%s</b>\\n<span size='small'>%b</span>";
        alignment = "left";
        vertical_alignment = "center";
        word_wrap = true;

        # ── Icons ──────────────────────────────────────
        icon_position = "left";
        min_icon_size = 32;
        max_icon_size = 48;
        icon_corner_radius = 3;

        # ── Behavior ───────────────────────────────────
        sort = true;
        idle_threshold = 120;
        show_indicators = false;
        history_length = 20;
        sticky_history = true;
        show_age_threshold = -1;
        mouse_left_click = "close_current";
        mouse_middle_click = "close_all";
        mouse_right_click = "do_action, close_current";
      };

      # ── Tokyo Night palette (matching Waybar) ──────
      urgency_low = {
        background = "#1a1b26";
        foreground = "#c0caf5";
        highlight = "#565f89";
        timeout = 4;
      };

      urgency_normal = {
        background = "#1a1b26";
        foreground = "#c0caf5";
        highlight = "#bb9af7";
        timeout = 6;
      };

      urgency_critical = {
        background = "#1a1b26";
        foreground = "#c0caf5";
        highlight = "#f7768e";
        timeout = 0;
      };
    };
  };
}
