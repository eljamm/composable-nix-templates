{
  pkgs,
  devLib,
  format,
  ...
}@args:
rec {
  crates = import ./crates args;

  packages = with pkgs; rec {
    default = [
      toolchains.default
      cargo-auditable
    ]
    ++ deps;

    deps = [
      openssl
      pkg-config
    ];

    dev = [
      bacon
      cargo-deny # scan vulnerabilities
      cargo-expand # macro expansion
      cargo-llvm-cov # code coverage
      cargo-udeps # unused deps
    ]
    ++ default
    ++ aliases;

    ci = [
      toolchains.default
      cargo-llvm-cov
    ]
    ++ deps;

    aliases = devLib.mkAliases {
      # Explain `rustc` errors with markdown formatting
      rexp = {
        text = ''rustc --explain "$1" | sed '/^```/{s//&rust/;:a;n;//!ba}' | rich -m -'';
        runtimeInputs = [ pkgs.rich-cli ];
      };

      # Cargo
      bb = "cargo build";
      rr = "cargo run";
      tt = "cargo test";

      # Nix
      nbb = "nix build --show-trace --print-build-logs";
      nrr = "nix run --show-trace --print-build-logs";

      fmt = format.formatter;
    };
  };

  shells = {
    default = devLib.mkShellMold {
      packages = [
        format.formatter
      ]
      ++ packages.dev;
    };
    ci = devLib.mkShellMold {
      packages = packages.ci;
    };
  };

  extensions = {
    default = [
      "cargo"
      "clippy"
      "rust-src"
      "rustc"
      "rustfmt"
      "rust-analyzer"
      "llvm-tools-preview"
    ];
  };

  toolchains = {
    default = toolchains.stable;
    stable = pkgs.rust-bin.stable.latest.minimal.override { extensions = extensions.default; };
    nightly = pkgs.rust-bin.selectLatestNightlyWith (
      toolchain: toolchain.minimal.override { extensions = extensions.default; }
    );
  };
}
