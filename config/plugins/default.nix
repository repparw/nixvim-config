{
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./completions.nix
    ./editing.nix
    ./llm.nix
    ./notes.nix
    ./treesitter.nix
    ./ui.nix
    ./vimtex.nix
  ];

  extraPackages = with pkgs; [
    stylua
    biome
    prettierd
    beautysh
    nixfmt
    ripgrep
  ];
}
