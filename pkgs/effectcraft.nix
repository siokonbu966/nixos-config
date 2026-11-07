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
  version = "0.21.1";

  src = fetchFromGitHub {
    owner = "storytold";
    repo = "effectcraft";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xI7yvrY6POSIhqsK2OuKwfy+EqY6N2APPPHXZuuFDIA=";
  };

  cargoLock = {
    lockFile = finalAttrs.src + "/Cargo.lock";
    outputHashes = {
      "craft-docpath-0.1.0" = "sha256-/8I9DcqtsznoYPo4ECc/rPQIal6P9gyPksrvVHDW6Mg=";
      "craft-ecproj-format-0.1.0" = "sha256-aEW6WiEyi9YB/mAVdhRJ/WaPBxaIhH1wkhenPE8KLNE=";
      "craft-update-0.1.0" = "sha256-BRkWxb796qLWtF1U1EqCZFa8h1YCuoAZcXrVWMN8MEY=";
      "ecolor-0.37.0" = "sha256-xzgBk6K1X/MZ8WUlIdy+r/0cf1FDkhJJuwQHZX+WY9U=";
      "filmcraft-aac-0.8.0" = "sha256-zwGlMsfzhQT+5pbYOaxyaOAfBkm6Ocs6s8+Dnz1A+nE=";
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
