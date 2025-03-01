{
  perSystem =
    {
      config,
      self',
      pkgs,
      ...
    }:
    {
      devShells.default = pkgs.mkShell {
        inputsFrom = [
          self'.devShells.rust
          self'.devShells.aliases
          config.pre-commit.devShell
          config.treefmt.build.devShell
        ];

        packages = with pkgs; [
          cargo-auditable
          cargo-tarpaulin # code coverage
          cargo-udeps # unused deps
          bacon
        ];
      };
    };
}
