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

  launchd.user.agents.UserKeyMapping.serviceConfig = {
    ProgramArguments = [
      "/usr/bin/hidutil"
      "property"
      "--match"
      "{&quot;ProductID&quot;:0x0,&quot;VendorID&quot;:0x0,&quot;Product&quot;:&quot;Apple Internal Keyboard / Trackpad&quot;}"
      "--set"
      (
        let
          # https://developer.apple.com/library/archive/technotes/tn2450/_index.html
          leftCtrl = "0x7000000E0"; # USB HID 0xE0
          fnGlobe = "0xFF00000003"; # USB HID (0x0003 + 0xFF00000000 - 0x700000000)
        in
        "{&quot;UserKeyMapping&quot;:[{&quot;HIDKeyboardModifierMappingDst&quot;:${fnGlobe},&quot;HIDKeyboardModifierMappingSrc&quot;:${leftCtrl}},{&quot;HIDKeyboardModifierMappingDst&quot;:${leftCtrl},&quot;HIDKeyboardModifierMappingSrc&quot;:${fnGlobe}}]}"
      )
    ];
    RunAtLoad = true;
  };
}
