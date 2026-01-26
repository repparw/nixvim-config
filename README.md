<h1 align="center">NixVim Configuration</h1>

## Config and Plugins

Descriptions of all the config files/plugins used in this configuration.

| Name | Description |
| --- | --- |
| avante | AI-powered coding assistant with Gemini and Claude integration |
| blink-cmp | Modern completion engine with intelligent suggestions |
| blink-copilot | GitHub Copilot integration for AI-powered code completions |
| colorizer | Highlights color codes in files |
| conform-nvim | Code formatting with support for multiple languages |
| default.nix | Core configuration |
| gitsigns | Git decorations showing changes in the buffer |
| keymaps.nix | Custom keybindings for improved workflow |
| lualine | Sleek and customizable status line |
| noice | Enhanced UI for cmdline and notifications |
| notify | Notification system for Neovim |
| nvim-surround | Powerful text surrounding operations (quotes, brackets, tags) |
| obsidian | Obsidian note-taking integration |
| telescope | Powerful fuzzy finder with multiple extensions (ui-select, frecency, fzf-native, zoxide) |
| treesitter | Enhanced syntax highlighting and code understanding |
| vimtex | Comprehensive LaTeX support with XeLaTeX compilation |
| web-devicons | Adds filetype icons |
| which-key | Interactive keybinding helper |

## Notable Features

- **AI-Powered Coding**: Avante plugin with Gemini 2.5 Pro and Claude Sonnet integration for code generation, editing, and analysis
- **Smart Completions**: Modern blink-cmp completion engine with GitHub Copilot integration
- **Full LSP Support**: Inlay hints and various language servers
- **Extensive Telescope Integration**: Fuzzy finding with ui-select, frecency, fzf-native, and zoxide extensions
- **Git Integration**: Real-time git decorations via gitsigns
- **Modern UI Elements**: Enhanced command line and notifications with noice and notify
- **LaTeX Support**: Comprehensive vimtex integration with XeLaTeX compilation
- **Obsidian Integration**: Seamless note-taking workflow
- **Multi-Language Formatting**: Automated code formatting with conform-nvim (Nix, Lua, TypeScript, JSON, CSS, HTML, Shell)

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
