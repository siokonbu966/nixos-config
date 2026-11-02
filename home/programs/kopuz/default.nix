{ pkgs, lib, inputs, ... }:
let
  kopuz = inputs.kopuz.packages.${pkgs.system}.default.overrideAttrs (old: {
    postInstall = (old.postInstall or "") + lib.optionalString pkgs.stdenv.isDarwin ''
      for icon in apps/legacy/kopuz/assets/icon.icns crates/kopuz/assets/icon.icns; do
        if [ -f "$icon" ]; then
          install -Dm644 "$icon" \
            $out/bin/kopuz.app/Contents/Resources/icon.icns
          break
        fi
      done
      mkdir -p $out/Applications
      ln -s ../bin/kopuz.app $out/Applications/Kopuz.app
    '';
  });
in
{
  home.packages = [ kopuz ];
}
