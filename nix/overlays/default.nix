inputs:

inputs.nixpkgs.lib.composeManyExtensions [
  inputs.rust-overlay.overlays.default
  inputs.monolisa.overlays.default

  (
    final: prev:
    let
      inherit (final.stdenv.hostPlatform) system;
    in
    {
      zen-beta = inputs.zen-browser.packages.${system}.beta;

      neovim = final.callPackage ../packages/neovim.nix {
        inherit (inputs) wrappers;
      };

      niri = final.callPackage ../packages/niri.nix {
        inherit (prev) niri;
      };

      polkit_gnome = prev.polkit_gnome.overrideAttrs {
        # allow xdg-autostart in XDG_CURRENT_DESKTOP=niri
        postFixup = ''
          substituteInPlace "$out"/etc/xdg/autostart/polkit-gnome-authentication-agent-1.desktop \
            --replace-fail "OnlyShowIn=" "#OnlyShowIn="
        '';
      };
    }
  )
]
