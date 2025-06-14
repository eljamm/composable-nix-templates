{
  lib,
  rustPlatform,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hello";
  version = "0.0.0";

  src = ../../.;

  cargoLock.lockFile = "${finalAttrs.src}/Cargo.lock";
  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];
})
