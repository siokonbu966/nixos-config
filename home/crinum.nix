{ username, ... }:
{
  imports = [
    # cli
    ./programs/nixvim
    ./programs/opencode
    ./programs/herdr
    ./programs/git
    ./programs/nh
    ./programs/tree
    ./programs/ghq
    ./programs/gitea-cli
    ./programs/fzf
    ./programs/btop
    ./programs/wl-clipboard
    ./programs/gh
    ./programs/xremap
    ./programs/yazi

    # gui
    ./programs/fuzzel
    ./programs/firefox
    ./programs/mako
    ./programs/waybar

    # crinum
    ./programs/brightnessctl
    ./programs/foot
    ./programs/playerctl
    ./programs/sway/crinum.nix
    ./programs/wvkbd

    # cli
    ./programs/zsh
  ];

  home = {
    username = username;
    homeDirectory = "/home/${username}";
    stateVersion = "26.05";
  };
}
