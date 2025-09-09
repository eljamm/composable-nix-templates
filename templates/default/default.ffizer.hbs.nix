{
  self ? import ./nix/utils/import-flake.nix {
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
      formatter
      packages
      "!{{template_name}}!"
      ;
    devLib = default.legacyPackages.lib;
    devShells = default.shells;
  };

  default = rec {
    formatter = import ./nix/formatter.nix args;
    "!{{template_name}}!" = import "!./dev/{{template_name}}.nix!" args;

    legacyPackages.lib = pkgs.callPackage ./nix/lib.nix { };
    ## {{#if (eq template_name "rust")}}
    #! packages = "!{{template_name}}!".crates;
    ## {{else}}
    packages = { };
    ## {{/if}}
    shells = "!{{template_name}}!".shells or { };

    inherit flake;
  };

  flake = {
    inherit (default)
      formatter
      legacyPackages
      ;
    devShells = default.shells;
    packages = lib.filterAttrs (n: v: lib.isDerivation v) default.packages;
  };
in
default // args
