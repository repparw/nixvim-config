{
  pkgs,
  lib,
  ...
}:
{
  plugins = {
    blink-copilot.enable = true;

    blink-cmp = {
      enable = true;
      settings.enabled = lib.generators.mkLuaInline ''
        function()
          return not vim.tbl_contains({ "markdown", "Avante" }, vim.bo.filetype)
            and vim.bo.buftype ~= "prompt"
            and vim.b.completion ~= false
        end
      '';
    };
  };
}
