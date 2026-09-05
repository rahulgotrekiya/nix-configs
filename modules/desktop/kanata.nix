# Uses services.kanata instead of a user systemd service to avoid /dev/uinput issues
{ username, ... }:

{
  boot.kernelModules = [ "uinput" ];
  hardware.uinput.enable = true;

  users.users.${username}.extraGroups = [ "input" "uinput" ];

  services.kanata = {
    enable = true;

    keyboards.default = {
      devices = [];

      # Extra options injected into the defcfg block the module generates
      extraDefCfg = "process-unmapped-keys yes";

      config = ''
        ;; Kanata - Home Row Mods / Navigation / Mouse / Caps Word

        ;; Source Keys
        (defsrc
          tab  q    w    e    r    t    y    u    i    o    p
          caps a    s    d    f    g    h    j    k    l    ;    ralt
               z    x    c    v    b    n    m    ,    .    /
                                    spc
        )

        ;; Timing Variables
        (defvar
          tap-time  150
          hold-time 250
        )

        ;; Core Aliases
        (defalias
          ;; Caps Lock → tap: Esc | hold: Left Ctrl
          escctrl (tap-hold 200 150 esc lctrl)

          ;; Home row mods (tap-hold-release to reduce misfires)
          ;; Left:  A=Super  S=Alt  D=Shift  F=Ctrl
          ;; Right: J=Ctrl   K=Shift  L=Alt  ;=Super
          a-mod (tap-hold-release $tap-time $hold-time a lmet)
          s-mod (tap-hold-release $tap-time $hold-time s lalt)
          d-mod (tap-hold-release $tap-time $hold-time d lsft)
          f-mod (tap-hold-release $tap-time $hold-time f lctl)
          j-mod (tap-hold-release $tap-time $hold-time j rctl)
          k-mod (tap-hold-release $tap-time $hold-time k rsft)
          l-mod (tap-hold-release $tap-time $hold-time l ralt)
          ;-mod (tap-hold-release $tap-time $hold-time ; rmet)

          ;; Caps Word - auto-disables after space/punctuation
          cw (caps-word 2000)

          ;; Space → tap: Space | hold: Mouse layer (temporary)
          mou-spc (tap-hold 200 200 spc (layer-while-held mouse))

          ;; Tab → tap: Tab | hold: Navigation layer (temporary)
          nav-tab (tap-hold 200 200 tab (layer-while-held navigation))

          ;; Right Alt → tap: Toggle Mouse | hold: Temporary Mouse
          mou-ralt (tap-hold 200 200 (layer-switch mouse) (layer-while-held mouse))

          ;; Exit mouse layer → return to base
          exit-mou (layer-switch base)
        )

        ;; Mouse Aliases
        (defalias
          ;; Precise movement - HJKL right hand (slow, fine)
          ms-l (movemouse-left  5 1)
          ms-d (movemouse-down  5 1)
          ms-u (movemouse-up    5 1)
          ms-r (movemouse-right 5 1)

          ;; Accelerated movement - ESDF left hand (fast, coarse)
          ms-al (movemouse-accel-left  1 1000 1 5)
          ms-ad (movemouse-accel-down  1 1000 1 5)
          ms-au (movemouse-accel-up    1 1000 1 5)
          ms-ar (movemouse-accel-right 1 1000 1 5)

          ;; Scroll wheel
          mw-u (mwheel-up    50 120)
          mw-d (mwheel-down  50 120)
          mw-l (mwheel-left  50 120)
          mw-r (mwheel-right 50 120)

          ;; Mouse buttons
          ml mlft
          mr mrgt
          mm mmid
        )

        ;; Layer: Base
        ;; Nav/  Q    W    E    R    T    Y    U    I    O    P
        ;; Tab   Esc/ A    S    D    F    G    H    J    K    L    ;   Mou
        ;; hold  Ctrl ⌘    ⌥    ⇧    ^              ^    ⇧    ⌥   ⌘  tap/hold
        ;; Z    X    C    V    B    N    M    ,    .    /
        ;; Mouse(hold)/Space(tap)
        (deflayer base
          @nav-tab  _       _       _       _       _       _       _       _       _       _
          @escctrl  @a-mod  @s-mod  @d-mod  @f-mod  _       _       @j-mod  @k-mod  @l-mod  @;-mod  @mou-ralt
                    _       _       _       _       _       _       _       _       _       _
                                              @mou-spc
        )

        ;; Layer: Navigation
        ;; Tab   Q    W    E    R    T    Home PgDn PgUp End  P
        ;; CapsW  A    S    D    F    G    ←    ↓    ↑    →   ;   RAlt
        ;; Undo Cut  Copy Paste B   Bksp Del   ,    .   /
        ;; Enter
        (deflayer navigation
          _        _       _       _       _       _       home    pgdn    pgup    end     _
          @cw      _       _       _       _       _       left    down    up      right   _       ralt
                   C-z     C-x     C-c     C-v     _       bspc    del     _       _       _
                                              ret
        )

        ;; Layer: Mouse
        ;; Tab   Q    W    ↑Acc  RClk MClk  ScL  ScU  ScD  ScR  P
        ;; Exit  LClk  /   ↑Acc  RClk MClk   ←    ↓    ↑    →   /   Exit
        ;; ←Acc ↓Acc →Acc        Precise HJKL
        ;; LClick(drag)
        (deflayer mouse
          _          _       _       @ms-au  @mr     @mm     @mw-l   @mw-u   @mw-d   @mw-r   _
          @exit-mou  @ml     @ms-al  @ms-ad  @ms-ar  _       @ms-l   @ms-d   @ms-u   @ms-r   _       @exit-mou
                     C-z     C-x     C-c     C-v     _       _       _       _       _       _
                                               mlft
        )
      '';
    };
  };
}
