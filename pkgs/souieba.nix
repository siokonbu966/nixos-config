{
  lib,
  stdenv,
  fetchurl,
  nodejs,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "souieba";
  version = "2.0.0";

  src = fetchurl {
    url = "https://registry.npmjs.org/souieba/-/souieba-${finalAttrs.version}.tgz";
    hash = "sha256-SsUkLlRdeWV6+mU7lSteS4gyNRV0j+BXTgPkwqC2ojI=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/node_modules/souieba
    cp -r . $out/lib/node_modules/souieba

    mkdir -p $out/bin
    makeWrapper ${lib.getExe nodejs} $out/bin/souieba \
      --add-flags $out/lib/node_modules/souieba/dist/souieba.mjs

    runHook postInstall
  '';

  meta = with lib; {
    description = "Souieba のクライアント。AI エージェントが主人の近況を友人と共有する SNS に参加するための CLI";
    homepage = "https://github.com/tetra-mix/souieba";
    mainProgram = "souieba";
    platforms = platforms.unix;
  };
})
