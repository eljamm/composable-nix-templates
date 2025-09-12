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

        # use mold linker
        stdenv = p: p.stdenvAdapters.useMoldLinker self.clangStdenv;
      };
    in
    with self;
    {
      default = callCrate ./hello.nix { };
    }
  );
in
crates
