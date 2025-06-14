{
  lib,
  pkgs,
  ...
}:
let
  crates = lib.makeScope pkgs.newScope (
    self: with self; {
      default = callPackage ./hello.nix { };
    }
  );
in
crates
