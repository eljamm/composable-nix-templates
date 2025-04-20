{ inputs, ... }:
{
  imports = [
    inputs.git-hooks-nix.flakeModule
    inputs.treefmt-nix.flakeModule
  ];

  perSystem =
    { pkgs, lib, ... }:
    {
      treefmt.projectRootFile = "flake.nix";
      treefmt.programs.nixfmt.enable = true;

      # --- {{#if (eq language "rust") }}
      treefmt.programs.rustfmt.enable = true;
      treefmt.programs.taplo.enable = true; # TOML
      # --- {{/if}}
      # --- {{#if (eq language "go") }}
      treefmt.settings.formatter = {
        "gofumpt" = {
          command = "${lib.getExe pkgs.gofumpt}";
          options = [ "-w" ];
          includes = [ "*.go" ];
          excludes = [ "vendor/*" ];
        };
        "goimports-reviser" = {
          command = "${lib.getExe pkgs.goimports-reviser}";
          options = [
            "-format"
            "-apply-to-generated-files"
          ];
          includes = [ "*.go" ];
          excludes = [ "vendor/*" ];
        };
      };
      # --- {{/if}}

      pre-commit.check.enable = true;
      pre-commit.settings.hooks.treefmt.enable = true;
      pre-commit.settings.hooks.treefmt.settings.no-cache = false;
    };
}
