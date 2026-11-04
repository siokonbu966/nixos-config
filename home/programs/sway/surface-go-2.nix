{ pkgs, ... }:
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
        "Mod4+t" = "exec foot";
        "Mod4+space" = "exec fuzzel";
        "Mod4+Shift+e" = "exec swaymsg exit";
        "Ctrl+Alt+Delete" = "exec swaymsg exit";

        # Focus windows (matching niri where Sway has an equivalent).
        "Mod4+q" = "kill";
        "Mod4+Alt+l" = "exec swaylock";
        "Mod4+Left" = "focus left";
        "Mod4+k" = "focus left";
        "Mod4+h" = "focus left";
        "Mod4+Down" = "focus down";
        "Mod4+j" = "focus down";
        "Mod4+Up" = "focus up";
        "Mod4+Right" = "focus right";
        "Mod4+s" = "focus right";
        "Mod4+l" = "focus right";

        # Move windows.
        "Mod4+Ctrl+Left" = "move left";
        "Mod4+Ctrl+h" = "move left";
        "Mod4+Ctrl+Down" = "move down";
        "Mod4+Ctrl+j" = "move down";
        "Mod4+Ctrl+Up" = "move up";
        "Mod4+Ctrl+k" = "move up";
        "Mod4+Ctrl+Right" = "move right";
        "Mod4+Ctrl+l" = "move right";

        # Focus outputs and move windows between them.
        "Mod4+Shift+comma" = "focus output left";
        "Mod4+Shift+j" = "focus output down";
        "Mod4+Shift+k" = "focus output up";
        "Mod4+Shift+period" = "focus output right";
        "Mod4+Shift+Ctrl+Left" = "move container to output left";
        "Mod4+Shift+Ctrl+h" = "move container to output left";
        "Mod4+Shift+Ctrl+Down" = "move container to output down";
        "Mod4+Shift+Ctrl+j" = "move container to output down";
        "Mod4+Shift+Ctrl+Up" = "move container to output up";
        "Mod4+Shift+Ctrl+k" = "move container to output up";
        "Mod4+Shift+Ctrl+Right" = "move container to output right";
        "Mod4+Shift+Ctrl+l" = "move container to output right";

        # Navigate and move windows between numbered workspaces.
        "Mod4+g" = "workspace prev";
        "Mod4+d" = "workspace next";
        "Mod4+Ctrl+g" = "move container to workspace prev";
        "Mod4+Ctrl+d" = "move container to workspace next";
        "Mod4+1" = "workspace number 1";
        "Mod4+2" = "workspace number 2";
        "Mod4+3" = "workspace number 3";
        "Mod4+4" = "workspace number 4";
        "Mod4+5" = "workspace number 5";
        "Mod4+6" = "workspace number 6";
        "Mod4+7" = "workspace number 7";
        "Mod4+8" = "workspace number 8";
        "Mod4+9" = "workspace number 9";
        "Mod4+Ctrl+1" = "move container to workspace number 1";
        "Mod4+Ctrl+2" = "move container to workspace number 2";
        "Mod4+Ctrl+3" = "move container to workspace number 3";
        "Mod4+Ctrl+4" = "move container to workspace number 4";
        "Mod4+Ctrl+5" = "move container to workspace number 5";
        "Mod4+Ctrl+6" = "move container to workspace number 6";
        "Mod4+Ctrl+7" = "move container to workspace number 7";
        "Mod4+Ctrl+8" = "move container to workspace number 8";
        "Mod4+Ctrl+9" = "move container to workspace number 9";

        # Resize, fullscreen, floating, and tabbed layout.
        "Mod4+minus" = "resize shrink width 10 ppt";
        "Mod4+equal" = "resize grow width 10 ppt";
        "Mod4+Shift+minus" = "resize shrink height 10 ppt";
        "Mod4+Shift+equal" = "resize grow height 10 ppt";
        "Mod4+f" = "resize set width 100 ppt";
        "Mod4+Shift+f" = "fullscreen toggle";
        "Mod4+v" = "floating toggle";
        "Mod4+Shift+v" = "focus mode_toggle";
        "Mod4+w" = "layout toggle tabbed";

        "XF86MonBrightnessUp" = "exec brightnessctl set 10%+";
        "XF86MonBrightnessDown" = "exec brightnessctl set 10%-";
        "XF86AudioRaiseVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
        "XF86AudioLowerVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
        "XF86AudioMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        "XF86AudioMicMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
        "XF86AudioPlay" = "exec playerctl play-pause";
        "XF86AudioPause" = "exec playerctl pause";
        "XF86AudioStop" = "exec playerctl stop";
        "XF86AudioNext" = "exec playerctl next";
        "XF86AudioPrev" = "exec playerctl previous";
      };
      bars = [ ];
    };
    extraConfig = ''
      exec wvkbd-mobintl
    '';
  };

  home.packages = [ pkgs.swaylock ];
}
