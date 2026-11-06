{ pkgs, ... }:
{
  # Docker CLI and Compose; the engine is configured separately per host.
  home.packages = with pkgs; [
    docker-client
    docker-compose
  ];
}
