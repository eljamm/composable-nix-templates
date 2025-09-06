{
  devShells,
  pkgs,
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
      cargo-tarpaulin # code coverage
      cargo-udeps # unused deps
    ]
    ++ default
    ++ aliases
    ++ devShells.default.nativeBuildInputs;

    ci = [
      toolchains.ci
      cargo-llvm-cov
      cargo-tarpaulin # code coverage
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
    };
  };

  shells = {
    dev = pkgs.mkShellNoCC {
      packages = packages.dev;
    };
    ci = pkgs.mkShellNoCC {
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
    ];
    ci = [
      "clippy"
      "llvm-tools-preview"
    ];
  };

  toolchains = {
    default = toolchains.stable;
    ci = toolchains.default.override { extensions = extensions.default; };
    stable = pkgs.rust-bin.stable.latest.minimal.override { extensions = extensions.default; };
    nightly = pkgs.rust-bin.selectLatestNightlyWith (
      toolchain: toolchain.minimal.override { extensions = extensions.default; }
    );
  };
}
