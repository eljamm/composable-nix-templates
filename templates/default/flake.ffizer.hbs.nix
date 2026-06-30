{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    ## {{#if (eq template_name "rust") }}
    crane.url = "github:ipetkov/crane";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs";
    rust-overlay.url = "github:oxalica/rust-overlay";
    ## {{else if (eq template_name "zig") }}
    zig-overlay.url = "github:mitchellh/zig-overlay";
    zig-overlay.flake = false;
    ## {{/if}}

    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";
    git-hooks.url = "github:fricklerhandwerk/git-hooks";
    git-hooks.flake = false;
  };

  # import flake attributes from ./flake/default.nix
  outputs =
    { self, ... }@inputs:
    let
      inherit (inputs.flake-utils.lib)
        eachSystem
        eachSystemPassThrough
        ;

      systems = [
        "aarch64-linux"
        "x86_64-linux"
      ];

      getDefault = system: (import ./. { inherit self inputs system; });
      importFlake = arg: system: (getDefault system).flake.${arg} or { };

      # independant of system (e.g. nixosModules)
      systemAgnosticFlake = eachSystemPassThrough systems (importFlake "systemAgnostic");

      # depends on system (e.g. packages.x86_64-linux)
      perSystemFlake = eachSystem systems (importFlake "perSystem");
    in
    systemAgnosticFlake // perSystemFlake;
}
