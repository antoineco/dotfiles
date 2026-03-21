inputs:

inputs.nixpkgs.lib.composeManyExtensions [
  inputs.neovim-overlay.overlays.default
  inputs.rust-overlay.overlays.default
  inputs.monolisa.overlays.default

  (final: prev: {
    inherit (inputs.nixpkgs-unstable.legacyPackages.${final.stdenv.hostPlatform.system})
      vimPlugins

      colima

      ghostty
      ghostty-bin

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

    neovim = final.callPackage ../packages/neovim.nix { inherit (inputs) wrappers; };

    polkit_gnome = prev.polkit_gnome.overrideAttrs {
      # allow xdg-autostart in XDG_CURRENT_DESKTOP=niri
      postFixup = ''
        substituteInPlace "$out"/etc/xdg/autostart/polkit-gnome-authentication-agent-1.desktop \
          --replace-fail "GNOME;" "niri;GNOME;"
      '';
    };
  })
]
