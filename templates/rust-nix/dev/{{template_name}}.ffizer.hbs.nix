{
  pkgs,
  ...
}:
rec {
  # TODO: refactor into groups
  packages = with pkgs; [
    rust.toolchains.default

    cargo-auditable
    cargo-tarpaulin # code coverage
    cargo-udeps # unused deps
    bacon
  ];

  rust = rec {
    extensions = [
      "cargo"
      "clippy"
      "rust-src"
      "rustc"
      "rustfmt"
      "rust-analyzer"
    ];

    toolchains.default = "!toolchains.{{toolchain}}!";
    toolchains.stable = pkgs.rust-bin.stable.latest.minimal.override { inherit extensions; };
    toolchains.nightly = pkgs.rust-bin.selectLatestNightlyWith (
      toolchain: toolchain.minimal.override { inherit extensions; }
    );
  };
}
