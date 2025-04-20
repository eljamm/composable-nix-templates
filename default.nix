{
  inputs ? import (fetchTarball "https://github.com/fricklerhandwerk/flake-inputs/tarball/main") {
    root = ./.;
  },
  system ? builtins.currentSystem,
  pkgs ? import inputs.nixpkgs { inherit system; },
  lib ? import "${inputs.nixpkgs}/lib",
}:
let
  self = import ./. { inherit inputs system; };

  inherit (lib)
    filterAttrs
    getExe
    mapAttrs'
    nameValuePair
    ;

  getTemplates = dir: filterAttrs (_: type: type == "directory") (builtins.readDir dir);

  process-docs = pkgs.writeShellScriptBin "process-docs" ''
    ${lib.getExe pkgs.mdsh}
  '';

  templates = getTemplates ./templates;

  ffizer-packages = mapAttrs' (
    name: _:
    nameValuePair name (
      pkgs.writeShellScriptBin "ffizer-${name}" ''
        export SOURCE_DIR="${./.}"
        export TEMPLATES_DIR="/tmp/ffizer-${name}"

        cp -R "$SOURCE_DIR/." "$TEMPLATES_DIR"
        chmod -R +w "$TEMPLATES_DIR"

        ${getExe pkgs.ffizer} apply \
          --source "$TEMPLATES_DIR"/templates/${name} \
          --destination "$@"

        rm -rf "$TEMPLATES_DIR"
      ''
    )
  ) templates;
  packages = ffizer-packages // {
    inherit process-docs;
  };
  packages-bin = lib.mapAttrs (
    name: value: pkgs.writeScript "${name}-bin" "${lib.getExe value} \"$@\""
  ) packages;
in
{
  inherit
    lib
    self
    ;

  flake.packages = packages;

  flake.devShells.default = pkgs.mkShellNoCC {
    packages = (builtins.attrValues packages) ++ [
      pkgs.ffizer
      pkgs.mdsh
    ];
  };
}
// packages-bin
