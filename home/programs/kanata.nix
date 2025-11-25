{ config, lib, pkgs, ... }:
 
{
  home.packages = with pkgs; [
    kanata
  ]; 
  # Create a systemd user service for Kanata
  systemd.user.services.kanata = {
    Unit = {
      Description = "Kanata keyboard remapper";
      Documentation = "https://github.com/jtroo/kanata";
    };

    Service = {
      Environment = "PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/bin";
      Type = "simple";
      ExecStart = "${pkgs.kanata}/bin/kanata --cfg %h/.config/kanata/config.kbd";
      Restart = "on-failure";
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  # Create the kanata configuration file
  home.file.".config/kanata/config.kbd".text = ''
    ;; Kanata Configuration for caps to esc+ctrl and home row mods

    (defcfg
      process-unmapped-keys yes
    )

    (defsrc
      caps a s d f g h j k l ; ralt
    )

    (defvar
      tap-time 200
      hod-time 200
    )

    (defalias
      escctrl (tap-hold 300 100 esc lctrl)
      ;; Home row mods
      a-mod (tap-hold $tap-time $hod-time a lmet)
      s-mod (tap-hold $tap-time $hod-time s lalt)
      d-mod (tap-hold $tap-time $hod-time d lsft)
      f-mod (tap-hold $tap-time $hod-time f lctl)
      j-mod (tap-hold $tap-time $hod-time j rctl)
      k-mod (tap-hold $tap-time $hod-time k rsft)
      l-mod (tap-hold $tap-time $hod-time l ralt)
      ;-mod (tap-hold $tap-time $hod-time ; rmet)

      ;; Layer switching - modified to use tap-hold for Right Alt
      ;; Tap to toggle between layers, hold for temporary access
      navtoggle (tap-hold 200 200 (layer-switch navigation) (layer-toggle navigation))
      tobase (layer-switch base)
    )

    (deflayer base
      @escctrl @a-mod @s-mod @d-mod @f-mod g h @j-mod @k-mod @l-mod @;-mod @navtoggle
    )

    (deflayer navigation
      caps @a-mod @s-mod @d-mod @f-mod g left down up right ; @tobase
    )
  '';
}