{
  flake-inputs ? import (fetchTarball {
    url = "https://github.com/fricklerhandwerk/flake-inputs/tarball/4.1.0";
    sha256 = "1j57avx2mqjnhrsgq3xl7ih8v7bdhz1kj3min6364f486ys048bm";
  }),
  self ? flake-inputs.import-flake { src = ./.; },
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
  default = lib.makeScope pkgs.newScope (def: {
    inherit
      lib
      pkgs
      self
      system
      inputs
      flake
      ;

    # Custom library. Contains helper functions, builders, ...
    devLib = def.callPackage ./nix/lib.nix { };
    ## {{#unless (eq template_name "default")}}
    "!{{template_name}}!" = def.callPackage "!./nix/{{template_name}}.nix!" { };
    ## {{/unless}}

    formatter = def.callPackage ./nix/formatter.nix { };
    ## {{#if (eq template_name "default")}}
    #! devPkgs = { };
    ## {{else if (eq template_name "rust")}}
    #! devPkgs = def."!{{template_name}}!".crates;
    ## {{else}}
    devPkgs = def.callPackage ./nix/packages.nix { };
    ## {{/if}}

    devShells.default = pkgs.mkShellNoCC {
      packages = [
        def.formatter.package
      ];
    };

    overlays.default = final: prev: def.devPkgs;
  });

  flake = default.callPackage ./nix/flake { };

  # return final scope, with computed and non-recursive attributes
  finalScope = default.packages default;
in
finalScope
