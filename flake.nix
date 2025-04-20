{
  description = "Nix templates for the Lazy";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { flake-utils, ... }@inputs:
    flake-utils.lib.eachDefaultSystem (
      system:
      # get flake attributes from default.nix
      (import ./default.nix { inherit inputs system; }).flake
    );
}
