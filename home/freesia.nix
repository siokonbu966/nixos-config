{ pkgs, username, ... }:
{
  imports = [
    # cli
    ./programs/git
    ./programs/nixvim
    ./programs/opencode
    ./programs/zsh
    ./programs/nushell
    ./programs/herdr
    ./programs/yazi
    ./programs/gh
    ./programs/fastfetch
    ./programs/tree
    ./programs/btop
    ./programs/ghq
    ./programs/gitea-cli
    ./programs/fzf
    ./programs/ripgrep
    ./programs/emacs
    ./programs/ink
    ./programs/nb
    ./programs/direnv
    ./programs/late-sh
    ./programs/rea
    ./programs/glow
    ./programs/R
    ./programs/w3m

    # gui
    ./programs/ghostty/config.nix
    ./programs/tailscale-gui
    ./programs/appcleaner
    ./programs/obs
    ./programs/vesktop
    ./programs/kopuz
    ./programs/firefox
    ./programs/google-chrome
    ./programs/discord
    ./programs/slack

    # utils
    ./programs/nh
    ./programs/dotfiles
    ./programs/souieba

    # wm
    ./programs/omniwm

    # vm
    ./programs/docker
    ./programs/colima
  ];

  programs.omniwm = {
    enable = true;
  };

  home = {
    username = username;
    homeDirectory = "/Users/${username}";
    stateVersion = "26.05";
  };
}
