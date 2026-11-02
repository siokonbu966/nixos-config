{ username, ... }:
{
  imports = [
    # cli
    ./programs/git
    ./programs/nixvim
    ./programs/opencode
    ./programs/tmux
    ./programs/zsh
    ./programs/herdr
    ./programs/yazi
    ./programs/gh
    ./programs/fastfetch
    ./programs/tree
    ./programs/btop
    ./programs/ghq
    ./programs/google-chrome
    ./programs/fzf
    ./programs/ripgrep
    ./programs/slack
    ./programs/tailscale-gui
    ./programs/emacs
    ./programs/ink
    ./programs/nb
    ./programs/direnv
    ./programs/late-sh
    ./programs/appcleaner
    ./programs/discord
    ./programs/rea
    ./programs/ollama
    ./programs/glow
    ./programs/w3m

    # gui
    ./programs/ghostty
    ./programs/obs
    ./programs/vesktop
    ./programs/kopuz
    ./programs/whatcable

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
