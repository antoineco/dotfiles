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
      inherit (inputs.nixpkgs-unstable.legacyPackages.${system})
        ghostty

        go_1_26
        gopls
        golangci-lint
        gofumpt
        delve
        gomodifytags
        gotestsum
        gotests
        impl
        ;

      neovim = final.callPackage ../packages/neovim.nix {
        pkgs = inputs.nixpkgs-unstable.legacyPackages.${system};
        inherit (inputs) wrappers;
      };

      polkit_gnome = prev.polkit_gnome.overrideAttrs {
        # allow xdg-autostart in XDG_CURRENT_DESKTOP=niri
        postFixup = ''
          substituteInPlace "$out"/etc/xdg/autostart/polkit-gnome-authentication-agent-1.desktop \
            --replace-fail "GNOME;" "niri;GNOME;"
        '';
      };
    }
  )
]
