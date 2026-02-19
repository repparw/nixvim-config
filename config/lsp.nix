{ pkgs, ... }:
{
  plugins.lsp = {
    enable = true;
    inlayHints = true;
    servers = {
      lua_ls.enable = true;
      nixd = {
        enable = true;
        settings = {
          options = {
            home-manager.expr = "(builtins.getFlake \".\").homeConfigurations.repparw.options";
            nixvim.expr = "(builtins.getFlake \".\").packages.${pkgs.stdenv.hostPlatform.system}.default.options";
          };
        };
      };
      ts_ls.enable = true;
      marksman.enable = true;
      pyright.enable = true;
      jsonls.enable = true;
      jdtls.enable = true;
    };
    keymaps = {
      silent = true;
      lspBuf = {
        gd = {
          action = "definition";
          desc = "Goto Definition";
        };
        gD = {
          action = "declaration";
          desc = "Goto Declaration";
        };
        # rest is using defaults from neovim 0.11 (K, gra, grn, grt)
        # TODO toggle inlayHints?
      };
    };
  };
}
