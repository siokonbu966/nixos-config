{ pkgs, ... }:
{
  imports = [
    ./config.nix
  ];

  home.packages = [
    pkgs.ghostty
  ];
}
