{
  pkgs,
  inputs,
  system,
  ...
}:
let
  git-hooks = import inputs.git-hooks { inherit system; };
  treefmt-nix = import inputs.treefmt-nix;

  treefmt = treefmt-nix.mkWrapper pkgs {
    projectRootFile = "flake.nix";
    programs.nixfmt.enable = true;
    programs.actionlint.enable = true;
  };

  pre-commit-hook = pkgs.mkShellNoCC {
    packages = [ treefmt ];
    shellHook = ''
      ${with git-hooks.lib.git-hooks; pre-commit (wrap.abort-on-change treefmt)}
    '';
  };

  formatter = pkgs.writeShellApplication {
    name = "formatter";
    runtimeInputs = [ treefmt ];
    text = ''
      # shellcheck disable=all
      shell-hook () {
        ${pre-commit-hook.shellHook}
      }

      shell-hook
      treefmt
    '';
  };
in
formatter
