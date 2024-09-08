# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  description = "System configurations for NixOS and macOS";

  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.2405.tar.gz"; # nixos-24.05
    nixpkgs-unstable.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1.tar.gz"; # nixpkgs-unstable

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
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.flake-compat.follows = "nixos-wsl/flake-compat";
    };

    rust-overlay = {
      url = "https://flakehub.com/f/oxalica/rust-overlay/0.1.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    disko = {
      url = "https://flakehub.com/f/nix-community/disko/1.7.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    flake-schemas.url = "https://flakehub.com/f/DeterminateSystems/flake-schemas/0.1.tar.gz";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      nixos-wsl,
      nix-darwin,
      neovim-overlay,
      rust-overlay,
      disko,
      flake-schemas,
    }:
    let
      allSystems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];

      forAllSystems =
        f: nixpkgs.lib.genAttrs allSystems (system: f { pkgs = nixpkgs.legacyPackages.${system}; });
    in
    {
      inherit (flake-schemas) schemas;

      formatter = forAllSystems ({ pkgs }: pkgs.nixfmt-rfc-style);

      devShells = forAllSystems (
        { pkgs }:
        {
          nix =
            with pkgs;
            mkShell {
              name = "nix";
              packages = [
                nixfmt-rfc-style
                nixpkgs-unstable.legacyPackages.${system}.nixd
                nixpkgs-unstable.legacyPackages.${system}.fh
              ];
            };

          go =
            with pkgs;
            mkShell {
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

          rust =
            with pkgs;
            mkShell {
              name = "rust";
              packages = [ rust-overlay.packages.${system}.default ];
            };
        }
      );
    }
    // (
      let
        modCommon =
          { pkgs, ... }:
          {
            nix = {
              package = pkgs.nixVersions.latest;
              settings = {
                experimental-features = [
                  "nix-command"
                  "flakes"
                ];
              };
              channel = {
                enable = false;
              };
            };

            environment.systemPackages = [ pkgs.pkgsBuildBuild.wezterm.terminfo ];

            programs.zsh.enable = true;

            users.users.acotten = with pkgs; {
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
          };
      in
      {
        nixosConfigurations = {
          calavera = nixpkgs.lib.nixosSystem {
            modules = [
              nixos-wsl.nixosModules.default
              modCommon
              (
                { pkgs, ... }:
                {
                  nixpkgs.hostPlatform = "x86_64-linux";

                  networking.hostName = "calavera";

                  wsl = {
                    enable = true;
                    defaultUser = "acotten";
                  };

                  users.users.acotten.packages = [ pkgs.keychain ];

                  # This value determines the NixOS release from which the default
                  # settings for stateful data, like file locations and database versions
                  # on your system were taken. It's perfectly fine and recommended to leave
                  # this value at the release version of the first install of this system.
                  # Before changing this value read the documentation for this option
                  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
                  system.stateVersion = "24.05";
                }
              )
            ];
          };

          flores = nixpkgs.lib.nixosSystem {
            modules = [
              modCommon
              disko.nixosModules.disko
              {
                nixpkgs.hostPlatform = "x86_64-linux";

                users.users.acotten = {
                  isNormalUser = true;
                  uid = 1000;
                  extraGroups = [ "wheel" ];
                  openssh.authorizedKeys.keys = [
                    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBrWkMRdF5phpLftdUHIgcSnSIKunqBecVN1jgSkuz8H"
                  ];
                };
                security.sudo.wheelNeedsPassword = false;

                networking.useNetworkd = true;

                powerManagement.enable = false;

                system.stateVersion = "24.05";
              }
              (
                { modulesPath, lib, ... }:
                {
                  imports = [ (modulesPath + "/virtualisation/openstack-config.nix") ];

                  # force disko values
                  fileSystems."/".device = lib.mkForce "/dev/disk/by-partlabel/disk-nixos-root";
                  boot.loader.grub.device = lib.mkForce "";
                }
              )
              {
                disko.devices.disk.nixos = {
                  device = "/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_drive-scsi0-0-0-0";
                  type = "disk";
                  content = {
                    type = "gpt";
                    partitions = {
                      # NOTE: disko automatically adds devices that have a EF02
                      # partition to boot.loader.grub.devices
                      boot = {
                        size = "1M";
                        type = "EF02"; # for grub MBR
                      };
                      root = {
                        size = "100%";
                        content = {
                          type = "filesystem";
                          format = "ext4";
                          mountpoint = "/";
                        };
                      };
                    };
                  };
                };
              }
            ];
          };
        };

        darwinConfigurations = {
          colomar = nix-darwin.lib.darwinSystem {
            modules = [
              modCommon
              (
                { pkgs, ... }:
                {
                  nixpkgs.hostPlatform = "aarch64-darwin";

                  networking.hostName = "colomar";

                  services.nix-daemon.enable = true;
                  nix.settings.extra-nix-path = "nixpkgs=flake:nixpkgs";

                  users = {
                    knownUsers = [ "acotten" ];
                    users.acotten = {
                      uid = 501;
                      packages = with pkgs; [
                        colima
                        docker-client
                        amazon-ecr-credential-helper
                      ];
                    };
                  };

                  environment.shells = [ pkgs.zsh ];

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

                  # Used for backwards compatibility, similarly to NixOS.
                  # Before changing this value read the documentation for this option
                  # (e.g. man configuration.nix or on https://daiderd.com/nix-darwin/manual/).
                  system.stateVersion = 4;
                }
              )
            ];
          };
        };
      }
    );
}
