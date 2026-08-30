{ ... }:
{
  imports = [
    ./keymaps.nix
    ./lsp.nix
    ./plugins
  ];
  files = {
    "ftplugin/lua.lua" = { };
    "lua/den/resolver.lua" = {
      extraConfigLua = ''
        local M = {}

        local function pesc(s)
          return (s:gsub("([^%w])", "%%%1"))
        end

        function M.parsePrefix(lines, curLine, cword)
          for i = #lines, 1, -1 do
            local m = lines[i]:match("with%s+den%.aspects%.([%w%.%_%-]+)%._")
            if m then return m end
          end
          local m2 = curLine:match("den%.aspects%.([%w%.%_%-]+)")
          if m2 then
            m2 = m2:gsub("%._%." .. pesc(cword) .. "$", "")
            m2 = m2:gsub("%._$", "")
            m2 = m2:gsub("%." .. pesc(cword) .. "$", "")
            if m2 ~= "" then return m2 end
          end
          return nil
        end

        function M.candidates(prefix, cword)
          local cands = {}
          if prefix then
            local p = prefix:gsub("%.", "/")
            cands[#cands + 1] = "modules/aspects/" .. p .. "/" .. cword .. ".nix"
            cands[#cands + 1] = "modules/aspects/" .. p .. "/" .. cword .. "/default.nix"
          end
          cands[#cands + 1] = "modules/aspects/" .. cword .. ".nix"
          cands[#cands + 1] = "modules/aspects/" .. cword .. "/default.nix"
          cands[#cands + 1] = "modules/" .. cword .. ".nix"
          return cands
        end

        function M.findExisting(cands, root)
          for _, rel in ipairs(cands) do
            local abs = root .. "/" .. rel
            if vim.fn.filereadable(abs) == 1 then return abs end
          end
          return nil
        end

        function M.globFallback(cword, root)
          local matches = vim.fn.globpath(root, "**/" .. cword .. ".nix", false, true)
          if #matches == 0 then
            matches = vim.fn.globpath(root, "**/" .. cword .. "/default.nix", false, true)
          end
          return matches
        end

        function M.resolveWord(cword, bufnr)
          bufnr = bufnr or 0
          local root = vim.fs.root(bufnr, { "flake.nix", ".git" })
          if not root or root == "" then root = vim.fn.getcwd() end
          local lnum = vim.api.nvim_win_get_cursor(0)[1]
          local lines = vim.api.nvim_buf_get_lines(bufnr, 0, lnum, false)
          local curLine = vim.api.nvim_get_current_line()
          local prefix = M.parsePrefix(lines, curLine, cword)
          local cands = M.candidates(prefix, cword)
          local found = M.findExisting(cands, root)
          if found then return found end
          local matches = M.globFallback(cword, root)
          if #matches == 0 then return nil end
          table.sort(matches, function(a, b) return #a < #b end)
          for _, m in ipairs(matches) do
            if m:find("modules/aspects", 1, true) then return m end
          end
          return matches[1]
        end

        function M.gotoWord(cword)
          local path = M.resolveWord(cword, 0)
          if path then
            vim.cmd("edit " .. vim.fn.fnameescape(path))
            return true
          end
          return false
        end

        return M
      '';
    };
    "ftplugin/nix.lua" = {
      extraConfigLua = ''
        local resolver = require("den.resolver")

        local function isPathWord()
          local cfile = vim.fn.expand("<cfile>")
          return cfile:find("/", 1, true) ~= nil or cfile:match("%.nix") ~= nil
        end

        local function den_gf()
          local cword = vim.fn.expand("<cword>")
          if cword == "" or not cword:match("^[%w_%-]+$") then
            pcall(vim.cmd, "normal! gf")
            return
          end
          if isPathWord() then
            pcall(vim.cmd, "normal! gf")
            return
          end
          if resolver.gotoWord(cword) then return end
          local matches = resolver.globFallback(cword, vim.fs.root(0, { "flake.nix", ".git" }) or vim.fn.getcwd())
          if #matches > 1 then
            vim.notify("gf: multiple matches for '" .. cword .. "': " .. table.concat(matches, ", "))
          end
          pcall(vim.cmd, "normal! gf")
        end

        local function den_gd()
          local cword = vim.fn.expand("<cword>")
          -- debug
          -- print("den_gd cword=" .. cword .. " cfile=" .. vim.fn.expand("<cfile>"))
          if cword == "" or not cword:match("^[%w_%-]+$") then
            vim.lsp.buf.definition()
            return
          end
          if isPathWord() then
            vim.lsp.buf.definition()
            return
          end
          if resolver.gotoWord(cword) then
            -- print("den_gd goto ok")
            return
          end
          -- print("den_gd fallback to lsp")
          vim.lsp.buf.definition()
        end

        vim.keymap.set("n", "gf", den_gf, { buffer = true, silent = true, desc = "Goto den aspect / file" })
        vim.keymap.set("n", "gF", den_gf, { buffer = true, silent = true, desc = "Goto den aspect / file" })
        local function set_gd()
          vim.keymap.set("n", "gd", den_gd, { buffer = true, silent = true, desc = "Goto den aspect definition" })
        end
        set_gd()
        vim.api.nvim_create_autocmd("LspAttach", {
          buffer = 0,
          callback = set_gd,
        })
        vim.opt_local.suffixesadd:append(".nix")
      '';
    };
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

  opts = {
    completeopt = "menuone,noselect,popup";
    autoread = true;

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
