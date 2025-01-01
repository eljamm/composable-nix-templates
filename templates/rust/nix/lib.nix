{
  lib,
  craneLib,
  callPackage,
  writeShellApplication,
  ...
}:
rec {
  inherit craneLib;

  callCrate = file: attrs: callPackage file { inherit craneLib crateInfo; } // attrs;

  # src -> { `pname`, `version` }
  crateInfo = src: craneLib.crateNameFromCargoToml { cargoToml = "${src}/Cargo.toml"; };

  attrsToApp =
    attrs:
    (writeShellApplication {
      name = attrs.name;
      text = if (lib.isAttrs attrs.value) then attrs.value.text else attrs.value + " \"$@\"";
      runtimeInputs = if (lib.isAttrs attrs.value) then attrs.value.runtimeInputs or [ ] else [ ];
    });
  mkAliases = aliases: map attrsToApp (lib.attrsToList aliases);
}
