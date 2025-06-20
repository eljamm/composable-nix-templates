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
  inputs ? self.inputs,
  system ? builtins.currentSystem,
  pkgs ? import inputs.nixpkgs {
    config = { };
    overlays = [ ];
    inherit system;
  },
  lib ? import "${inputs.nixpkgs}/lib",
}:
let
  args = {
    inherit
      lib
      self
      pkgs
      system
      inputs
      ;
  };

  default = rec {
    packages = import ./dev/packages.nix args;

    shell = pkgs.mkShellNoCC {
      nativeBuildInputs = (lib.attrValues packages.scripts) ++ [
        packages.docs
        pkgs.ffizer
        pkgs.mdsh
      ];
    };

    flake.packages = lib.filterAttrs (n: v: lib.isDerivation v) packages.scripts;
    flake.devShells.default = shell;
  };
in
args // default // default.packages.scripts-bin
