{ username, ... }:
{
  imports = [
    # cli
    ./programs/git
    ./programs/nix-secure-enclave-key
    ./programs/nixvim
    ./programs/opencode
    ./programs/zsh
    ./programs/atuin
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
    ./programs/leaf
    ./programs/slack
    ./programs/emacs
    ./programs/ink
    ./programs/nb
    ./programs/direnv
    ./programs/late-sh
    ./programs/appcleaner
    ./programs/rea
    ./programs/ollama
    ./programs/bat
    ./programs/w3m
    ./programs/chawan
    ./programs/ffmpeg

    # gui
    ./programs/plamonic
    ./programs/brew/ghostty
    ./programs/ghostty/config.nix
    ./programs/tailscale-gui
    ./programs/appcleaner
    ./programs/brew/obs
    ./programs/vesktop
    ./programs/kopuz
    ./programs/brew/whatcable
    ./programs/firefox
    ./programs/google-chrome
    ./programs/brew/discord
    ./programs/slack
    ./programs/signal-desktop
    ./programs/zotero

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
