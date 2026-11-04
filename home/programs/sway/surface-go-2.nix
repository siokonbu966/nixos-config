{ ... }:
{
  wayland.windowManager.sway = {
    enable = true;
    config = {
      modifier = "Mod4";
      terminal = "foot";
      menu = "fuzzel";
      input."*".xkb_layout = "jp";
      keybindings = {
        "Mod4+Return" = "exec foot";
        "Mod4+d" = "exec fuzzel";
        "Mod4+Shift+e" = "exec swaymsg exit";
        "XF86MonBrightnessUp" = "exec brightnessctl set 10%+";
        "XF86MonBrightnessDown" = "exec brightnessctl set 10%-";
        "XF86AudioRaiseVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
        "XF86AudioLowerVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
        "XF86AudioMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
      };
      bars = [ ];
    };
    extraConfig = ''
      exec wvkbd-mobintl
    '';
  };
}
