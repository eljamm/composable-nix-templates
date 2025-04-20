{
  self ? import ./. { },
  inputs ? import (fetchTarball "https://github.com/fricklerhandwerk/flake-inputs/tarball/main") {
    root = ./.;
  },
  system ? builtins.currentSystem,
  pkgs ? import inputs.nixpkgs { inherit system; },
  lib ? import "${inputs.nixpkgs}/lib",
}:
self.flake.devShells.default
