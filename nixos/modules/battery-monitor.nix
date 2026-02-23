{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.battery-monitor;
in {
  options.services.battery-monitor = {
    enable = mkEnableOption "Battery level monitoring service";

    normalLevels = mkOption {
      type = types.listOf types.int;
      default = [ 30 20 15 ];
      description = "Battery levels at which to show normal notifications";
    };

    criticalLevel = mkOption {
      type = types.int;
      default = 10;
      description = "Battery level below which to show continuous critical notifications";
    };

    criticalIntervalSeconds = mkOption {
      type = types.int;
      default = 1;
      description = "Interval between critical notifications in seconds";
    };

    hibernateLevel = mkOption {
      type = types.nullOr types.int;
      default = 5;
      description = "Battery level at which to hibernate the system (null to disable). Note: enable/handling of hibernate is separate from this module.";
    };

    chargerNotifications = mkOption {
      type = types.bool;
      default = true;
      description = "Enable notifications when charger is connected or disconnected";
    };
  };

  config = mkIf cfg.enable {
    services.upower.enable = true;

    systemd.user.services.battery-monitor = {
      description = "Battery level monitoring service";
      wantedBy = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];

      serviceConfig = {
        Type = "simple";
        Restart = "always";
        RestartSec = "5s";
        PassEnvironment = [
          "WAYLAND_DISPLAY"
          "DISPLAY"
          "DBUS_SESSION_BUS_ADDRESS"
          "XDG_RUNTIME_DIR"
          "HOME"
        ];
        # Reference the script as a separate variable — avoids nested interpolation issues
        ExecStart = let
          script = pkgs.writeShellScript "battery-monitor" ''
            PATH=${lib.makeBinPath (with pkgs; [ libnotify upower coreutils gnugrep gawk ])}

            NORMAL_LEVELS="${concatStringsSep " " (map toString cfg.normalLevels)}"
            CRITICAL_LEVEL=${toString cfg.criticalLevel}
            CRITICAL_INTERVAL=${toString cfg.criticalIntervalSeconds}
            CHARGER_NOTIFICATIONS=${if cfg.chargerNotifications then "true" else "false"}

            LAST_NOTIFICATION_LEVEL=100
            PREV_CHARGING_STATE="unknown"
            FULL_NOTICE_SENT=false
            ALMOST_FULL_SENT=false
            CRITICAL_REPLACE_ID=9999

            detect_state() {
              STATE=$(upower -i $(upower -e | grep -m1 -E 'BAT|battery') 2>/dev/null \
                | grep "state" | awk '{print $2}')
              case "$STATE" in
                charging|fully-charged|pending-charge) echo "charging" ;;
                discharging|pending-discharge) echo "discharging" ;;
                *) echo "unknown" ;;
              esac
            }

            echo "Battery monitor started."

            while true; do
              BATTERY_DEV=$(upower -e | grep -m1 -E 'BAT|battery')
              [ -z "$BATTERY_DEV" ] && sleep 5 && continue

              INFO=$(upower -i "$BATTERY_DEV")
              BATTERY_PCT=$(echo "$INFO" | grep percentage | grep -o "[0-9]\+")
              CHARGING=$(detect_state)

              if [ "$CHARGER_NOTIFICATIONS" = "true" ] && [ "$PREV_CHARGING_STATE" != "unknown" ] \
                && [ "$CHARGING" != "$PREV_CHARGING_STATE" ]; then
                if [ "$CHARGING" = "charging" ]; then
                  notify-send --close=$CRITICAL_REPLACE_ID 2>/dev/null || true
                  notify-send -u low "Charger Connected" "Battery is now charging ($BATTERY_PCT%)" -i battery-good-charging
                  LAST_NOTIFICATION_LEVEL=100
                else
                  notify-send -u low "Charger Disconnected" "Running on battery ($BATTERY_PCT%)" -i battery-good
                  FULL_NOTICE_SENT=false
                  ALMOST_FULL_SENT=false
                fi
              fi

              PREV_CHARGING_STATE="$CHARGING"

              if [ "$CHARGING" = "charging" ]; then
                if [ "$BATTERY_PCT" -ge 95 ] && [ "$ALMOST_FULL_SENT" = false ]; then
                  notify-send -u low -i battery-full "Battery Almost Full" "Battery reached 95%"
                  ALMOST_FULL_SENT=true
                fi
                if [ "$BATTERY_PCT" -ge 100 ] && [ "$FULL_NOTICE_SENT" = false ]; then
                  notify-send -u normal -i battery-full-charged "Battery Fully Charged" "You can remove the charger now."
                  FULL_NOTICE_SENT=true
                fi
                sleep 1
                continue
              fi

              FULL_NOTICE_SENT=false
              ALMOST_FULL_SENT=false

              if [ "$BATTERY_PCT" -le "$CRITICAL_LEVEL" ]; then
                notify-send -u critical --replace-id=$CRITICAL_REPLACE_ID \
                  "Battery Critical!" "Battery at $BATTERY_PCT%. Connect charger now!" \
                  -i battery-empty
                sleep "$CRITICAL_INTERVAL"
                continue
              fi

              if [ "$CHARGING" = "discharging" ]; then
                for LEVEL in $NORMAL_LEVELS; do
                  if [ "$BATTERY_PCT" -le "$LEVEL" ] && [ "$LAST_NOTIFICATION_LEVEL" -gt "$LEVEL" ]; then
                    ICON="battery-good"
                    URGENCY="low"
                    if [ "$LEVEL" -le 20 ]; then
                      ICON="battery-low"
                      URGENCY="normal"
                    fi
                    notify-send -u "$URGENCY" "Battery Notice" "Battery at $BATTERY_PCT%" -i "$ICON"
                    LAST_NOTIFICATION_LEVEL="$BATTERY_PCT"
                    break
                  fi
                done
              fi

              sleep 1
            done
          '';
        in "${script}";
      };
    };
  };
}