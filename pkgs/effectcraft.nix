{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  pkg-config,
  alsa-lib,
  wayland,
  makeWrapper,
  libxkbcommon,
  vulkan-loader,
  libglvnd,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "effectcraft";
  version = "0.25.1";

  src = fetchFromGitHub {
    owner = "storytold";
    repo = "effectcraft";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KgWUNQ5GTgGeQoH6oDbLOq552ZNjiHE1cKo+Cx8s9wg=";
  };

  cargoLock = {
    lockFile = finalAttrs.src + "/Cargo.lock";
    outputHashes = {
      "craft-aaf-0.1.0" = "sha256-tyLwrwp5M+9ynTAHKjsdeHPoBFXll3bFvBuPi3EI+GE=";
      "craft-aep-0.1.0" = "sha256-Kf7u2YULLGpxoG2VNAhc+E5KUyi/Qxe9Rx92FfytIOU=";
      "craft-audio-0.1.0" = "sha256-XHvPKqyixID8CqeHCLNm8SOtCRecQFjGAH+11UlMkuM=";
      "craft-cms-0.1.0" = "sha256-E/7zf4yyxQ9pGK4dDD+752/ejvZQHfifFxA0YO75XHk=";
      "craft-eps-0.1.0" = "sha256-UbYMhYKXMr3DhsGhNQUf0IqudJH+8xyQtCYIJjHVLJQ=";
      "craft-exr-0.1.0" = "sha256-eEQQDCALVFT0E5stkYW+Q2HAZ9gkkZ5Ib5D/916WAUA=";
      "craft-gif-0.1.0" = "sha256-j6e4j5qWNwkeIS1SzF3wRXwip/9REXI/SyyYDHWAiKc=";
      "craft-jsonrpc-0.1.0" = "sha256-vjFuv9lELdNXE4FFW5JkfYEMl/WFZ+ffI0HhLNSgyTY=";
      "craft-psd-0.1.0" = "sha256-3Lv1VdeSALw9c+d6zXpHxHkzn3KU4W44TP4esGhQ9Cg=";
      "craft-svg-0.1.0" = "sha256-5dwle+2eSYAo3CQfJuRuIM27d9PBDE21cQlo273spHY=";
      "craft-time-0.1.0" = "sha256-TPSHx8WYP53oAkcDLQLOhlbThs+kMrVg1rKLjY1BbKE=";
      "ecolor-0.37.0" = "sha256-xzgBk6K1X/MZ8WUlIdy+r/0cf1FDkhJJuwQHZX+WY9U=";
      "filmcraft-bitstream-0.20.1" = "sha256-v6ZYa+C8z4iAT+rvs/xu4ZrI5TzEd6RNwo/9yBTtOwE=";
      "vectorcraft-geom-0.18.0" = "sha256-bX2yTI2K4Xk4YNoNcS2WxyjJyp09iVtEJlqV37fVytM=";
      "winit-0.30.13" = "sha256-+67bk7cqhM5VHqROL3PeghmhKJvlPIxhU73ay45vaxw=";
    };
  };

  cargoBuildFlags = [ "-p" "effectcraft" "-p" "effectcraft-cli" ];

  doCheck = false;

  nativeBuildInputs = lib.optionals stdenv.isLinux [ pkg-config makeWrapper ];
  buildInputs = lib.optionals stdenv.isLinux [
    alsa-lib
    wayland
    libxkbcommon
  ];

  postInstall = lib.optionalString stdenv.isLinux ''
    for bin in effectcraft effectcraft-cli; do
      wrapProgram $out/bin/$bin --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          alsa-lib
          wayland
          libxkbcommon
          vulkan-loader
          libglvnd
        ]
      } --set __EGL_VENDOR_LIBRARY_DIRS /run/opengl-driver/share/glvnd/egl_vendor.d
    done

    install -Dm644 packaging/linux/ai.storyteller.effectcraft.desktop \
      $out/share/applications/ai.storyteller.effectcraft.desktop

    for size in 16x16 24x24 32x32 48x48 64x64 128x128 256x256 512x512; do
      install -Dm644 assets/app-icon/hicolor/$size/apps/ai.storyteller.effectcraft.png \
        $out/share/icons/hicolor/$size/apps/ai.storyteller.effectcraft.png
    done
  '';

  meta = with lib; {
    description = "Motion graphics and visual effects; an open-source reimplementation of Adobe After Effects";
    homepage = "https://github.com/storytold/effectcraft";
    license = with licenses; [ mit asl20 ];
    mainProgram = "effectcraft";
    platforms = platforms.linux ++ platforms.darwin;
  };
})
