{
  description = "Basic {{language}} flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-{{nixpkgs_version}}";
    flake-parts.url = "github:hercules-ci/flake-parts";

    # --- {{#if (eq language "rust") }}
    crane.url = "github:ipetkov/crane";

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # --- {{/if}}

    git-hooks-nix = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = nixpkgs.lib.systems.flakeExposed;

      # Import all files under ./nix/modules
      imports = with builtins; map (fn: ./nix/modules/${fn}) (attrNames (readDir ./nix/modules));
    };
}
