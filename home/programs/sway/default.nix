{ lib, username, ...}:
let
  modifier = "mod4";
  menu = "fuzzel";
  terminal = "ghostty";
in
{
  imports = [ ./colors.nix ];

  wayland.windowManager.sway = {
    enable = true;
    checkConfig = false;
    xwayland = true;
    systemd.enable = true;
    config = {
      defaultWorkspace = "1";

      gaps = {
        inner = 6;
        outer = 3;
      };
      bars = [
        {
          command = "waybar";
        }
      ];
      modifier = "${modifier}";
      keybindings = 
        lib.mkOptionDefault {
          "${modifier}+t" = "exec ${terminal}";
          "${modifier}+Shift+q" = "kill";
          "${modifier}+d" = "exec ${menu}";
          "${modifier}+Shift+p" = "exec systemctl suspend";
        };
      terminal = "${terminal}";
      menu = "${menu}";
      input = {
        "*" = {
          # reverse mouse scroll
          natural_scroll = "enabled";
        };
      };
    };
    extraConfig = ''
      # Volume
      bindsym XF86AudioRaiseVolume exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
      bindsym XF86AudioLowerVolume exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
      bindsym XF86AudioMute exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle

      # Media control
      bindsym XF86AudioPlay exec playerctl play-pause
      bindsym XF86AudioPause exec playerctl pause
      bindsym XF86AudioStop exec playerctl stop
      bindsym XF86AudioNext exec playerctl next
      bindsym XF86AudioPrev exec playerctl previous
      bindsym Print exec sh -c 'FILE=~/Pictures/screen_shots/$(date +%Y.%m.%d-%H:%M:%S).png; grim -g "$(slurp)" "$FILE" && notify-send "Screen shot saved" "$FILE"'
      bindsym Shift+Print exec sh -c 'FILE=~/Pictures/screen_shots/$(date +%Y.%m.%d-%H:%M:%S).png; grim  "$FILE" && notify-send "Screen shot saved" "$FILE"'

      exec_always fcitx5
      exec env RUST_BACKTRACE=1 RUST_LOG=swayr=debug swayrd > /tmp/swayrd.log 2>&1

      # bg
      output "*" background /home/${username}/Pictures/photo/wallpapers/splatoon_10th_02.jpg fill
      
      # Remove Sway's borders and title bars for new tiled and floating windows.
      default_border none
      default_floating_border none
    '';
  };
}
