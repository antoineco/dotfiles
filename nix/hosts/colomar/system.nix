{ lib, pkgs, ... }:
{
  system.primaryUser = "acotten";

  system.defaults = {
    NSGlobalDomain = {
      InitialKeyRepeat = 15;
      KeyRepeat = 2;
    };
    CustomUserPreferences = {
      NSGlobalDomain = {
        AppleLanguages = [
          "en-US"
          "de-DE"
          "fr-FR"
        ];
        AppleLocale = "en_US@rg=dezzzz";
        NSLinguisticDataAssetsRequested = [
          "en"
          "de"
          "fr"
        ];
      };
      "com.apple.HIToolbox" = {
        AppleEnabledInputSources = [
          {
            InputSourceKind = "Keyboard Layout";
            "KeyboardLayout Name" = "ABC";
            "KeyboardLayout ID" = 252;
          }
          {
            InputSourceKind = "Non Keyboard Input Method";
            "Bundle ID" = "com.apple.CharacterPaletteIM";
          }
          {
            InputSourceKind = "Non Keyboard Input Method";
            "Bundle ID" = "com.apple.PressAndHold";
          }
        ];
      };
      "com.apple.symbolichotkeys" = {
        AppleSymbolicHotKeys = {
          # Input Sources > Select the previous input source
          "60" = {
            # Control-Option-Space
            # Originally Control-Space, which conflicts with my Neovim completion keymap.
            value = {
              parameters = [
                32
                49
                786432
              ];
              type = "standard";
            };
            enabled = true;
          };
          # Input Sources > Select the next source in Input menu
          "61" = {
            # Disabled to free the Control-Option-Space hotkey for
            # "Select the previous input source" above.
            enabled = false;
          };
          # Windows > General > Fill
          "237" = {
            value = {
              parameters = [
                102
                3
                1441792
              ];
              type = "standard";
            };
            enabled = true;
          };
          # Windows > General > Center
          "238" = {
            value = {
              parameters = [
                99
                8
                1441792
              ];
              type = "standard";
            };
            enabled = true;
          };
          # Windows > General > Return to Previous Size
          "239" = {
            value = {
              parameters = [
                114
                15
                1441792
              ];
              type = "standard";
            };
            enabled = true;
          };
          # Windows > Halves > Tile Left Half
          "240" = {
            value = {
              parameters = [
                65535
                123
                9830400
              ];
              type = "standard";
            };
            enabled = true;
          };
          # Windows > Halves > Tile Right Half
          "241" = {
            value = {
              parameters = [
                65535
                124
                9830400
              ];
              type = "standard";
            };
            enabled = true;
          };
          # Windows > Halves > Tile Top Half
          "242" = {
            value = {
              parameters = [
                65535
                126
                9830400
              ];
              type = "standard";
            };
            enabled = true;
          };
          # Windows > Halves > Tile Bottom Half
          "243" = {
            value = {
              parameters = [
                65535
                125
                9830400
              ];
              type = "standard";
            };
            enabled = true;
          };
          # Windows > Arrange > Arrange Left and Right
          "248" = {
            value = {
              parameters = [
                65535
                123
                10354688
              ];
              type = "standard";
            };
            enabled = true;
          };
          # Windows > Arrange > Arrange Right and Left
          "249" = {
            value = {
              parameters = [
                65535
                124
                10354688
              ];
              type = "standard";
            };
            enabled = true;
          };
          # Windows > Arrange > Arrange Top and Bottom
          "250" = {
            value = {
              parameters = [
                65535
                126
                10354688
              ];
              type = "standard";
            };
            enabled = true;
          };
          # Windows > Arrange > Arrange Bottom and Top
          "251" = {
            value = {
              parameters = [
                65535
                125
                10354688
              ];
              type = "standard";
            };
            enabled = true;
          };
        };
      };
    };
  };

  launchd = {
    user.agents.UserKeyMappingKbApple.serviceConfig = {
      ProgramArguments =
        let
          matchDevs = {
            ProductID = 0; # 0x0
            VendorID = 0; # 0x0
            Product = "Apple Internal Keyboard / Trackpad";
          };

          propVal.UserKeyMapping =
            let
              # https://developer.apple.com/library/archive/technotes/tn2450/_index.html
              capsLock = 30064771129; # 0x700000039 - USB HID 0x39
              escape = 30064771113; # 0x700000029 - USB HID 0x29
              leftCtrl = 30064771296; # 0x7000000E0 - USB HID 0xE0
              fnGlobe = 1095216660483; # 0xFF00000003 - USB HID (0x0003 + 0xFF00000000 - 0x700000000)
            in
            [
              {
                HIDKeyboardModifierMappingSrc = capsLock;
                HIDKeyboardModifierMappingDst = escape;
              }
              {
                HIDKeyboardModifierMappingSrc = fnGlobe;
                HIDKeyboardModifierMappingDst = leftCtrl;
              }
              {
                HIDKeyboardModifierMappingSrc = leftCtrl;
                HIDKeyboardModifierMappingDst = fnGlobe;
              }
            ];

          toQuotedXML = attrs: lib.escapeXML (builtins.toJSON attrs);
        in
        [
          "/usr/bin/hidutil"
          "property"
          "--match"
          (toQuotedXML matchDevs)
          "--set"
          (toQuotedXML propVal)
        ];
      RunAtLoad = true;
    };

    daemons = {
      kanata.serviceConfig = {
        Label = "io.github.jtroo.kanata";
        ProgramArguments = [
          "${pkgs.kanata}/bin/kanata"
          "-c"
          "/Users/acotten/git/antoineco/dotfiles/kanata/apple_internal.kbd"
        ];
        RunAtLoad = false;
        ProcessType = "Interactive";
        StandardOutPath = "/var/log/kanata.out.log";
        StandardErrorPath = "/var/log/kanata.err.log";
      };

      # https://github.com/pqrs-org/Karabiner-DriverKit-VirtualHIDDevice/tree/v6.7.0/files/LaunchDaemons
      karabiner-virtualhiddevice.serviceConfig = {
        Label = "org.pqrs.service.daemon.Karabiner-VirtualHIDDevice-Daemon";
        ProgramArguments = [
          "/Library/Application Support/org.pqrs/Karabiner-DriverKit-VirtualHIDDevice/Applications/Karabiner-VirtualHIDDevice-Daemon.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Daemon"
        ];
        KeepAlive = true;
        ProcessType = "Interactive";
      };
    };
  };
}
