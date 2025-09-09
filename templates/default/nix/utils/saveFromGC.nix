{
  pkgs,
  inputs,
  packages,
  devShells,
  ...
}:
(import "${inputs.cache-nix-action}/saveFromGC.nix" {
  inherit
    pkgs
    inputs
    ;
  derivations = [
    packages.default
    devShells.default
  ];
}).saveFromGC
