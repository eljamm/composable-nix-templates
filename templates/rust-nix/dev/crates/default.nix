{
  lib,
  pkgs,
  inputs,
  ...
}:
let
  crates = lib.makeScope pkgs.newScope (
    self:
    let
      callCrate = self.newScope rec {
        craneLib = (inputs.crane.mkLib pkgs).overrideToolchain (p: p.rust-bin.stable.latest.default);

        # src -> { `pname`, `version` }
        crateInfo = src: craneLib.crateNameFromCargoToml { cargoToml = "${src}/Cargo.toml"; };
      };
    in
    with self;
    {
      default = callCrate ./hello.nix { };
    }
  );
in
crates
