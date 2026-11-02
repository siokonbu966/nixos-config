{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  rustPlatform,
  cargo-tauri,
  pnpm,
  nodejs,
  fetchPnpmDeps,
  pnpmConfigHook,
  pkg-config,
  wrapGAppsHook3,
  glib,
  gtk3,
  webkitgtk_4_1,
  libayatana-appindicator,
  librsvg,
  alsa-lib,
  openssl,
  sqlite,
  opus,
  libclang,
  pango,
  gdk-pixbuf,
  cairo,
  harfbuzz,
  dbus,
  libsecret,
  curl,
  perl,
  jq,
  buzz-sidecars ? null,
  gst_all_1,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "buzz-desktop";
  version = "0.5.28";

  src = fetchFromGitHub {
    owner = "block";
    repo = "buzz";
    tag = "desktop-v${finalAttrs.version}";
    hash = "sha256-NEsLQwcoQ2zTgznFgGFGNgYPnoclicNVycSEjl7I0Wo=";
  };

  cargoLock = {
    lockFile = finalAttrs.src + "/desktop/src-tauri/Cargo.lock";
    outputHashes = {
      "mesh-llm-api-client-0.76.2" = "sha256-xbyNjc2oInEkmQWkGDAslCM/cNhAVjE4xcpVLFixlLE=";
    };
  };

  cargoRoot = "desktop/src-tauri";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm;
    fetcherVersion = 4;
    hash = "sha256-gmihUFwbA/KAM/91q6BOn8jCSzuDeQdJuvk4HTbZK1Q=";
  };

  sherpaOnnxArchive = fetchurl {
    url = "https://github.com/k2-fsa/sherpa-onnx/releases/download/v1.13.4/sherpa-onnx-v1.13.4-linux-x64-static-lib.tar.bz2";
    hash = "sha256-mLDjGZZCb254JE284ZVVSPLGTo8BxL51uFr3zaoujVw=";
  };

  sherpaOnnxDir = stdenv.mkDerivation {
    name = "sherpa-onnx-dir";
    src = finalAttrs.sherpaOnnxArchive;
    dontUnpack = true;
    installPhase = ''
      mkdir -p $out
      cp $src $out/sherpa-onnx-v1.13.4-linux-x64-static-lib.tar.bz2
    '';
  };

  nativeBuildInputs = [
    cargo-tauri.hook
    pnpmConfigHook
    pnpm
    nodejs
    pkg-config
    wrapGAppsHook3
    perl
    jq
  ];

  buildInputs = [
    glib
    gtk3
    webkitgtk_4_1
    libayatana-appindicator
    librsvg
    alsa-lib
    openssl
    sqlite
    opus
    libclang
    pango
    gdk-pixbuf
    cairo
    harfbuzz
    dbus
    libsecret
    curl
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
  ];

  postPatch = ''
    # Skip tsc type checking (has upstream TS errors) — change build script to just run vite
    jq '.scripts.build = "vite build"' desktop/package.json > tmp.json && mv tmp.json desktop/package.json

    # Set window visible: true so it appears on Wayland/niri
    jq '.app.windows[0].visible = true' desktop/src-tauri/tauri.conf.json > tmp.json && mv tmp.json desktop/src-tauri/tauri.conf.json

    # Remove patchedDependencies from both workspace config and lockfile
    # to avoid pnpm version mismatch (upstream 11.4.0 vs nixpkgs 11.15.0)
    sed -i '/^patchedDependencies:/,$d' pnpm-workspace.yaml
    # Remove lines 11-14 (patchedDependencies block) from lockfile
    sed -i '11,14d' pnpm-lock.yaml

    # Remove test module that references cfg(debug_assertions) symbols not available in release builds
    sed -i '/#\[cfg(test)\]/{N;d}' desktop/src-tauri/src/lib.rs

    # Bundle sidecar binaries (mirrors scripts/bundle-sidecars.sh)
    ${lib.optionalString (buzz-sidecars != null) ''
      mkdir -p desktop/src-tauri/binaries
      TARGET="${stdenv.hostPlatform.config}"
      for bin in buzz-acp buzz-agent buzz-backend-kubernetes buzz-dev-mcp git-credential-nostr; do
        cp ${buzz-sidecars}/bin/$bin "desktop/src-tauri/binaries/$bin-$TARGET"
        chmod 755 "desktop/src-tauri/binaries/$bin-$TARGET"
      done
      cp ${buzz-sidecars}/bin/buzz "desktop/src-tauri/binaries/buzz-$TARGET"
      chmod 755 "desktop/src-tauri/binaries/buzz-$TARGET"
    ''}
  '';

  cargoBuildFlags = [ "--package" "buzz-desktop" ];

  doCheck = false;

  env = {
    SHERPA_ONNX_ARCHIVE_DIR = "${finalAttrs.sherpaOnnxDir}";
  };

  preFixup = ''
    gappsWrapperArgs+=(
      --set GDK_BACKEND x11
    )
  '';

  meta = with lib; {
    description = "A hive mind communication platform - desktop app";
    homepage = "https://github.com/block/buzz";
    license = licenses.asl20;
    mainProgram = "buzz";
    platforms = platforms.linux;
  };
})
