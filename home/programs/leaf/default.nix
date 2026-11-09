{ pkgs, ... }:
{
  home.packages = [
    (pkgs.callPackage ../../../pkgs/leaf-markdown-viewer.nix { })
  ];
}
