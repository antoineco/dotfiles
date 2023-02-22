### macOS Display Overrides

System configuration overrides for external displays. Allows using unsupported scale resolutions to force HiDPI at
near-native[^1] monitor resolution.

Generated using the fabulous [BetterDisplay][betterdisplay] app, which usage should be preferred over this trick since
it supports the _true_ native monitor resolution.

On macOS Ventura (13), directories must be copied to `/Library/Displays/Contents/Resources/Overrides/`.

Vendor IDs:

- (0x410c)<sub>16</sub> = (16652)<sub>10</sub> = PHL (Philips)

Product IDs:

- (0x926)<sub>16</sub> = (2342)<sub>10</sub> = PHL 272B7QU
- (0x947)<sub>16</sub> = (2375)<sub>10</sub> = PHL 276B1

[^1]: 1px vertical row removed.

[betterdisplay]: https://github.com/waydabber/BetterDisplay
