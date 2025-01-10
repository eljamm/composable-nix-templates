{ inputs, ... }:
{
  imports = [
    inputs.git-hooks-nix.flakeModule
    inputs.treefmt-nix.flakeModule
  ];

  perSystem = {
    treefmt.config = {
      projectRootFile = "flake.nix";
      programs = {
        nixfmt.enable = true;
      };
    };

    pre-commit.check.enable = true;
    pre-commit.settings.hooks.treefmt.enable = true;
  };
}
