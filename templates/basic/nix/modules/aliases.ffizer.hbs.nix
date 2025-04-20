{
  perSystem =
    { pkgs, devLib, ... }:
    {
      devShells = {
        aliases = pkgs.mkShell {
          packages = devLib.mkAliases {
            # Nix
            nbb = "nix build --show-trace --print-build-logs";
            nrr = "nix run --show-trace --print-build-logs";
          };
        };
        # --- {{#if (eq language "rust") }}
        aliases-rust = pkgs.mkShell {
          packages = devLib.mkAliases {
            # Explain `rustc` errors with markdown formatting
            rexp = {
              text = ''rustc --explain "$1" | sed '/^```/{s//&rust/;:a;n;//!ba}' | rich -m -'';
              runtimeInputs = [ pkgs.rich-cli ];
            };

            # Cargo
            bb = "cargo build";
            rr = "cargo run";
            tt = "cargo test";
          };
        };
        # --- {{/if}}
        # --- {{#if (eq language "go") }}
        aliases-go = pkgs.mkShell {
          packages = devLib.mkAliases {
            # run tests in the current directory (as readable documentation)
            td = ''
              gotestdox ./... "$@"
            '';

            # watch go files and test on changes
            tw = ''
              gotestsum --format testname --watch-chdir --watch
            '';

            # run tests in the current directory (all from root)
            tt = ''
              gotestsum --format testname "$@"
            '';
          };
        };
        # --- {{/if}}
      };
    };
}
