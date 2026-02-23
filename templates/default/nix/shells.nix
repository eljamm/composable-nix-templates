{
  pkgs,
  default,
  formatter,
  ...
}:
{
  default = pkgs.mkShellNoCC {
    inputsFrom = [
      ## {{#unless (eq template_name "default")}}
      default."!{{template_name}}!".shells.default
      ## {{/unless}}
      formatter.shell
    ];
    packages = with pkgs; [
      formatter.package
      gitMinimal
    ];
    shellHook = ''
      export PROJECT_ROOT="$(git rev-parse --show-toplevel)"

      # better compat with IDEs
      ln -sf \
        "${formatter.configFile}" \
        "$PROJECT_ROOT/treefmt.toml"
    '';
  };
}
