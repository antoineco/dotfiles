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
        AppleSymbolicHotKeys =
          let
            hotkey =
              mods: key:
              let
                modMask = {
                  shift = 131072; # 2^17
                  control = 262144; # 2^18
                  option = 524288; # 2^19
                  command = 1048576; # 2^20
                };

                keyCodes = {
                  # [
                  #   ASCII
                  #   AppleScript
                  # ]
                  space = [
                    32
                    49
                  ];
                  c = [
                    99
                    8
                  ];
                  f = [
                    102
                    3
                  ];
                  r = [
                    114
                    15
                  ];
                  left = [
                    65535
                    123
                  ];
                  right = [
                    65535
                    124
                  ];
                  down = [
                    65535
                    125
                  ];
                  up = [
                    65535
                    126
                  ];
                };

                keycodes =
                  keyCodes.${lib.toLower key} or [
                    65535
                    65535
                  ];

                modsum = builtins.foldl' (acc: m: acc + (modMask.${lib.toLower m} or 0)) 0 mods;
              in
              {
                value = {
                  parameters = keycodes ++ [ modsum ];
                  type = "standard";
                };
                enabled = true;
              };
          in
          # Input Sources
          {
            # Select the previous input source
            "60" = hotkey [ "Control" "Option" ] "Space";
            # Select the next source in Input menu
            "61" = {
              # Disabled to free the Control-Option-Space hotkey for
              # "Select the previous input source" above.
              enabled = false;
            };
          }
          # Windows
          // (
            # General
            {
              # Fill
              "237" = hotkey [ "Control" "Shift" "Command" ] "F";
              # Center
              "238" = hotkey [ "Control" "Shift" "Command" ] "C";
              # Return to Previous Size
              "239" = hotkey [ "Control" "Shift" "Command" ] "R";
            }
            # Halves
            // {
              # Tile Left
              "240" = hotkey [ "Control" "Shift" "Command" ] "Left";
              # Tile Right
              "241" = hotkey [ "Control" "Shift" "Command" ] "Right";
              # Tile Top
              "242" = hotkey [ "Control" "Shift" "Command" ] "Up";
              # Tile Bottom
              "243" = hotkey [ "Control" "Shift" "Command" ] "Down";
            }
            # Arrange
            // {
              # Left and Right
              "248" = hotkey [ "Control" "Option" "Shift" "Command" ] "Left";
              # Right and Left
              "249" = hotkey [ "Control" "Option" "Shift" "Command" ] "Right";
              # Top and Bottom
              "250" = hotkey [ "Control" "Option" "Shift" "Command" ] "Up";
              # Bottom and Top
              "251" = hotkey [ "Control" "Option" "Shift" "Command" ] "Down";
            }
          );
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
