{ config, lib, pkgs, ... }:

{
  programs.waybar.style = ''
    @define-color bg-hover #1a1b26;
    @define-color lbg #24283b;
    @define-color bg #1a1b26;
    @define-color blue #7aa2f7;
    @define-color sky #7dcfff;
    @define-color red #f7768e;
    @define-color pink #ff007c;
    @define-color lavender #bb9af7;
    @define-color rosewater #e0af68;
    @define-color flamingo #ff9e64;
    @define-color fg #c0caf5;
    @define-color green #9ece6a;
    @define-color active-green #73daca;
    @define-color dark-fg #565f89;
    @define-color peach #ff9e64;
    @define-color border @lavender;
    @define-color gray2 #565f89;
    @define-color black4 #16161e;
    @define-color black3 #1a1b26;
    @define-color maroon #db4b4b;
    @define-color yellow #e0af68;
    @define-color soft-purple #b48ead;

    * {
      min-height: 0;
      margin: 0;
      padding: 0;
      border-radius: 3px;
      font-family: "Space Grotesk"; 
      /* font-family: "Bricolage Grotesque"; */
      font-size: 12pt;
      font-weight: 700;
      padding-bottom: 0px;
    }

    tooltip {
      background: @bg;
      border-radius: 7px;
      border: 2px solid @border;
    }

    #window {
      margin: 5px 0px 2px 0px;
      padding-left: 10px;
      padding-right: 10px;
      border-radius: 3px;
      border-bottom: 2px solid @bg;
      border-right: 2px solid @bg;
      border-color: @lbg;
      background-color: @yellow;
      color: @bg;
    }

    window#waybar.empty #window {
      background-color: transparent;
      border-bottom: none;
      border-right: none;
    }

    window#waybar {
      background-color: transparent;
      color: @lavender;
    }

    /* Workspaces */
    @keyframes button_activate {
      from {
        opacity: .3
      }

      to {
        opacity: 1.;
      }
    }

    #workspaces {
      margin: 5px 5px 2px 5px;
      border-radius: 3px;
      padding: 1px;
      background-color: @bg;
      color: @bg;
    }

    #workspaces button {
      margin: 5px 5px;
      border-radius: 3px;
      padding-left: 3px;
      padding-right: 9px;
      background-color: @bg;
      color: @fg;
    }

    #workspaces button.active {
      background-color: @blue;
      color: @bg;
    }

    #workspaces button.active:hover {
      color: @bg;
    }

    #workspaces button.urgent {
      color: @red;
    }

    #workspaces button:hover {
      color: @soft-purple;
    }

    #custom-gpu-util {
      margin: 5px 0px 2px 5px;
      padding-left: 10px;
      padding-right: 10px;
      border-radius: 3px;
      background-color: @bg;
      color: @fg;
    }

    #custom-weather {
      margin: 5px 0px 2px 5px;
      color: @soft-purple;
      border-radius: 3px;
      background-color: @bg;
      padding: 0 10px 0 6px;
    }

    #tray {
      margin: 5px 0px 2px 5px;
      border-radius: 3px;
      padding-left: 10px;
      padding-right: 10px;
      background-color: @bg;
      color: @fg;
    }

    #idle_inhibitor {
      margin: 5px 5px 2px 5px;
      padding-left: 10px;
      padding-right: 12px;
      border-radius: 3px;
      background-color: @bg;
      color: @fg;
    }

    #network {
      margin: 5px 5px 2px 5px;
      padding-left: 10px;
      padding-right: 12px;
      border-radius: 3px;
      background-color: @bg;
      color: @lavender;
    }

    #network.linked {
      color: @peach;
    }

    #network.disconnected,
    #network.disabled {
      color: @red;
    }

    #custom-cliphist {
      color: @peach;
      margin: 5px 5px 2px 5px;
      padding-left: 10px;
      padding-right: 12px;
      border-radius: 3px;
      background-color: @bg;
    }

    #custom-gpu-temp,
    #cpu,
    #memory,
    #custom-clipboard,
    #temperature {
      margin: 5px 0px 2px 0px;
      padding-left: 10px;
      padding-right: 10px;
      border-radius: 0px;
      color: @fg;
      background-color: @bg;
    }

    #cpu {
      border-top-left-radius: 3px;
      border-bottom-left-radius: 3px;
    }

    #temperature {
      border-top-right-radius: 3px;
      border-bottom-right-radius: 3px;
    }

    #mpris {
      margin: 5px 5px 2px 0px;
      padding-left: 10px;
      padding-right: 10px;
      border-radius: 3px;
      color: @fg;
      background-color: @bg;
    }

    #battery,
    #backlight,
    #bluetooth,
    #pulseaudio {
      margin-top: 5px;
      margin-bottom: 2px;
      color: @fg;
      background-color: @bg;
      border-top-right-radius: 0px;
      border-bottom-right-radius: 0px;
      border-top-left-radius: 3px;
      border-bottom-left-radius: 3px;
    }

    #battery,
    #bluetooth {
      margin-left: 0px;
      margin-right: 0px;
      padding-left: 7.5px;
      padding-right: 10px;
      border-top-left-radius: 0px;
      border-bottom-left-radius: 0px;
      border-top-right-radius: 0px;
      border-bottom-right-radius: 0px;
    }

    #backlight,
    #pulseaudio {
      margin-right: 0px;
      margin-left: 5px;
      padding-left: 10px;
      padding-right: 7.5px;
      border-top-right-radius: 0px;
      border-bottom-right-radius: 0px;
      border-top-left-radius: 3px;
      border-bottom-left-radius: 3px;
    }

    #battery {
      border-top-right-radius: 3px;
      border-bottom-right-radius: 3px;
    }

    #pulseaudio {
      margin-left: 0px;
    }

    #clock {
      margin: 5px 0px 2px 0px;
      padding-left: 10px;
      padding-right: 10px;
      border-radius: 3px;
      border-top-left-radius: 0px;
      border-bottom-left-radius: 0px;
      color: @soft-purple;
      background-color: @bg;
    }

    #taskbar {
      margin: 5px 5px 2px 5px;
      border-radius: 3px;
      padding: 1px;
      background-color: @bg;
      color: @bg;
    }

    #taskbar button {
      margin: 5px 5px;
      border-radius: 3px;
      padding-left: 3px;
      padding-right: 9px;
      background-color: @bg;
      color: @fg;
    }

    #taskbar button.active {
      background-color: @blue;
      color: @bg;
    }

    #taskbar button.urgent {
      color: @red;
    }

    #taskbar button:hover {
      color: @bg;
    }

    #mode {
      margin: 5px 5px 2px 5px;
      padding-left: 10px;
      padding-right: 10px;
      border-radius: 3px;
      background-color: @bg;
      color: @peach;
    }
  '';
}