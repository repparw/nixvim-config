{
  description = "A nixvim configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixvim.url = "github:nix-community/nixvim";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = {
    nixvim,
    flake-parts,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      perSystem = {system, ...}: let
        nixvimLib = nixvim.lib.${system};
        nixvim' = nixvim.legacyPackages.${system};
        baseModule = import ./config;
        nixvimModule = {
          inherit system;
          module = baseModule;
          extraSpecialArgs = {
            # inherit (inputs) foo;
          };
        };
        # Create a test module that disables problematic plugins
        testModule = {
          inherit system;
          module = {...}: {
            imports = [baseModule];
            config.plugins = {
              obsidian.enable = false;
              avante.enable = false;
            };
          };
          extraSpecialArgs = {
            # inherit (inputs) foo;
          };
        };
        nvim = nixvim'.makeNixvimWithModule nixvimModule;
      in {
        checks = {
          # Use the testModule for checks instead of the main module
          default = nixvimLib.check.mkTestDerivationFromNixvimModule testModule;
        };

        packages = {
          # Keep the default package using the original configuration
          default = nvim;
        };
      };
    };
}
