{
  self ? import ./nix/import-flake.nix { src = ./.; },
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
  scope = lib.makeScope pkgs.newScope (sc: {
    inherit
      lib
      pkgs
      self
      system
      inputs
      ;

    # Custom library. Contains helper functions, builders, ...
    devLib = sc.callPackage ./nix/lib.nix { };
    ## {{#unless (eq template_name "default")}}
    "!{{template_name}}!" = sc.callPackage "!./nix/{{template_name}}.nix!" { };
    ## {{/unless}}

    formatter = sc.callPackage ./nix/formatter.nix { };
    ## {{#if (eq template_name "default")}}
    #! devPkgs = { };
    ## {{else if (eq template_name "rust")}}
    #! devPkgs = sc."!{{template_name}}!".crates;
    ## {{else}}
    devPkgs = lib.filterAttrs (n: v: lib.isDerivation v) (sc.callPackage ./nix/packages.nix { });
    ## {{/if}}
    devShells.default = pkgs.mkShellNoCC {
      packages = [
        sc.formatter.package
      ];
    };

    overlays.default = final: prev: sc.devPkgs;

    flake.perSystem = {
      devShells = sc.devShells;
      formatter = sc.formatter.package;
      packages = sc.devPkgs;
      checks = lib.filterAttrs (_: v: !v.meta.broken or false) sc.flake.perSystem.packages;
      legacyPackages = {
        lib = sc.devLib;
        packages = sc.devPkgs;
      };
    };
    flake.systemAgnostic = {
      inherit (sc) overlays;
    };
  });
in
scope // scope.devPkgs
