{
  perSystem =
    {
      config,
      self',
      pkgs,
      ...
    }:
    {
      devShells = {
        default = pkgs.mkShell {
          inputsFrom = [
            self'.devShells."{{language}}"
            self'.devShells."aliases-{{language}}"
            self'.devShells.aliases
            config.pre-commit.devShell
            config.treefmt.build.devShell
          ];
        };
        # --- {{#if (eq language "rust") }}
        rust = pkgs.mkShell {
          packages = with pkgs; [
            self'.legacyPackages.rust.toolchains."{{toolchain}}"

            cargo-auditable
            cargo-tarpaulin # code coverage
            cargo-udeps # unused deps
            bacon
          ];
        };
        # --- {{/if}}
        # --- {{#if (eq language "go") }}
        go = pkgs.mkShell {
          packages = with pkgs; [
            go

            # Formatting
            gofumpt
            goimports-reviser
            golines

            # LSP
            delve # debugger
            gopls

            # Tools
            go-tools
            gotestsum
            gotools
            gotestdox
          ];

          # Required for Delve debugger
          # https://github.com/go-delve/delve/issues/3085
          hardeningDisable = [ "fortify" ];
        };
        # --- {{/if}}
      };
    };
}
