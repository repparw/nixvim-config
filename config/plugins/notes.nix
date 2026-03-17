{
  pkgs,
  lib,
  ...
}:
{
  plugins.obsidian = {
    enable = lib.nixvim.enableExceptInTests;
    settings = {
      "legacy_commands" = false;
      workspaces = [
        {
          name = "obsidian";
          path = "~/Documents/obsidian";
        }
      ];
      checkbox.order = {
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
}
