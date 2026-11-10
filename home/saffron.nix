{ pkgs, lib, username, isCI ? false, ... }:
{
  imports = [
    # cli
    ./programs/git
    ./programs/fastfetch
    ./programs/nixvim
    ./programs/nh
    ./programs/tree
    ./programs/btop
    ./programs/ghq
    ./programs/gitea-cli
    ./programs/fzf
    ./programs/ripgrep
    ./programs/ollama
    ./programs/opencode
    #./programs/hermes-agent
    ./programs/direnv
    ./programs/tmux
    ./programs/zsh
    #./programs/nushell
    ./programs/herdr
    ./programs/yazi
    ./programs/gh
    ./programs/emacs
    ./programs/bat
    ./programs/ink
    ./programs/leaf
    ./programs/nb
    ./programs/wl-clipboard
    ./programs/late-sh
    ./programs/rea

    # gui
    ./programs/fuzzel
    ./programs/obs
    ./programs/ghostty
    ./programs/alacritty
    ./programs/noctalia
    #./programs/kitty
    ./programs/vesktop
    ./programs/vlc
    ./programs/kopuz
    ./programs/tigervnc
    ./programs/google-chrome
    ./programs/firefox
    ./programs/zed-editor
    ./programs/vscodium
    ./programs/osu-lazer
    ./programs/prismlauncher
    ./programs/gimp
    ./programs/nautilus # GNOME file manager
    #./programs/lmstudio
    ./programs/signal-desktop
    ./programs/zotero

    # utils
    ./programs/fontconfig
    ./programs/gtk
    ./programs/mako
    ./programs/udisk
    ./programs/dotfiles
    ./programs/slurp
    ./programs/nil # nix language server
    ./programs/gnumake
    ./programs/usbutils
    ./programs/wireshark
    ./programs/easyeffect
    ./programs/pandoc
    ./programs/wayvr
    ./programs/w3m
    ./programs/souieba

    # wm
    ./programs/waybar
    ./programs/swayidle
    ./programs/swaylock
    ./programs/niri
    ./programs/swaybg
    ./programs/swayr

    # containers
    ./programs/docker

    # saffron-specific
    ./programs/pipewire
    ./programs/wireplumber
    ./programs/playerctl
    ./programs/grim
    ./programs/xremap
    ./programs/brightnessctl
    ./programs/ddcutil
    ./programs/pavucontrol

    # tools
    ./tools/cursor
    ./tools/default-app
    ./tools/variables
  ]
  ++ lib.optionals (!isCI) [
    ./programs/cisco-packet-tracer
  ];

  home = {
    username = username;
    homeDirectory = "/home/${username}";
    stateVersion = "25.05";
    #packages = [ pkgs.buzz-desktop ];
  };
  programs.home-manager.enable = true;
}
