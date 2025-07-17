{
  helpers,
  pkgs,
  ...
}:
{
  plugins = {
    which-key.enable = true;
    gitsigns.enable = true;
    colorizer.enable = true;
    web-devicons.enable = true;

    nvim-surround.enable = true;

    copilot-lua = {
      enable = true;
      settings.suggestion.enabled = false;
    };
    copilot-cmp.enable = true;

    avante = {
      enable = helpers.enableExceptInTests;
      settings = {
        provider = "copilot";
        behaviour = {
          auto_suggestions = false;
          enable_cursor_planning_mode = true;
        };
        providers.copilot = {
          model = "claude-3.5-sonnet";
        };
      };
      luaConfig.post = ''
        	  -- prefill edit window with common scenarios to avoid repeating query and submit immediately
        local prefill_edit_window = function(request)
          require('avante.api').edit()
          local code_bufnr = vim.api.nvim_get_current_buf()
          local code_winid = vim.api.nvim_get_current_win()
          if code_bufnr == nil or code_winid == nil then
            return
          end
          vim.api.nvim_buf_set_lines(code_bufnr, 0, -1, false, { request })
          -- Optionally set the cursor position to the end of the input
          vim.api.nvim_win_set_cursor(code_winid, { 1, #request + 1 })
          -- Simulate Ctrl+S keypress to submit
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-s>', true, true, true), 'v', true)
        end

        -- NOTE most templates are inspired from ChatGPT.nvim -> chatgpt-actions.json
        local avante_grammar_correction = 'Correct the text to standard English, but keep any code blocks inside intact.'
        local avante_keywords = 'Extract the main keywords from the following text'
        local avante_code_readability_analysis = [[
          You must identify any readability issues in the code snippet.
          Some readability issues to consider:
          - Unclear naming
          - Unclear purpose
          - Redundant or obvious comments
          - Lack of comments
          - Long or complex one liners
          - Too much nesting
          - Long variable names
          - Inconsistent naming and code style.
          - Code repetition
          You may identify additional problems. The user submits a small section of code from a larger file.
          Only list lines with readability issues, in the format <line_num>|<issue and proposed solution>
          If there's no issues with code respond with only: <OK>
        ]]
        local avante_optimize_code = 'Optimize the following code'
        local avante_summarize = 'Summarize the following text'
        local avante_translate = 'Translate this into Spanish, but keep any code blocks inside intact'
        local avante_explain_code = 'Explain the following code'
        local avante_complete_code = 'Complete the following codes written in ' .. vim.bo.filetype
        local avante_add_docstring = 'Add docstring to the following codes'
        local avante_fix_bugs = 'Fix the bugs inside the following codes if any'
        local avante_add_tests = 'Implement tests for the following code'

        require('which-key').add {
          { '<leader>a', group = 'Avante' },
          {
            mode = { 'n' },
            {
              '<leader>ar',
              function()
                require('avante.api').refresh()
              end,
              desc = 'Refresh',
            },
            {
              '<leader>af',
              function()
                require('avante.api').focus()
              end,
              desc = 'Focus',
            },
            {
              '<leader>at',
              function()
                require('avante.api').toggle()
              end,
              desc = 'Toggle',
            },
            {
              '<leader>ah',
              function()
                require('avante.api').toggle.hint()
              end,
              desc = 'Toggle hint',
            },
            {
              '<leader>as',
              function()
                require('avante.api').toggle.suggestion()
              end,
              desc = 'Toggle suggestion',
            },
            {
              '<leader>aR',
              function()
                require('avante.api').toggle.repomap()
              end,
              desc = 'Display repo map',
            },
            {
              '<leader>a?',
              function()
                require('avante.api').select_model()
              end,
              desc = 'Select model',
            },
          },
        }

        require('which-key').add {
          { '<leader>a', group = 'Avante' },
          {
            mode = { 'n', 'v' },
            {
              '<leader>aa',
              function()
                require('avante.api').ask()
              end,
              desc = 'Ask',
            },
            {
              '<leader>ag',
              function()
                require('avante.api').ask { question = avante_grammar_correction }
              end,
              desc = 'Grammar Correction(ask)',
            },
            {
              '<leader>ak',
              function()
                require('avante.api').ask { question = avante_keywords }
              end,
              desc = 'Keywords(ask)',
            },
            {
              '<leader>al',
              function()
                require('avante.api').ask { question = avante_code_readability_analysis }
              end,
              desc = 'Code Readability Analysis(ask)',
            },
            {
              '<leader>ao',
              function()
                require('avante.api').ask { question = avante_optimize_code }
              end,
              desc = 'Optimize Code(ask)',
            },
            {
              '<leader>am',
              function()
                require('avante.api').ask { question = avante_summarize }
              end,
              desc = 'Summarize text(ask)',
            },
            {
              '<leader>an',
              function()
                require('avante.api').ask { question = avante_translate }
              end,
              desc = 'Translate text(ask)',
            },
            {
              '<leader>ax',
              function()
                require('avante.api').ask { question = avante_explain_code }
              end,
              desc = 'Explain Code(ask)',
            },
            {
              '<leader>ac',
              function()
                require('avante.api').ask { question = avante_complete_code }
              end,
              desc = 'Complete Code(ask)',
            },
            {
              '<leader>ad',
              function()
                require('avante.api').ask { question = avante_add_docstring }
              end,
              desc = 'Docstring(ask)',
            },
            {
              '<leader>ab',
              function()
                require('avante.api').ask { question = avante_fix_bugs }
              end,
              desc = 'Fix Bugs(ask)',
            },
            {
              '<leader>au',
              function()
                require('avante.api').ask { question = avante_add_tests }
              end,
              desc = 'Add Tests(ask)',
            },
          },
        }

        require('which-key').add {
          { '<leader>a', group = 'Avante' },
          {
            mode = { 'v' },
            {
              '<leader>ae',
              function()
                require('avante.api').edit()
              end,
              desc = 'Edit',
            },
            {
              '<leader>aG',
              function()
                prefill_edit_window(avante_grammar_correction)
              end,
              desc = 'Grammar Correction',
            },
            {
              '<leader>aK',
              function()
                prefill_edit_window(avante_keywords)
              end,
              desc = 'Keywords',
            },
            {
              '<leader>aO',
              function()
                prefill_edit_window(avante_optimize_code)
              end,
              desc = 'Optimize Code(edit)',
            },
            {
              '<leader>aC',
              function()
                prefill_edit_window(avante_complete_code)
              end,
              desc = 'Complete Code(edit)',
            },
            {
              '<leader>aD',
              function()
                prefill_edit_window(avante_add_docstring)
              end,
              desc = 'Docstring(edit)',
            },
            {
              '<leader>aB',
              function()
                prefill_edit_window(avante_fix_bugs)
              end,
              desc = 'Fix Bugs(edit)',
            },
            {
              '<leader>aU',
              function()
                prefill_edit_window(avante_add_tests)
              end,
              desc = 'Add Tests(edit)',
            },
          },
        }
      '';
    };

    notify = {
      enable = true;
      settings = {
        background_colour = "#000000";
        timeout = 3000;
        render = "compact";
      };
    };

    conform-nvim = {
      enable = true;
      settings = {
        notify_on_error = false;
        format_on_save = ''
          function(bufnr)
              -- Disable format_on_save lsp_fallback for languages that don't
              -- have a well standardized coding style. You can add additional
              -- languages here or re-enable it for the disabled ones.
              local disable_filetypes = { c = true, cpp = true }
              return {
                timeout_ms = 500,
                lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
              }
            end'';
        formatters_by_ft = {
          css = [ "prettier" ];
          html = [ "prettier" ];
          json = [ "biome" ];
          lua = [ "stylua" ];
          nix = [ "nixfmt" ];
          sh = [ "beautysh" ];
          typescript = [
            "biome"
            "prettier"
          ];
          #rb = [ "rufo" ];
        };
      };
    };

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
    obsidian = {
      enable = helpers.enableExceptInTests;
      settings = {
        workspaces = [
          {
            name = "obsidian";
            path = "~/Documents/obsidian";
          }
        ];
        ui.checkboxes = {
          " " = {
            char = "󰄱";
            hl_group = "ObsidianTodo";
          };
          x = {
            char = "";
            hl_group = "ObsidianDone";
          };
        };
      };
    };
    treesitter = {
      enable = true;
      settings = {
        highlight = {
          enable = true;
          disable = "function(lang, buf)
      local max_filesize = 100 * 1024 -- 100 KB
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      if ok and stats and stats.size > max_filesize then
        return true
      end
    end
";
        };
      };
    };
    lualine = {
      enable = true;
      settings = {
        options.globalStatus = true;
        extensions = [
          "fzf"
          "toggleterm"
          "quickfix"
        ];
        sections.lualine_x = [
          {
            __unkeyed-1.__raw = "require('noice').api.statusline.mode.get_hl";
            cond.__raw = "require('noice').api.statusline.mode.has";
            color = {
              fg = "#ff9e64";
            };
          }
        ];
      };
    };

    lspkind = {
      enable = true;
      symbolMap = {
        Copilot = " ";
      };
      extraOptions = {
        maxwidth = 50;
        ellipsis_char = "...";
      };
    };
    cmp = {
      enable = true;
      settings = {
        snippet.expand = ''
          function(args)
              vim.snippet.expand(args.body)
            end
        '';
        mapping = {
          "<C-n>" = "cmp.mapping.select_next_item()";
          "<C-p>" = "cmp.mapping.select_prev_item()";
          "<C-b>" = "cmp.mapping.scroll_docs(-4)";
          "<C-f>" = "cmp.mapping.scroll_docs(4)";
          "<C-y>" = "cmp.mapping.confirm { select = true }";
          "<C-Space>" = "cmp.mapping.complete {}";
          "<C-l>" =
            "cmp.mapping(function()
      if luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      end
    end, { 'i', 's' })";
          "<C-h>" =
            "cmp.mapping(function()
      if luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      end
    end, { 'i', 's' })";
        };
        sources = [
          {
            name = "nvim_lsp";
            group_index = 2;
          }
          {
            name = "emoji";
            group_index = 2;
          }
          {
            name = "copilot";
            group_index = 2;
          }
          {
            name = "luasnip";
            group_index = 2;
          }
          {
            name = "path";
            group_index = 2;
          }
          {
            name = "buffer";
            group_index = 3;
          }
          {
            name = "latex_symbols";
            group_index = 3;
          }
        ];
        window = {
          completion = {
            border = [
              "╭"
              "─"
              "╮"
              "│"
              "╯"
              "─"
              "╰"
              "│"
            ];
            winhighlight = "Normal:CmpNormal,FloatBorder:CmpBorder,CursorLine:CmpSelection,Search:None";
          };
          documentation = {
            border = [
              "╭"
              "─"
              "╮"
              "│"
              "╯"
              "─"
              "╰"
              "│"
            ];
            winhighlight = "Normal:CmpDocNormal,FloatBorder:CmpDocBorder";
          };
        };
        experimental = {
          ghost_text = true;
        };
      };
    };
    cmp-nvim-lsp.enable = true;
    cmp_luasnip.enable = true;
    cmp-buffer.enable = true;
    cmp-path.enable = true;
    vimtex = {
      enable = false;
      texlivePackage = pkgs.texliveFull;
      settings = {
        compiler_method = "latexmk";
        compiler_engine = "xelatex";
        bibtex_options = "--min-crossrefs=999";
        compiler_latexmk = {
          options = [
            "-synctex=1"
            "-interaction=nonstopmode"
            "-file-line-error"
          ];
        };
      };
    };
    telescope = {
      enable = true;
      keymaps = {
        "<leader>fh" = {
          action = "help_tags";
          options = {
            desc = "[F]ind [H]elp";
          };
        };
        "<leader>fk" = {
          action = "keymaps";
          options = {
            desc = "[F]ind [K]eymaps";
          };
        };
        "<leader>ff" = {
          action = "find_files";
          options = {
            desc = "[F]ind [F]iles";
          };
        };
        "<leader>fs" = {
          action = "builtin";
          options = {
            desc = "[F]ind [S]elect Telescope";
          };
        };
        "<leader>fw" = {
          action = "grep_string";
          options = {
            desc = "[F]ind current [W]ord";
          };
        };
        "<leader>fg" = {
          action = "live_grep";
          options = {
            desc = "[F]ind by [G]rep";
          };
        };
        "<leader>fD" = {
          action = "diagnostics";
          options = {
            desc = "[F]ind [D]iagnostics";
          };
        };
        "<leader>fd" = {
          action = "zoxide list";
          options = {
            desc = "[F]ind by [D]irectory";
          };
        };
        "<leader>fr" = {
          action = "resume";
          options = {
            desc = "[F]ind [R]esume";
          };
        };
        "<leader>f." = {
          action = "oldfiles";
          options = {
            desc = "[F]ind Recent Files (\".\" for repeat)";
          };
        };
        "<leader><leader>" = {
          action = "buffers";
          options = {
            desc = "[F]ind [B]uffers";
          };
        };
      };

      extensions = {
        ui-select.enable = true;
        frecency.enable = true;
        fzf-native.enable = true;
        zoxide.enable = true;
      };

      settings = {
        defaults = {
          mappings = {
            i = {
              "<C-q>" = {
                __raw = "require('telescope.actions').send_to_qflist";
              };
              "<C-l>" = {
                __raw = "require('telescope.actions').send_to_loclist";
              };
            };
            n = {
              q = {
                __raw = "require('telescope.actions').close";
              };
            };
          };

          preview = {
            treesitter = true;
          };

          color_devicons = true;
          set_env = {
            COLORTERM = "truecolor";
          };
          prompt_prefix = "   ";
          selection_caret = "  ";
          entry_prefix = "  ";
          initial_mode = "insert";

          extensions = {
            "ui-select" = {
              __raw = "require('telescope.themes').get_dropdown()";
            };
          };
        };
        pickers = {
          find_files = {
            hidden = true;
            follow = true;
          };
        };
      };
    };
  };
  extraPackages = with pkgs; [
    stylua
    biome
    nodePackages.prettier
    beautysh
    nixfmt-rfc-style

    ripgrep
  ];
}
