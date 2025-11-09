{
  lib,
  pkgs,
  nixpkgs-unstable,
  ...
}:
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
        };
      };
    };
  };

  launchd =
    let
      pkgs-unstable = nixpkgs-unstable.legacyPackages.${pkgs.system};

      kanataSvcCfg = {
        ProgramArguments = [
          "${pkgs-unstable.kanata}/bin/kanata"
          "-c"
          "/Users/acotten/git/antoineco/dotfiles/kanata/apple_internal.kbd"
        ];
        RunAtLoad = false;
      };
    in
    {
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

      daemons.kanata.serviceConfig = kanataSvcCfg // {
        Label = "io.github.jtroo.kanata";
        ProcessType = "Interactive";
        StandardOutPath = "/var/log/kanata.out.log";
        StandardErrorPath = "/var/log/kanata.err.log";
      };
      # Create a companion Agent plist to trigger a TCC prompt for the IOHIDDeviceOpen
      # permission (Input Monitoring) in a login session (GUI).
      # Ref: https://developer.apple.com/forums/thread/128641
      user.agents.kanata.serviceConfig = kanataSvcCfg // {
        Label = "io.github.jtroo.kanata-tcc";
      };
    };
}
