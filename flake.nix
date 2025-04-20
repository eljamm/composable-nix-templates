{
  description = "Nix templates for the Lazy";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    inputs@{ nixpkgs, ... }:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = nixpkgs.lib.systems.flakeExposed;

      # get flake attributes from default.nix
      perSystem = { system, ... }: (import ./default.nix { inherit inputs system; }).flake;
    };
}
