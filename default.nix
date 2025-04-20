{
  inputs ? import (fetchTarball "https://github.com/fricklerhandwerk/flake-inputs/tarball/main") {
    root = ./.;
  },
  system ? builtins.currentSystem,
  pkgs ? import inputs.nixpkgs { inherit system; },
}:
let
  inherit (pkgs)
    lib
    ;

  inherit (lib)
    filterAttrs
    getExe
    mapAttrs'
    nameValuePair
    ;

  getTemplates = dir: filterAttrs (_: type: type == "directory") (builtins.readDir dir);

  templates = getTemplates ./templates;
in
{
  flake.packages = mapAttrs' (
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
}
