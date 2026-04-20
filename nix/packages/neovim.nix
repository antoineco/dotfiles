{ pkgs, wrappers }:
let
  module =
    { pkgs, wlib, ... }:
    {
      imports = [ wlib.wrapperModules.neovim ];

      config = {
        settings.aliases = [ "vi" ];

        specs.general.data = with pkgs.vimPlugins; [
          (nvim-treesitter.withPlugins (
            p: with p; [
              go
              rust
              yaml
              json
              bash
              zsh
              nix
              html
              devicetree
              diff
              gitignore
              git_config
              gitcommit
              git_rebase
              gitattributes
            ]
          ))
          nvim-treesitter-textobjects
          blink-cmp
        ];

        hosts = {
          node.nvim-host.enable = false;
          python3.nvim-host.enable = false;
          ruby.nvim-host.enable = false;
        };
      };
    };

  wrapper = wrappers.lib.evalModule module;
in
wrapper.config.wrap { inherit pkgs; }
