{
  lib,
  ...
}:
{
  plugins = {
    blink-cmp = {
      enable = true;
      settings = {
        enabled = lib.generators.mkLuaInline ''
          function()
            return not vim.tbl_contains({ "markdown" }, vim.bo.filetype)
              and vim.bo.buftype ~= "prompt"
              and vim.b.completion ~= false
          end
        '';
        sources = {
          default = [
            "lsp"
            "path"
            "snippets"
            "buffer"
          ];
        };
      };
    };
  };
}
