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
    ./programs/btop
    ./programs/wl-clipboard

    # gui
    ./programs/fuzzel
    ./programs/firefox/basic.nix
    ./programs/mako

    # surface-go-2
    ./programs/brightnessctl
    ./programs/foot
    ./programs/sway/surface-go-2.nix
    ./programs/wvkbd
  ];

  home = {
    username = username;
    homeDirectory = "/home/${username}";
    stateVersion = "26.05";
  };
}
