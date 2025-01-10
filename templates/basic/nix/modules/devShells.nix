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
          self'.devShells.aliases
          config.pre-commit.devShell
          config.treefmt.build.devShell
        ];

        packages = with pkgs; [
        ];
      };
    };
}
