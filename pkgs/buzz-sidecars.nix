{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  cmake,
  perl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "buzz-sidecars";
  version = "0.5.28";

  src = fetchFromGitHub {
    owner = "block";
    repo = "buzz";
    tag = "desktop-v${finalAttrs.version}";
    hash = "sha256-NEsLQwcoQ2zTgznFgGFGNgYPnoclicNVycSEjl7I0Wo=";
  };

  cargoLock = {
    lockFile = finalAttrs.src + "/Cargo.lock";
    outputHashes = {
      "aws-creds-0.39.1" = "sha256-QAAm1phmeLFtDRgfDCoHijN1ce/rYzh18KziOUbL+hw=";
      "mesh-llm-api-client-0.76.2" = "sha256-xbyNjc2oInEkmQWkGDAslCM/cNhAVjE4xcpVLFixlLE=";
      "sqlx-core-0.9.0" = "sha256-OfenNO9+5pHeX6yJpMiNW+HSQWvqdtCHt0mpzT8wpFw=";
    };
  };

  nativeBuildInputs = [
    pkg-config
    cmake
    perl
  ];

  cargoBuildFlags = [
    "-p" "buzz-acp"
    "-p" "buzz-agent"
    "-p" "buzz-backend-kubernetes"
    "-p" "buzz-dev-mcp"
    "-p" "git-credential-nostr"
    "-p" "buzz-cli"
  ];

  # Override install to copy only the sidecar binaries.
  # buzz-cli produces a binary named "buzz", not "buzz-cli".
  # buildRustPackage uses --target, so binaries land in target/<triple>/release/.
  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    SRC_DIR="target/${stdenv.hostPlatform.config}/release"
    for bin in buzz-acp buzz-agent buzz-backend-kubernetes buzz-dev-mcp git-credential-nostr; do
      cp $SRC_DIR/$bin $out/bin/
    done
    cp $SRC_DIR/buzz $out/bin/
    runHook postInstall
  '';

  doCheck = false;

  meta = with lib; {
    description = "Buzz sidecar binaries (buzz-acp, buzz-agent, buzz-backend-kubernetes, buzz-dev-mcp, git-credential-nostr, buzz-cli)";
    homepage = "https://github.com/block/buzz";
    license = licenses.asl20;
    platforms = platforms.linux;
  };
})
