{ pkgs, ... }:
{
  home.packages = [
    pkgs.yt-dlp
    pkgs.ffmpeg
  ];
}
