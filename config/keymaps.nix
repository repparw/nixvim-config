{ config, lib, ... }:
let
  picker = key: method: desc: {
    action = lib.nixvim.mkRaw ''function() require("snacks.picker").${method}() end'';
    key = "${key}";
    mode = "n";
    options.desc = desc;
  };
in
{
  keymaps = [
    {
      action = lib.nixvim.mkRaw ''
        function()
          local file_source = "files"
          if vim.fn.system("git rev-parse --is-inside-work-tree"):find("true") then
            file_source = "git_files"
          end

          require("snacks.picker").pick({
            title = "Find files and grep",
            live = true,
            supports_live = true,
            format = "file",
            filter = {
              transform = function(_, filter)
                filter.pattern = filter.search
              end,
            },
            finder = function(opts, ctx)
              local files = require("snacks.picker.source.files")
              local git = require("snacks.picker.source.git")
              local grep = require("snacks.picker.source.grep")

              local file_opts = Snacks.config.merge({}, opts, opts.sources[file_source])
              local grep_opts = Snacks.config.merge({}, opts, opts.sources.grep)
              local file_filter = ctx.filter:clone()
              file_filter.search = ""

              local file_ctx = ctx:clone(file_opts)
              file_ctx.filter = file_filter

              local results = {
                file_source == "git_files" and git.files(file_opts, file_ctx) or files.files(file_opts, file_ctx),
                grep.grep(grep_opts, ctx),
              }

              return function(cb)
                for source_id, result in ipairs(results) do
                  if type(result) == "table" then
                    for _, item in ipairs(result) do
                      item.source_id = source_id
                      cb(item)
                    end
                  elseif type(result) == "function" then
                    result(function(item)
                      item.source_id = source_id
                      cb(item)
                    end)
                  end
                end
              end
            end,
          })
        end'';
      key = "<C-p>";
      mode = "n";
      options.desc = "Find files and grep";
    }
    (picker "<leader>fh" "help" "[F]ind [H]elp")
    (picker "<leader>fk" "keymaps" "[F]ind [K]eymaps")
    (picker "<leader>fg" "grep" "[F]ind by [G]rep")
    (picker "<leader>fD" "diagnostics" "[F]ind [D]iagnostics")
    (picker "<leader>fd" "zoxide" "[F]ind by [D]irectory")
    (picker "<leader><space>" "resume" "Resume last search")
    (picker "gd" "lsp_definitions" "[G]oto [D]efinition")
    (picker "gD" "lsp_declarations" "[G]oto [D]eclaration")
    {
      action = "<cmd>cw<CR>";
      key = "<C-q>";
      mode = "n";
      options = {
        desc = "toggle quickfix window";
      };
    }
    {
      action = "<cmd>lw<CR>";
      key = "<C-l>";
      mode = "n";
      options = {
        desc = "toggle location window";
      };
    }
    {
      action = "<C-d>zz";
      key = "<C-d>";
      mode = "n";
      options = {
        desc = "move [d]own half-page and center";
      };
    }
    {
      action = "<C-u>zz";
      key = "<C-u>";
      mode = "n";
      options = {
        desc = "move [u]p half-page and center";
      };
    }
    {
      action = "<C-f>zz";
      key = "<C-f>";
      mode = "n";
      options = {
        desc = "move DOWN [f]ull-page and center";
      };
    }
    {
      action = "<C-b>zz";
      key = "<C-b>";
      mode = "n";
      options = {
        desc = "move UP full-page and center";
      };
    }
    {
      action = "\"_x";
      key = "x";
      mode = "n";
    }
    {
      action = "\"_X";
      key = "X";
      mode = "n";
    }
    {
      action = "\"_s";
      key = "s";
      mode = "n";
    }
    {
      action = "\"_c";
      key = "c";
      mode = "n";
    }
    {
      action = "\"+p";
      key = "<leader>p";
      mode = "n";
      options = {
        desc = "Paste from clipboard";
      };
    }
    {
      action = "v:count == 0 ? 'gj' : 'j'";
      key = "j";
      mode = "n";
      options = {
        expr = true;
      };
    }
    {
      action = "v:count == 0 ? 'gk' : 'k'";
      key = "k";
      mode = "n";
      options = {
        expr = true;
      };
    }
    {
      action = ":m '>+1<CR>gv=gv";
      key = "J";
      mode = "v";
      options = {
        silent = true;
      };
    }
    {
      action = ":m '<-2<CR>gv=gv";
      key = "K";
      mode = "v";
      options = {
        silent = true;
      };
    }
    {
      action = "\"+y";
      key = "<leader>y";
      mode = [
        "n"
        "v"
      ];
      options = {
        desc = "Yank to clipboard";
      };
    }
    {
      action = "\"+Y";
      key = "<leader>Y";
      mode = "n";
      options = {
        desc = "Yank lines to clipboard";
      };
    }
    {
      action = "y$";
      key = "Y";
      mode = "n";
      options = {
        desc = "[Y]ank to end of line";
        silent = true;
      };
    }
    {
      action = "<Nop>";
      key = "Q";
      mode = "n";
      options = {
        desc = "Disable Ex mode";
      };
    }
    {
      action = "<cmd>update<CR>";
      key = "<leader>s";
      mode = [
        "n"
        "v"
      ];
      options = {
        desc = "[S]ave";
        silent = true;
      };
    }
  ];
}
