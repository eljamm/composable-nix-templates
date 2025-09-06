{
  devShells,
  pkgs,
  ...
}@args:
{
  shells.dev = pkgs.mkShellNoCC {
    packages =
      with pkgs;
      [
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
      ]
      ++ devShells.default.nativeBuildInputs;

    # Required for Delve debugger
    # https://github.com/go-delve/delve/issues/3085
    hardeningDisable = [ "fortify" ];
  };
}
