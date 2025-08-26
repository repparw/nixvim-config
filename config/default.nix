{ ... }:
{
  imports = [
    ./keymaps.nix
    ./lsp.nix
    ./plugins.nix
  ];
  files = {
    "ftplugin/lua.lua" = { };
  };

  globals = {
    have_nerd_font = true;
    mapleader = " ";
    maplocalleader = " ";
  };

  diagnostic.settings = {
    virtual_lines = {
      current_line = true;
    };
  };

  highlightOverride =
    let
      transparent = {
        bg = "none";
        ctermbg = "none";
      };
    in
    {
      Normal = transparent;
      NonText = transparent;
      SignColumn = transparent;
      LineNr = transparent;
      LineNrAbove = transparent;
      LineNrBelow = transparent;
    };

  opts = {
    splitright = true;
    splitbelow = true;
    termguicolors = true;
    ignorecase = true;
    smartcase = true;
    tabstop = 4;
    shiftwidth = 2;
    number = true;
    relativenumber = true;
    list = true;
    listchars = {
      # eol = '↲';
      tab = "» ";
      trail = "·";
      extends = "<";
      precedes = ">";
      conceal = "┊";
      nbsp = "␣";
    };
    scrolloff = 10;
    inccommand = "split";
    background = "dark";
    showmode = false;
    mouse = "a";
    updatetime = 250;
    timeoutlen = 300;
    cursorline = true;
    undofile = true;
    conceallevel = 1;
    swapfile = false;
  };

  performance.byteCompileLua.enable = true;
}
