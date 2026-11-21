{ pkgs, ... }:
{
  home.packages = [ pkgs.brewCasks.tailscale-app ];
}
