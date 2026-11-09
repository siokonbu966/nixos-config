{ pkgs, ... }:
let
  wvkbd-toggle = pkgs.writeShellScriptBin "wvkbd-toggle" ''
    if ${pkgs.procps}/bin/pgrep -x wvkbd-mobintl >/dev/null 2>&1; then
      ${pkgs.procps}/bin/pkill -RTMIN -x wvkbd-mobintl
    else
      ${pkgs.wvkbd}/bin/wvkbd-mobintl >/dev/null 2>&1 &
    fi
  '';
in
{
  home.packages = [
    pkgs.wvkbd
    wvkbd-toggle
  ];
}
