{
  lib,
  writeShellApplication,
  ## {{#if (eq template_name "rust")}}
  mkShell,
  useMoldLinker,
  gccStdenv,
  ## {{/if}}
  ...
}:
rec {
  attrsToApp =
    name: value:
    writeShellApplication {
      inherit name;
      text = value.text or (value + " \"$@\"");
      runtimeInputs = value.runtimeInputs or [ ];
    };

  mkAliases = aliases: lib.attrValues (lib.mapAttrs attrsToApp aliases);

  mkApps =
    apps:
    lib.mapAttrs (name: value: {
      type = "app";
      program = attrsToApp name value;
    }) apps;

  ## {{#if (eq template_name "rust")}}
  mkShellMold =
    attrs:
    mkShell.override {
      stdenv = useMoldLinker gccStdenv;
    } attrs;
  ## {{/if}}
}
