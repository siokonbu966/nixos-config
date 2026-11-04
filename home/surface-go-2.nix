{ username, ... }:
{
  imports = [
    # gui
    ./programs/fuzzel
    ./programs/firefox/basic.nix
    ./programs/mako

    # surface-go-2
    ./programs/brightnessctl
    ./programs/foot
    ./programs/sway/surface-go-2.nix
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
