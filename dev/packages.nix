{
  lib,
  pkgs,
  self,
  ...
}:
let
  getTemplates = dir: lib.filterAttrs (_: type: type == "directory") (builtins.readDir dir);
  templatesDir = ../templates;

  ffizer-packages = lib.mapAttrs (
    name: _:
    pkgs.writeShellScriptBin "${name}" ''
      export SOURCE_DIR="${self.outPath}"
      export TEMPLATES_DIR="/tmp/ffizer-${name}"

      cp -R "$SOURCE_DIR/." "$TEMPLATES_DIR"
      chmod -R +w "$TEMPLATES_DIR"

      ${lib.getExe pkgs.ffizer} apply \
        --source "$TEMPLATES_DIR"/templates/${name} \
        --destination "$@"

      rm -rf "$TEMPLATES_DIR"
    ''
  ) (getTemplates templatesDir);

  docs = pkgs.writeShellScriptBin "process-docs" ''
    ${lib.getExe pkgs.mdsh}
  '';
in
ffizer-packages // { inherit docs; }
