{
  services.kanata = {
    enable = true;

    # ThinkPad internal keyboard
    keyboards.builtin = {
      devices = [
        "/dev/input/by-path/platform-i8042-serio-0-event-kbd"
      ];

      extraDefCfg = ''
        process-unmapped-keys no
        log-layer-changes no

        concurrent-tap-hold yes  ;; requirement for defchordsv2

        chords-v2-min-idle 125
      '';

      config = ''
        (defsrc
             ` 1   2   3   4   5   6   7   8   9   0   -   =
           tab q   w   e   r   t   y   u   i   o   p   [   ]   \
          caps a   s   d   f   g   h   j   k   l   ;   '   ret
          102d z   x   c   v   b   n   m   ,   .   /
                 lalt         spc         ralt
        )

        (defvar
          streak-count 3
          streak-time 325
          tap-repress-timeout 200
          hold-timeout 200

          chord-timeout-slow 30
          chord-timeout-fast 18
        )

        (deflayer base
            ` 1    2    3    4    5    6    7    8    9    0    @<   =
          tab b    l    d    w    z    '    f    o    u    j    [    ]    \
          esc @n   @r   @t   @s   g    y    @h   @a   @e   @i   /    ret
          q   x    m    c    v    XX   k    p    .    -    ,
                 @lalt           @spc          @ralt
        )

        #|
        Shifted punctuation is implemented on a dedicated layer instead of via defoverrides,
        because defoverrides would conflict with symbols that appear shifted on the 'symbols' layer.
        |#
        (deflayermap shifted-symbols
          y -                 ;; '_
          , ;                 ;; .:
          . '                 ;; -"
          / (unmod (lsft) ;)  ;; ,;
          - .                 ;; <>
        )

        (deflayer navnum
          _   _    _    _    _    _    _    _    _    _    _    _    _
          _   kp-  7    8    9    kp+  S-5  [    S-9  S-0  ]    _    _    _
          S-; 0    4    5    6    @kpe left down up   rght .    b    _
          kp/ 1    2    3    kp*  _    home pgdn pgup end  x
                   _              XX             _
        )

        (deflayer symbols
          _   _    _    _    _    _    _    _    _    _    _    _    _
          _   S-`  .    S-8  S-7  S-2  S-5  [    S-9  S-0  ]    _    _    _
          S-- S-,  S-\  -    S-.  /    S-1  ,    S-[  S-]  ;    S-/  _
          `   '    S-'  S-=  \    _    S-3  S-6  S-;  =    S-4
                  XX              _              XX
        )

        (defoverrides
          (rsft bspc) (del)
        )

        (deftemplate charmod (char mod)
          (switch
            ((key-timing $streak-count less-than $streak-time)) $char break
            () (tap-hold-release $tap-repress-timeout $hold-timeout $char $mod) break
          )
        )

        (deftemplate combo (keys act timeout)
          $keys $act $timeout all-released (navnum)
        )

        (deftemplate combo-slow (keys act)
          (t! combo $keys $act $chord-timeout-slow)
        )

        (deftemplate combo-fast (keys act)
          (t! combo $keys $act $chord-timeout-fast)
        )

        (defalias
          ;; home row mods
          n (t! charmod n lctl)
          r (t! charmod r lalt)
          t (t! charmod t lmet)
          s (t! charmod s (multi lsft (layer-while-held shifted-symbols)))
          h (t! charmod h rsft)
          a (t! charmod a rmet)
          e (t! charmod e lalt)
          i (t! charmod i rctl)

          ;; shifted keys
          < S-,

          ;; layer taps
          spc (t! charmod spc (layer-while-held navnum))
          lalt (t! charmod bspc (layer-while-held symbols))
          ralt (layer-while-held symbols)

          kpe NumpadEqual
        )

        (defchordsv2
          (t! combo-slow (f j) (caps-word-toggle 3000))
          (t! combo-fast (w e) tab)
          (t! combo-fast (i o) @ret)
        )

        #|
        When combined with a tap-hold-release key (@s), the hold action key (LShift) gets pressed
        after the chord key (Enter) if the chord is triggered before the hold-timeout.
        This results in Enter being sent in situations where S-Enter was expected.
        Using a virtual key as the chord action causes the modifier to be pressed before the chord key.
        |#
        (defvirtualkeys ret ret)
        (defalias
          ret (multi (on-press press-vkey ret) (on-release release-vkey ret))
        )
      '';
    };
  };
}
