neovim-overlay:
{ pkgs, wlib, ... }:
{
  imports = [ wlib.wrapperModules.neovim ];

  config = {
    package = neovim-overlay.packages.${pkgs.stdenv.hostPlatform.system}.neovim;

    settings.aliases = [ "vi" ];

    specs.general.data = with pkgs.vimPlugins; [
      (nvim-treesitter.withPlugins (
        p: with p; [
          go
          rust
          yaml
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
}
