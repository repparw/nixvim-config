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
    nodePackages.prettier
    beautysh
    nixfmt
    ripgrep
  ];
}
