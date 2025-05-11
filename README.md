<h1 align="center">NixVim Configuration</h1>

## Config and Plugins

Descriptions of all the config files/plugins used in this configuration.

| Name | Description |
| --- | --- |
| copilot-lua/copilot-cmp | GitHub Copilot integration with completion support |
| cmp | Advanced completion with multiple sources including LSP, buffer, path |
| colorizer | Highlights color codes in files |
| conform-nvim | Code formatting with support for multiple languages |
| default.nix | Core configuration |
| gitsigns | Git decorations showing changes in the buffer |
| keymaps.nix | Custom keybindings for improved workflow |
| lsp.nix | Language Server Protocol support with multiple language servers |
| lualine | Sleek and customizable status line |
| noice | Enhanced UI for cmdline and notifications |
| notify | Notification system for Neovim |
| obsidian | Obsidian note-taking integration |
| telescope | Powerful fuzzy finder with multiple extensions |
| todo-comments | Highlight and search TODO comments |
| treesitter | Enhanced syntax highlighting and code understanding |
| vimtex | Comprehensive LaTeX support |
| web-devicons | Adds filetype icons |
| which-key | Interactive keybinding helper |

## Notable Features

- Full LSP support with inlay hints and various language servers
- Extensive telescope integration with fuzzy finding
- Git integration via gitsigns
- Advanced completion system with Copilot integration
- Modern UI elements with noice and notify
- LaTeX support through vimtex
- Obsidian note-taking integration

## How to run

> ```bash
> nix run github:repparw/nixvim-config
> ```

## Installing

Add this repository as a flake input in your NixOS configuration:

```nix
inputs.nixvim-config.url = "github:repparw/nixvim-config"
```

Then include it in your system configuration:

```nix
environment.systemPackages = with pkgs; [
  inputs.nixvim-config.packages.${system}.default
];
```

## Contributing

If you find any issues or have suggestions for improvements, please feel free to open an issue or submit a PR.

## Acknowledgements
* [NixVim](https://github.com/nix-community/nixvim)
