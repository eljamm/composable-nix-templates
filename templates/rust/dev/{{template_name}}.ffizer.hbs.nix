{
  devShells,
  pkgs,
  ...
}@args:
rec {
  crates = import ../dev/crates args;

  packages = with pkgs; rec {
    default = [
      rust.toolchains.default
      cargo-auditable
    ];
    dev = default ++ [
      bacon
      cargo-tarpaulin # code coverage
      cargo-udeps # unused deps
    ];
    ci = [
      rust.toolchains.ci
      cargo-tarpaulin # code coverage
    ];
  };

  shells = {
    dev = pkgs.mkShellNoCC {
      packages = devShells.default.nativeBuildInputs ++ packages.dev;
    };
    ci = pkgs.mkShellNoCC {
      packages = packages.ci;
    };
  };

  rust = rec {
    extensions = [
      "cargo"
      "clippy"
      "rust-src"
      "rustc"
      "rustfmt"
      "rust-analyzer"
    ];
    extensions-ci = [
      "clippy"
    ];

    toolchains.default = "!toolchains.{{toolchain}}!";
    toolchains.ci = toolchains.default.override { extensions = extensions-ci; };
    toolchains.stable = pkgs.rust-bin.stable.latest.minimal.override { inherit extensions; };
    toolchains.nightly = pkgs.rust-bin.selectLatestNightlyWith (
      toolchain: toolchain.minimal.override { inherit extensions; }
    );
  };
}
