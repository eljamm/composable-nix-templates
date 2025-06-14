{
  lib,
  pkgs,
  self,
  ...
}:
let
  getTemplates = dir: lib.filterAttrs (_: type: type == "directory") (builtins.readDir dir);
  templatesDir = ../templates;

  scripts = lib.mapAttrs (
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

  # required for running: bash $(nix-build -A <template_name>)
  scripts-bin = lib.mapAttrs (
    name: value: pkgs.writeScript "${name}-bin" "${lib.getExe value} \"$@\""
  ) scripts;

  docs = pkgs.writeShellScriptBin "docs" ''
    ${lib.getExe pkgs.mdsh}
  '';
in
{
  inherit
    docs
    scripts
    scripts-bin
    ;
}
