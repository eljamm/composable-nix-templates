{
  lib,
  pkgs,
  inputs,
  ## {{#if (eq template_name "rust")}}
  rust,
  ## {{else if (eq template_name "zig")}}
  zig,
  ## {{/if}}
  ...
}:
lib.makeExtensible (self: {
  treefmt = import inputs.treefmt-nix;

  config = {
    projectRootFile = "default.nix";

    programs.nixfmt.enable = true;
    programs.actionlint.enable = true;
    programs.zizmor.enable = true;

    ## {{#if (eq template_name "rust")}}
    programs.rustfmt = {
      enable = true;
      edition = "2024";
      package = rust.toolchains.default.availableComponents.rustfmt;
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
      command = "${lib.getExe' zig.zig-default "zig"}";
      options = [ "fmt" ];
      includes = [
        "*.zig"
        "*.zon"
      ];
    };
    ## {{else}}
    ## {{/if}}

    settings.formatter.editorconfig-checker = {
      command = pkgs.editorconfig-checker;
      includes = [ "*" ];
      priority = 9; # last
    };
  };

  # evaluated config
  eval = self.treefmt.evalModule pkgs self.config;
  configFile = self.eval.config.build.configFile;

  # treefmt package
  package = self.eval.config.build.wrapper;

  # development shell that contains all formatters
  shell = self.eval.config.build.devShell;
})
