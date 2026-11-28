{
  lib,
  stdenvNoCC,
  fetchurl,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "herdr-core";
  version = "0.1.22";

  # Prebuilt static release; see https://releases.herdr.dev/core/latest.json
  src = fetchurl {
    url = "https://releases.herdr.dev/core/${finalAttrs.version}/herdr-core-linux-x86_64.tar.gz";
    hash = "sha256-MFTsOZLOgMVxXXIcqp3O+mBWch0V3BE/R1CvznY7pd8=";
  };

  # The tarball holds a single static binary and no directory, so unpack it
  # by hand in the install phase.
  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    tar -xzf $src
    install -Dm755 herdr-core $out/bin/herdr-core
    ln -s herdr-core $out/bin/hc

    runHook postInstall
  '';

  meta = {
    description = "Core that runs terminals for the Herdr desktop app and keeps them alive";
    homepage = "https://github.com/herdrdev/herdr-core";
    license = lib.licenses.asl20;
    mainProgram = "herdr-core";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
