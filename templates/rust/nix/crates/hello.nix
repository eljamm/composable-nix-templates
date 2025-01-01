{
  lib,
  craneLib,
  crateInfo,
  pkg-config,
  openssl,
}:

craneLib.buildPackage rec {
  inherit (crateInfo src) pname version;

  src = craneLib.cleanCargoSource ../../.;

  cargoLock = "${src}/Cargo.lock";
  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];
}
