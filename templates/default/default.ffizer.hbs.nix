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
    ## {{#if (eq template_name "rust-nix")}}
    #! overlays = [ inputs.rust-overlay.overlays.default ];
    ## {{else}}
    #! overlays = [ ];
    ## {{/if}}
    inherit system;
  },
  lib ? import "${inputs.nixpkgs}/lib",
}:
let
  args = {
    inherit
      lib
      pkgs
      self
      system
      inputs
      ;
  };

  formatter = import ./dev/formatter.nix args;

  default = rec {
    "!{{template_name}}!" = import "!./dev/{{template_name}}.nix!" args;

    packages = { };
    shell = pkgs.mkShellNoCC {
      packages = [
        formatter
      ] ++ "!{{template_name}}!".packages or [ ];
    };

    flake.packages = lib.filterAttrs (n: v: lib.isDerivation v) packages;
    flake.devShells.default = shell;
    flake.formatter = formatter;
  };
in
default // args
