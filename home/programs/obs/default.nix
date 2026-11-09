{ pkgs, lib, ... }:
{
  home.packages = lib.optional pkgs.stdenv.hostPlatform.isDarwin pkgs.brewCasks.obs;

  programs.obs-studio = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
    enable = true;

    # optional Nvidia hardware acceleration
    package = (
      pkgs.obs-studio.override {
        cudaSupport = true;
      }
    );

    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
      obs-gstreamer
      obs-vkcapture
    ];
  };
}
