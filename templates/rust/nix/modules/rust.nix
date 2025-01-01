{ inputs, ... }:
{
  perSystem =
    { system, pkgs, ... }:
    {
      # Add rust-overlay to `pkgs`
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = [ inputs.rust-overlay.overlays.default ];
      };

      devShells.rust = pkgs.mkShell {
        packages = [
          (pkgs.rust-bin.stable.latest.default.override {
            extensions = [
              "cargo"
              "clippy"
              "rust-src"
              "rustc"
              "rustfmt"
              "rust-analyzer"
            ];
          })
        ];
      };
    };

  imports = [ ../crates ];
}
