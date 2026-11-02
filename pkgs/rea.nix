{
  lib,
  stdenv,
  fetchurl,
  jq,
  buildNpmPackage,
  procps,
}:

let
  version = "6.8.0";

  tarball = fetchurl {
    url = "https://registry.npmjs.org/rea-agents/-/rea-agents-${version}.tgz";
    hash = "sha256-jVQux2qcs1BYS2CmycCIcG/4EtW7WwlMIMlbbcJWmLs=";
  };

  lockfile = fetchurl {
    url = "https://raw.githubusercontent.com/morluto/rea/rea-agents-${version}/package-lock.json";
    hash = "sha256-HY+g8zsxJdPmAeyDKxjZ01s3RT82NA3AUH8GWo3hWK0=";
  };
in
buildNpmPackage (finalAttrs: {
  pname = "rea";
  inherit version;

  src = stdenv.mkDerivation {
    name = "${finalAttrs.pname}-${finalAttrs.version}-source";

    nativeBuildInputs = [ jq ];

    dontUnpack = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      tar -xzf ${tarball} -C $out --strip-components=1
      cp ${lockfile} $out/package-lock.json

      jq 'del(.optionalDependencies.frida)' $out/package.json > package.json
      mv package.json $out/package.json

      jq 'del(.packages["node_modules/frida"]) | del(.packages[""].optionalDependencies.frida)' \
        $out/package-lock.json > package-lock.json
      mv package-lock.json $out/package-lock.json

      runHook postInstall
    '';
  };

  dontNpmBuild = true;

  npmDepsHash = "sha256-xfT///2XWCXJUKW/XcbN18uUxJau5X/GYsdHV3s2qe4=";

  npmInstallFlags = [ "--omit=dev" ];

  npmRebuildFlags = [ "--ignore-scripts" ];

  makeWrapperArgs = [ "--prefix PATH : ${lib.makeBinPath [ procps ]}" ];

  meta = with lib; {
    description = "Reverse engineer anything with agents, from app behavior down to native binaries";
    homepage = "https://github.com/morluto/rea";
    license = licenses.mit;
    mainProgram = "rea";
    platforms = platforms.unix;
  };
})
