{ inputs, pkgs, ... }:
{
  home.packages = [
    inputs.pentect.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
