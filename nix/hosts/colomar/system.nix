{ lib, ... }:
{
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
          {
            InputSourceKind = "Keyboard Layout";
            "KeyboardLayout Name" = "US Extended";
            "KeyboardLayout ID" = -2;
          }
          {
            InputSourceKind = "Keyboard Layout";
            "KeyboardLayout Name" = "USInternational-PC";
            "KeyboardLayout ID" = 15000;
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
        };
      };
    };
  };

  launchd.user.agents =
    let
      toQuotedXML = attrs: lib.escapeXML (builtins.toJSON attrs);
    in
    {
      UserKeyMappingKbApple.serviceConfig = {
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
                leftCtrl = 30064771296; # 0x7000000E0 - USB HID 0xE0
                fnGlobe = 1095216660483; # 0xFF00000003 - USB HID (0x0003 + 0xFF00000000 - 0x700000000)
              in
              [
                {
                  HIDKeyboardModifierMappingSrc = fnGlobe;
                  HIDKeyboardModifierMappingDst = leftCtrl;
                }
                {
                  HIDKeyboardModifierMappingSrc = leftCtrl;
                  HIDKeyboardModifierMappingDst = fnGlobe;
                }
              ];
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

      UserKeyMappingKbMagicforce.serviceConfig = {
        ProgramArguments =
          let
            matchDevs = {
              VendorID = 1241; # 0x4d9
              ProductID = 36; # 0x24
              Product = "USB Gaming Keyboard";
            };

            propVal.UserKeyMapping =
              let
                # https://developer.apple.com/library/archive/technotes/tn2450/_index.html
                leftAlt = 30064771298; # 0x7000000E2 - USB HID 0xE2
                leftWin = 30064771299; # 0x7000000E3 - USB HID 0xE3
              in
              [
                {
                  HIDKeyboardModifierMappingSrc = leftWin;
                  HIDKeyboardModifierMappingDst = leftAlt;
                }
                {
                  HIDKeyboardModifierMappingSrc = leftAlt;
                  HIDKeyboardModifierMappingDst = leftWin;
                }
              ];
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
    };
}
