{
  pkgs,
  lib,
  ...
}:
{
  plugins = {
    codecompanion = {
      enable = lib.nixvim.enableExceptInTests;
      settings = {
        adapters = {
          copilot = "copilot";
        };
        strategies = {
          chat = {
            adapter = "copilot";
          };
          inline = {
            adapter = "copilot";
          };
        };
        opts = {
          log_level = "INFO";
          send_code = true;
          use_default_actions = true;
          use_default_prompts = true;
        };
        prompt_library = {
          "Grammar Correction" = {
            description = "Correct text to standard English";
            opts = {
              index = 1;
              is_default = true;
              is_slash_cmd = true;
              short_name = "grammar";
            };
            prompts = [
              {
                content = "Correct the text to standard English, but keep any code blocks inside intact.";
                role = "user";
              }
            ];
            strategy = "inline";
          };
          "Keywords" = {
            description = "Extract main keywords from text";
            opts = {
              index = 2;
              is_default = true;
              is_slash_cmd = true;
              short_name = "keywords";
            };
            prompts = [
              {
                content = "Extract the main keywords from the following text";
                role = "user";
              }
            ];
            strategy = "inline";
          };
          "Code Readability" = {
            description = "Analyze code readability";
            opts = {
              index = 3;
              is_default = true;
              is_slash_cmd = true;
              short_name = "readability";
            };
            prompts = [
              {
                content = "You must identify any readability issues in the code snippet. Some readability issues to consider: Unclear naming, Unclear purpose, Redundant or obvious comments, Lack of comments, Long or complex one liners, Too much nesting, Long variable names, Inconsistent naming and code style, Code repetition. You may identify additional problems. The user submits a small section of code from a larger file. Only list lines with readability issues, in the format <line_num>|<issue and proposed solution>. If there's no issues with code respond with only: <OK>";
                role = "user";
              }
            ];
            strategy = "inline";
          };
          "Optimize Code" = {
            description = "Optimize code for performance";
            opts = {
              index = 4;
              is_default = true;
              is_slash_cmd = true;
              short_name = "optimize";
            };
            prompts = [
              {
                content = "Optimize the following code";
                role = "user";
              }
            ];
            strategy = "inline";
          };
          "Summarize" = {
            description = "Summarize text";
            opts = {
              index = 5;
              is_default = true;
              is_slash_cmd = true;
              short_name = "summarize";
            };
            prompts = [
              {
                content = "Summarize the following text";
                role = "user";
              }
            ];
            strategy = "inline";
          };
          "Translate" = {
            description = "Translate text to Spanish";
            opts = {
              index = 6;
              is_default = true;
              is_slash_cmd = true;
              short_name = "translate";
            };
            prompts = [
              {
                content = "Translate this into Spanish, but keep any code blocks inside intact";
                role = "user";
              }
            ];
            strategy = "inline";
          };
        };
      };
      luaConfig.post = ''
        require('which-key').add {
          { '<leader>a', group = 'CodeCompanion' },
          {
            mode = { 'n' },
            {
              '<leader>aa',
              '<cmd>CodeCompanionChat Toggle<cr>',
              desc = 'Toggle Chat',
            },
            {
              '<leader>at',
              '<cmd>CodeCompanion<cr>',
              desc = 'Ask (Inline)',
            },
            {
              '<leader>ac',
              '<cmd>CodeCompanionChat<cr>',
              desc = 'Chat',
            },
          },
          {
            mode = { 'v' },
            {
              '<leader>ae',
              '<cmd>CodeCompanion<cr>',
              desc = 'Edit Selection',
            },
          },
          {
            mode = { 'n', 'v' },
            {
              '<leader>ax',
              '<cmd>CodeCompanion /explain<cr>',
              desc = 'Explain Code',
            },
            {
              '<leader>au',
              '<cmd>CodeCompanion /tests<cr>',
              desc = 'Add Tests',
            },
            {
              '<leader>ag',
              '<cmd>CodeCompanion /fix<cr>',
              desc = 'Fix Bugs',
            },
            {
              '<leader>al',
              '<cmd>CodeCompanion /lsp<cr>',
              desc = 'LSP',
            },
            {
              '<leader>am',
              '<cmd>CodeCompanion /commit<cr>',
              desc = 'Commit Message',
            },
            {
              '<leader>aG',
              '<cmd>CodeCompanion /grammar<cr>',
              desc = 'Grammar Correction',
            },
            {
              '<leader>aK',
              '<cmd>CodeCompanion /keywords<cr>',
              desc = 'Keywords',
            },
            {
              '<leader>aR',
              '<cmd>CodeCompanion /readability<cr>',
              desc = 'Code Readability',
            },
            {
              '<leader>aO',
              '<cmd>CodeCompanion /optimize<cr>',
              desc = 'Optimize Code',
            },
            {
              '<leader>aM',
              '<cmd>CodeCompanion /summarize<cr>',
              desc = 'Summarize',
            },
            {
              '<leader>aN',
              '<cmd>CodeCompanion /translate<cr>',
              desc = 'Translate',
            },
          },
        }
      '';
    };
  };
}
