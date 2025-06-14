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
    ## {{#if (eq template_name "rust")}}
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
    inherit (default)
      packages
      ;
    devShells = default.shells;
  };

  formatter = import ./dev/formatter.nix args;

  default = rec {
    "!{{template_name}}!" = import "!./dev/{{template_name}}.nix!" args;

    ## {{#if (eq template_name "rust")}}
    #! packages = "!{{template_name}}!".crates;
    ## {{else}}
    packages = { };
    ## {{/if}}

    shells = {
      default = pkgs.mkShellNoCC {
        packages = [
          formatter
        ];
      };
    } // "!{{template_name}}!".shells or { };

    flake.packages = lib.filterAttrs (n: v: lib.isDerivation v) packages;
    flake.devShells = shells;
    flake.formatter = formatter;
  };
in
default // args
