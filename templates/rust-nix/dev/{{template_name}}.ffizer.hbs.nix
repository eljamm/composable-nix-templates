{
  pkgs,
  ...
}:
rec {
  packages = with pkgs; rec {
    default = [
      rust.toolchains.default
      cargo-auditable
    ];
    dev = default ++ [
      cargo-tarpaulin # code coverage
      bacon
    ];
    ci = [
      rust.toolchains.ci
      cargo-udeps # unused deps
    ];
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
      "llvm-tools-preview"
    ];

    toolchains.default = "!toolchains.{{toolchain}}!";
    toolchains.ci = "!toolchains.{{toolchain}}!".override { extensions = extensions-ci; };
    toolchains.stable = pkgs.rust-bin.stable.latest.minimal.override { inherit extensions; };
    toolchains.nightly = pkgs.rust-bin.selectLatestNightlyWith (
      toolchain: toolchain.minimal.override { inherit extensions; }
    );
  };
}
