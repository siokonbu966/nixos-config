{ pkgs, ... }:
{
  home.packages = [ pkgs.brewCasks.obs ];
}
