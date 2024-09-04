# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  description = "System configurations for NixOS and macOS";

  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.2405.tar.gz"; # nixos-24.05

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.flake-compat.follows = "nixos-wsl/flake-compat";
    };

    rust-overlay = {
      url = "https://flakehub.com/f/oxalica/rust-overlay/0.1.tar.gz";
      inputs.nixpkgs.follows = "neovim-overlay/nixpkgs";
    };

    flake-schemas.url = "https://flakehub.com/f/DeterminateSystems/flake-schemas/0.1.tar.gz";
  };

  outputs = { self, nixpkgs, nixos-wsl, nix-darwin, neovim-overlay, rust-overlay, flake-schemas }:
    let
      allSystems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];

      forAllSystems = f: nixpkgs.lib.genAttrs allSystems (system: f {
        pkgs = nixpkgs.legacyPackages.${system};
        pkgs-rust = rust-overlay.packages.${system};
      });

      mkNix = pkgs: {
        package = pkgs.nixVersions.latest;
        settings.experimental-features = [ "nix-command" "flakes" ];
      };

      mkSystemPackages = pkgs: with pkgs; [
        pkgsBuildBuild.wezterm.terminfo
      ];

      mkUser = pkgs: with pkgs; {
        shell = zsh;
        packages = [
          git
          gnumake
          curl
          jq
          yq-go
          fzf
          bat
          ripgrep
          neovim-overlay.packages.${system}.default
        ];
      };
    in
    {
      inherit (flake-schemas) schemas;

      devShells = forAllSystems ({ pkgs, pkgs-rust }: {
        go = with pkgs; mkShell {
          name = "go";
          packages = [
            go
            gopls
            golangci-lint
            gofumpt
            delve
            gomodifytags
            gotests
            impl
          ];
        };

        rust = pkgs.mkShell {
          name = "rust";
          packages = [
            pkgs-rust.default
          ];
        };
      });

      nixosConfigurations = {
        calavera = nixpkgs.lib.nixosSystem {
          modules = [
            nixos-wsl.nixosModules.default
            ({ pkgs, ... }: {
              nixpkgs.hostPlatform = "x86_64-linux";

              networking.hostName = "calavera";

              wsl = {
                enable = true;
                defaultUser = "acotten";
              };

              users.users.acotten = mkUser pkgs;

              # This value determines the NixOS release from which the default
              # settings for stateful data, like file locations and database versions
              # on your system were taken. It's perfectly fine and recommended to leave
              # this value at the release version of the first install of this system.
              # Before changing this value read the documentation for this option
              # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
              system.stateVersion = "24.05";

              nix = mkNix pkgs;

              environment.systemPackages = mkSystemPackages pkgs ++ (with pkgs; [
                keychain
              ]);

              programs.zsh.enable = true;
            })
          ];
        };
      };

      darwinConfigurations = {
        colomar = nix-darwin.lib.darwinSystem {
          modules = [
            ({ pkgs, ... }: {
              nixpkgs.hostPlatform = "aarch64-darwin";

              networking.hostName = "colomar";

              users = {
                knownUsers = [ "acotten" ];
                users.acotten = mkUser pkgs // { uid = 501; };
              };

              services.nix-daemon.enable = true;

              nix = mkNix pkgs;

              environment = {
                shells = [ pkgs.zsh ];
                systemPackages = mkSystemPackages pkgs;
              };

              programs.zsh.enable = true;

              system.defaults = {
                NSGlobalDomain = {
                  InitialKeyRepeat = 15;
                  KeyRepeat = 2;
                };
                CustomUserPreferences = {
                  NSGlobalDomain = {
                    AppleLanguages = [ "en-US" "de-DE" "fr-FR" ];
                    AppleLocale = "en_US@rg=dezzzz";
                    NSLinguisticDataAssetsRequested = [ "en" "de" "fr" ];
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
                          parameters = [ 32 49 786432 ];
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
            })
          ];
        };
      };
    };
}
