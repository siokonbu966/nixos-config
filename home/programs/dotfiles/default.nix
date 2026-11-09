{ device ? "saffron", my-dotfiles, ...}:
let
  deviceConfig_xdg = if device == "saffron" then {
    "niri".source = ../../../configs/niri;
    "picom".source = "${my-dotfiles}/picom.conf";
    "kitty".source = "${my-dotfiles}/kitty";
  } else {};
in
{
  xdg.configFile = {
    "fastfetch".source = "${my-dotfiles}/fastfetch";
  } // deviceConfig_xdg;
  home.file = {
    ".bashrc".source = ../../../configs/bash/.bashrc;
  };
}
