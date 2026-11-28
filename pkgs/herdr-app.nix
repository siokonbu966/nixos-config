{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  copyDesktopItems,
  makeDesktopItem,
  libGL,
  libgcc,
  libxcb,
  libxkbcommon,
  vulkan-loader,
  wayland,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "herdr-app";
  version = "0.1.18";

  # Prebuilt release; see https://releases.herdr.dev/app/latest.json
  src = fetchurl {
    url = "https://releases.herdr.dev/app/${finalAttrs.version}/herdr-app-linux-x86_64.tar.gz";
    hash = "sha256-ihHt153UCzSfcobPUZELYuIRNtr48DAFqf0sTcWDD4M=";
  };

  dontConfigure = true;
  dontBuild = true;

  strictDeps = true;

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
  ];

  # Only libgcc, libxcb and libxkbcommon are linked at build time; the app
  # dlopens libvulkan.so.1, libEGL.so.1, libwayland-{client,egl}.so and
  # libxkbcommon-x11.so.0 at runtime, which autoPatchelfHook cannot see
  # (it only satisfies DT_NEEDED entries). appendRunpaths below extends the
  # final RPATH with these libraries' directories.
  buildInputs = [
    libGL
    libgcc
    libxcb
    libxkbcommon
    vulkan-loader
    wayland
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "herdr-app";
      desktopName = "Herdr";
      comment = "Terminals and coding agents that keep running";
      exec = "herdr-app";
      icon = "herdr-app";
      terminal = false;
      categories = [ "Development" ];
      startupWMClass = "herdr-app";
    })
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 herdr-app $out/bin/herdr-app
    install -Dm644 herdr-app.svg $out/share/icons/hicolor/scalable/apps/herdr-app.svg
    install -Dm644 LICENSE -t $out/share/doc/herdr-app
    install -Dm644 THIRD-PARTY-NOTICES -t $out/share/doc/herdr-app

    runHook postInstall
  '';

  # autoPatchelfHook only resolves DT_NEEDED libraries (libxcb, libxkbcommon,
  # libgcc); the app dlopens libvulkan.so.1, libEGL.so.1,
  # libwayland-{client,egl}.so and libxkbcommon-x11.so.0 at runtime.
  # appendRunpaths is autoPatchelfHook's supported way to extend the final
  # RPATH. The nixpkgs vulkan-loader searches /run/opengl-driver/share for
  # ICDs, so the NVIDIA driver resolves without wrappers or env vars.
  appendRunpaths = [
    (lib.makeLibraryPath [
      libGL
      libxkbcommon
      vulkan-loader
      wayland
    ])
  ];

  meta = {
    description = "Desktop app for terminals and coding agents";
    homepage = "https://github.com/herdrdev/herdr-app";
    license = lib.licenses.asl20;
    mainProgram = "herdr-app";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
