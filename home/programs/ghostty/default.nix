{ pkgs, ... }:
{
  imports = [
    ./config.nix
  ];

  home.packages = [
    (if pkgs.stdenv.hostPlatform.isDarwin then pkgs.brewCasks.ghostty else pkgs.ghostty)
  ];
}
