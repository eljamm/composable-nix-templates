{ inputs, ... }:
{
  imports = [
    inputs.git-hooks-nix.flakeModule
    inputs.treefmt-nix.flakeModule
  ];

  perSystem =
    { pkgs, lib, ... }:
    {
      treefmt.config = {
        projectRootFile = "flake.nix";
        programs = {
          nixfmt.enable = true;
          rustfmt.enable = true;
          taplo.enable = true; # TOML
        };
      };

      pre-commit.check.enable = true;
      pre-commit.settings.hooks.treefmt.enable = true;
    };
}
