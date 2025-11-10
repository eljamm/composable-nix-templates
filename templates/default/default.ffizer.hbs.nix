{
  self ? import ./nix/utils/import-flake.nix { src = ./.; },
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
  scope = lib.makeScope pkgs.newScope (
    self': with self'; {
      inherit
        lib
        pkgs
        self
        system
        inputs
        ;

      # Custom library. Contains helper functions, builders, ...
      devLib = callPackage ./nix/utils.nix { };
      ## {{#unless (eq template_name "default")}}
      "!{{template_name}}!" = import "!./nix/{{template_name}}.nix!" args;
      ## {{/unless}}

      format = callPackage ./nix/formatter.nix { };
      ## {{#if (eq template_name "rust")}}
      #! devPkgs = "!{{template_name}}!".crates;
      ## {{else}}
      devPkgs = lib.filterAttrs (n: v: lib.isDerivation v) (callPackage ./nix/packages.nix { });
      ## {{/if}}
      devShells.default = pkgs.mkShellNoCC {
        packages = [
          format.formatter
        ];
      };

      overlays.default = final: prev: devPkgs;

      flake.system-agnostic = {
        inherit overlays;
      };
      flake.perSystem = {
        devShells = devShells;
        formatter = format.formatter;
        packages = devPkgs;
        checks = lib.filterAttrs (_: v: !v.meta.broken or false) flake.perSystem.packages;
        legacyPackages = {
          lib = devLib;
          packages = devPkgs;
        };
      };
    }
  );
in
scope // scope.devPkgs
