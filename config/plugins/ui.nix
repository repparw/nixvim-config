{
  pkgs,
  lib,
  ...
}:
{
  plugins = {
    which-key.enable = true;
    gitsigns.enable = true;
    colorizer.enable = true;
    web-devicons.enable = true;

    noice = {
      enable = true;
      settings = {
        cmdline.view = "cmdline_popup";
        presets = {
          bottom_search = true;
          command_palette = true;
          long_message_to_split = true;
          inc_rename = false;
          lsp_doc_border = false;
        };
        views.cmdline_popup = {
          view = "popupmenu";
          position = {
            row = "40%";
            col = "50%";
          };
          zindex = 200;
          size.width = 120;
        };
      };
    };

    snacks = {
      enable = true;
      settings = {
        picker = {
          ui_select = true;
          matcher = {
            frecency = true;
            cwd_bonus = true;
          };
          keys = {
            j = "down";
            k = "up";
            h = "left";
            l = "right";
            g = "top";
            G = "bottom";
          };
          win = {
            input = {
              keys = {
                "<C-c>" = false;
                "<Esc>" = lib.nixvim.mkRaw "function(self) self:close() end";
              };
            };
            list = {
              wo = {
                conceallevel = 2;
                concealcursor = "nvc";
              };
            };
          };
          icons = {
            files = {
              enabled = true;
              parent_dir = " ";
              child_dir = " ";
            };
          };
          formatters = {
            file = {
              filename_first = true;
              truncate = 80;
            };
          };
          layout = {
            preset = "telescope";
            cycle = true;
          };
          sources = {
            files = {
              hidden = true;
              follow = true;
            };
            git_files = {
              hidden = true;
            };
          };
        };
        styles = {
          input = {
            backdrop = false;
            position = "float";
            border = "rounded";
            title_pos = "left";
          };
        };
      };
    };

    lualine = {
      enable = true;
      settings = {
        options.globalStatus = true;
        extensions = [ "fzf" "toggleterm" "quickfix" ];
        sections.lualine_x = [
          {
            __unkeyed-1 = lib.nixvim.mkRaw "require('noice').api.statusline.mode.get_hl";
            cond = lib.nixvim.mkRaw "require('noice').api.statusline.mode.has";
            color = { fg = "#ff9e64"; };
          }
        ];
      };
    };
  };
}
