{
  config,
  ...
}:
{
  plugins.treesitter = {
    enable = true;
    highlight.enable = true;

    grammarPackages = with config.plugins.treesitter.package.builtGrammars; [
      bash
      json
      lua
      make
      markdown
      nix
      regex
      toml
      vim
      vimdoc
      xml
      yaml
    ];
  };
}
