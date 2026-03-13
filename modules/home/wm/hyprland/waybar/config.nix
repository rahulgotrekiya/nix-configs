{ config, lib, pkgs, ... }:

{
  programs.waybar.settings = {
    mainBar = {
      layer = "top";
      position = "top";
      modules-left = [
        "clock"
        "hyprland/workspaces"
        # "custom/weather"
        # "wlr/taskbar"
        "mpris"
      ];
      modules-right = [
        # "cpu"
        # "memory"
        # "temperature"
        # "custom/gpu-temp"
        # "custom/gpu-util"
        "tray"
        "network"
        "pulseaudio"
        "bluetooth"
        "battery"
        "backlight"
      ];

      "hyprland/window" = {
        format = "{title}";
        max-length = 333;
        separate-outputs = true;
      };

      "clock" = {
        format = "<span>   </span><span>{:%I:%M %a %d}</span>";
        tooltip-format = "{calendar}";
        calendar = {
          mode = "month";
          "mode-mon-col" = 3;
          "on-scroll" = 1;
          "on-click-right" = "mode";
          format = {
            months = "<span color='#ffead3'><b>{}</b></span>";
            days = "<span color='#ecc6d9'><b>{}</b></span>";
            weeks = "<span color='#99ffdd'><b>{%W}</b></span>";
            weekdays = "<span color='#ffcc66'><b>{}</b></span>";
            today = "<span color='#ff6699'><b>{}</b></span>";
          };
        };
        actions = {
          on-click-middle = "mode";
          on-click-right = "shift_up";
          on-click = "shift_down";
        };
        format-alt = "<span>   </span><span>{:%H:%M}</span>";
      };

      "cpu" = {
        format = "<span foreground='#b8bb26'>Cpu: </span> {usage}%";
        on-click = "${config.home.homeDirectory}/.config/waybar/scripts/gpu-util";
      };

      "memory" = {
        format = "<span foreground='#d65d9e'>  </span> {}%";
        interval = 1;
      };

      "custom/gpu-util" = {
        exec = "${config.home.homeDirectory}/.config/waybar/scripts/gpu-util";
        format = "<span foreground='#67b0e8'>󰢮  </span> {}";
        interval = 1;
      };

      "custom/gpu-temp" = {
        exec = "${config.home.homeDirectory}/.config/waybar/scripts/gpu-temp";
        format = "<span foreground='#e57474'> </span> {}";
        interval = 1;
      };

      "custom/weather" = {
        exec = "${config.home.homeDirectory}/.config/waybar/scripts/get_weather.sh Gandhinagar";
        return-type = "json";
        format = "{}";
        tooltip = true;
        interval = 3600;
      };

      "temperature" = {
        "hwmon-path" = "/sys/class/hwmon/hwmon1/temp1_input";
        critical-threshold = 80;
        format = "<span foreground='#83a598'> </span> {temperatureC}°C";
        interval = 1;
      };

      "hyprland/workspaces" = {
        format = "{icon}";
        "active-only" = false;
        "sort-by-number" = false;
        "on-click" = "activate";
        "all-outputs" = false;
        format-icons = {
          "1" = " 1";
          "2" = " 2";
          "3" = " 3";
          "4" = " 4";
          "5" = " 5";
          "6" = " 6";
          "7" = " 7";
          "8" = " 8";
          "9" = " 9";
          "10" = " 10";
        };
      };

      "backlight" = {
        device = "intel_backlight";
        format = "<span foreground='#cc6666'>{icon}</span>   {percent}%";
        "tooltip-format" = "{icon}   {percent}%";
        format-icons = [
          ""
          ""
          ""
          ""
          ""
          ""
          ""
          ""
          ""
        ];
      };

      "battery" = {
        states = {
          good = 95;
          warning = 30;
          critical = 20;
        };
        format = "{icon}  {capacity}%";
        "format-charging" = "<span color='#c3e88d'>󱐋</span>  {capacity}%";
        "format-plugged" = "  {capacity}%";
        "tooltip-format" = "{time} left";
        format-icons = [
          "󰁺"
          "󰁻"
          "󰁼"
          "󰁽"
          "󰁾"
          "󰁿"
          "󰂀"
          "󰂁"
          "󰂂"
          "󰁹"
        ];
        interval = 1;
      };

      "network" = {
        format = "󰤭 Off";
        "format-wifi" = "{icon}  {essid}";
        "format-ethernet" = "<span foreground='#b48ead'>󰈀   Ethernet</span>";
        "format-disconnected" = "󰤭   Disconnected";
        "tooltip-format" = "{ifname} via {gwaddr} ";
        "tooltip-format-wifi" = "{icon}  {essid} ({signalStrength}%) ";
        "format-icons" = [
          "󰤯 "
          "󰤟 "
          "󰤢 "
          "󰤥 "
          "󰤨 "
        ];
        "tooltip-format-ethernet" = "󰈀  {ifname} ({signalStrength}%)";
        "tooltip-format-disconnected" = "Disconnected";
        "on-click" = "nm-applet";
        "on-click-right" = "pkill nm-applet";
        "max-length" = 50;
      };

      "pulseaudio" = {
        format = "{icon}  {volume}%";
        "format-bluetooth" = "    {volume}%";
        "format-muted" = "<span foreground='#E67E80'>󰖁</span>  {volume}%";
        "on-click" = "pavucontrol";
        "on-click-right" = "pactl set-sink-mute @DEFAULT_SINK@ toggle";
        "ignored-sinks" = [ "Easy Effects Sink" ];
        "format-icons" = {
          headphone = "  ";
          "hands-free" = "  ";
          headset = "󰋎 ";
          phone = " ";
          portable = " ";
          car = " ";
          default = [
            "󰕿"
            "󰖀"
            "󰕾"
          ];
        };
        "on-click-left" = "pavucontrol";
      };

      "mpris" = {
        format = "{player_icon} {dynamic}";
        "format-paused" = "{status_icon} <i>{dynamic}</i>";
        "player-icons" = {
          default = "<span foreground='#98BB6C'>󰎆  </span>";
          mpv = "🎵";
        };
        "status-icons" = {
          paused = "<span foreground='#E46876'> </span>";
        };
        "max-length" = 20;
        interval = 1;
      };

      "tray" = {
        format = "<span foreground='#D3C6AA'>{icon}</span>";
        icon-size = 14;
        spacing = 5;
      };

      "idle_inhibitor" = {
        format = "{icon}";
        format-icons = {
          activated = "󱠛 ";
          deactivated = "󱤱 ";
        };
      };

      "wlr/taskbar" = {
        format = "{name}";
        "icon-size" = 14;
        "icon-theme" = "Numix-Circle";
        "tooltip-format" = "{title}";
        "on-click" = "activate";
        "on-click-middle" = "close";
        "ignore-list" = [ "Alacritty" ];
        "app_ids-mapping" = {
          firefoxdeveloperedition = "firefox-developer-edition";
        };
        rewrite = {
          "Firefox Web Browser" = "Firefox";
          "Kitty" = "Terminal";
        };
      };

      "bluetooth" = {
        "on-click" = "${config.home.homeDirectory}/.config/waybar/scripts/bluetooth-control";
        "on-click-right" = "${config.home.homeDirectory}/.config/hypr/scripts/rofi-bluetooth";
        "on-click-middle" = "${config.home.homeDirectory}/.config/waybar/scripts/rofi-bluetooth";
        format = "{icon}";
        interval = 15;
        "format-connected" = "󰂯 {num_connections}";
        "format-connected-battery" = "{icon}  {device_alias}-{device_battery_percentage}%";
        "format-icons" = {
          on = "󰂯";
          off = "<span foreground='#76946A'>󰂲</span>";
          disabled = "󰂲";
          connected = "󰂯";
        };
        "tooltip-format" = "{device_alias} {status}";
        "format-device-preference" = [
          "device1"
          "device2"
        ];
        "tooltip-format-connected" = "{controller_alias}\n{num_connections} connected\n\n{device_enumerate}";
        "tooltip-format-enumerate-connected" = "{device_alias}";
        "tooltip-format-enumerate-connected-battery" = "{device_alias}\t{icon} {device_battery_percentage}%";
        "max-length" = 18;
      };
    };
  };
}