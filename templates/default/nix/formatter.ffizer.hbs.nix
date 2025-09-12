{
  lib,
  pkgs,
  inputs,
  system,
  ...
}@args:
let
  git-hooks = import inputs.git-hooks { inherit system; };
  treefmt-nix = import inputs.treefmt-nix;

  treefmt-cfg = {
    projectRootFile = "default.nix";
    programs.nixfmt.enable = true;
    programs.actionlint.enable = true;
    programs.zizmor.enable = true;
    ## {{#if (eq template_name "rust")}}
    programs.rustfmt = {
      enable = true;
      edition = "2024";
      package = args.rust.toolchains.default.availableComponents.rustfmt;
    };
    programs.taplo.enable = true; # TOML
    ## {{else if (eq template_name "go")}}
    programs.gofumpt.enable = true;
    programs.golines.enable = true;
    programs.goimports = {
      enable = true;
      package = pkgs.goimports-reviser;
    };
    settings.formatter.goimports = {
      command = lib.mkForce "${lib.getExe pkgs.goimports-reviser}";
      options = lib.mkForce [
        "-format"
        "-apply-to-generated-files"
      ];
    };
    ## {{else if (eq template_name "zig")}}
    settings.formatter.zig = {
      command = "${lib.getExe' args.zig.zig-default "zig"}";
      options = [ "fmt" ];
      includes = [
        "*.zig"
        "*.zon"
      ];
    };
    ## {{else}}
    ## {{/if}}
  };
  treefmt = treefmt-nix.mkWrapper pkgs treefmt-cfg;
  treefmt-pkgs = (treefmt-nix.evalModule pkgs treefmt-cfg).config.build.devShell.nativeBuildInputs;
in
{
  pre-commit-hook = pkgs.writeShellScriptBin "git-hooks" ''
    if [[ -d .git ]]; then
      ${with git-hooks.lib.git-hooks; pre-commit (wrap.abort-on-change treefmt)}
    fi
  '';

  formatter = treefmt;
  formatter-pkgs = treefmt-pkgs;
}
