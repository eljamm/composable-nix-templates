let
  flake-inputs = import (
    fetchTarball "https://github.com/fricklerhandwerk/flake-inputs/tarball/4.1.0"
  );
  inherit (flake-inputs)
    import-flake
    ;
in
{
  self ? import-flake {
    src = ./.;
  },
  sources ? self.inputs,
  system ? builtins.currentSystem,
  pkgs ? import sources.nixpkgs {
    config = { };
    overlays = [ ];
    inherit system;
  },
  lib ? import "${sources.nixpkgs}/lib",
}:
let
  args = {
    inherit
      lib
      pkgs
      system
      sources
      ;
  };

  formatter = import ./dev/formatter.nix args;

  default = rec {
    packages = { };
    shell = pkgs.mkShellNoCC {
      packages = [
        formatter
      ];
    };

    flake.packages = lib.filterAttrs (n: v: lib.isDerivation v) packages;
    flake.devShells.default = shell;
    flake.formatter = formatter;
  };
in
default // args
