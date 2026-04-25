inputs:

inputs.nixpkgs.lib.composeManyExtensions [
  inputs.rust-overlay.overlays.default
  inputs.monolisa.overlays.default

  (final: prev: {
    inherit (inputs.nixpkgs-unstable.legacyPackages.${final.stdenv.hostPlatform.system})
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
      pkgs = inputs.nixpkgs-unstable.legacyPackages.${final.stdenv.hostPlatform.system};
      inherit (inputs) wrappers;
    };

    niri = final.callPackage ../packages/niri { inherit (prev) niri; };

    polkit_gnome = prev.polkit_gnome.overrideAttrs {
      # allow xdg-autostart in XDG_CURRENT_DESKTOP=niri
      postFixup = ''
        substituteInPlace "$out"/etc/xdg/autostart/polkit-gnome-authentication-agent-1.desktop \
          --replace-fail "GNOME;" "niri;GNOME;"
      '';
    };
  })
]
