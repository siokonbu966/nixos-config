{ pkgs, lib, inputs, ... }:
let
  kopuz = inputs.kopuz.packages.${pkgs.system}.default.overrideAttrs (old: {
    postInstall = (old.postInstall or "") + lib.optionalString pkgs.stdenv.isDarwin ''
      install -Dm644 crates/kopuz/assets/icon.icns \
        $out/bin/kopuz.app/Contents/Resources/icon.icns
      mkdir -p $out/Applications
      ln -s ../bin/kopuz.app $out/Applications/Kopuz.app
    '';
  });
in
{
  home.packages = [ kopuz ];
}
