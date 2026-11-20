{ pkgs, ... }:
{
  # The app resolves its bundle identifier from its executable path, so invoke
  # it directly instead of exposing the executable through a symlink.
  home.packages = [
    (pkgs.writeShellScriptBin "tailscale" ''
      exec /Applications/Tailscale.app/Contents/MacOS/Tailscale "$@"
    '')
  ];
}
