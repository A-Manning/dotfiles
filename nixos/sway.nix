{ lib, pkgs, ... }:

{
  enable = true;
  config = {
    bars = [
      { command = "waybar"; }
    ];
    colors =
      let
        cyan = "#00ffff";
        dark-trans = "#11111144";
        darker-trans = "#11111188";
        green = "#00ff00";
        green-dim = "#008800";
        light-grey = "#888888";
        grey = "#333333";
        magenta = "#ff00ff";
        # should not occur unless something has gone wrong!
        red = "#ff0000";
        trans = "#00000000";

      in {
      focused = {
        background = dark-trans;
        border = green;
        childBorder = green;
        indicator = magenta;
        text = green;
      };
      focusedInactive = {
        #5f676a
        background = dark-trans;
        #333333 
        border = cyan;
        #5f676a
        childBorder = cyan;
        #484e50
        indicator = trans;
        #ffffff
        text = cyan;
      };
      unfocused = {
        background = darker-trans;
        border = cyan;
        # 222222
        childBorder = trans;
        indicator = trans;
        text = light-grey;
      };
    };
    floating.criteria = [
      { title = "Calculator"; }
    ];
    focus = {
      mouseWarping = false;
      newWindow = "urgent";
    };
    fonts = {
      size = 10.0;
    };
    gaps = {
      inner = 5;
      outer = 0;
      smartBorders = "off";
    };
    input = {
      "76:613:Apple_Inc._Magic_Trackpad_2" = {
        click_method = "button_areas";
        natural_scroll = "enabled";
        pointer_accel = "0.666";
      };
    };
    keybindings =
      let
        mod = "Mod1";
        sup = "Mod4";
      in
      lib.mkOptionDefault {
        # Kill
        "${sup}+q" = "kill";
        "${mod}+Shift+q" = "kill";
        # Change focus
        "${mod}+j" = "focus left";
        "${mod}+k" = "focus down";
        "${mod}+i" =  "focus up";
        "${mod}+l" =  "focus right";
        # move focused window
        "${sup}+j" = "move left";
        "${sup}+k" = "move down";
        "${sup}+i" = "move up";
        "${sup}+l" = "move right";
        "${mod}+Shift+j" = "move left";
        "${mod}+Shift+k" = "move down";
        "${mod}+Shift+i" = "move up";
        "${mod}+Shift+l" = "move right";
        # split in horizontal orientation
        "${mod}+h" = "split h";
        # split in vertical orientation
        "${mod}+v" = "split v";
        # enter fullscreen mode for the focused container
        "${mod}+f" = "fullscreen toggle";
        # change container layout (stacked, tabbed, toggle split)
        "${mod}+s" = "layout stacking";
        "${mod}+w" = "layout tabbed";
        "${mod}+e" = "layout toggle split";
        # toggle tiling / floating
        "${mod}+Shift+space" = "floating toggle";
        "${sup}+space" = "floating toggle";
        # change focus between tiling / floating windows
        "${mod}+space" = "focus mode_toggle";
        # focus the parent container
        "${mod}+a" = "focus parent";
        # switch to workspace
        "${mod}+1" = "workspace 1";
        "${mod}+2" = "workspace 2";
        "${mod}+3" = "workspace 3";
        "${mod}+4" = "workspace 4";
        "${mod}+5" = "workspace 5";
        "${mod}+6" = "workspace 6";
        "${mod}+7" = "workspace 7";
        "${mod}+8" = "workspace 8";
        "${mod}+9" = "workspace 9";
        "${mod}+0" = "workspace 10";
        # move focused container to workspace
        "${sup}+1" = "move container to workspace 1";
        "${sup}+2" = "move container to workspace 2";
        "${sup}+3" = "move container to workspace 3";
        "${sup}+4" = "move container to workspace 4";
        "${sup}+5" = "move container to workspace 5";
        "${sup}+6" = "move container to workspace 6";
        "${sup}+7" = "move container to workspace 7";
        "${sup}+8" = "move container to workspace 8";
        "${sup}+9" = "move container to workspace 9";
        "${sup}+0" = "move container to workspace 10";
        "${mod}+Shift+1" = "move container to workspace 1";
        "${mod}+Shift+2" = "move container to workspace 2";
        "${mod}+Shift+3" = "move container to workspace 3";
        "${mod}+Shift+4" = "move container to workspace 4";
        "${mod}+Shift+5" = "move container to workspace 5";
        "${mod}+Shift+6" = "move container to workspace 6";
        "${mod}+Shift+7" = "move container to workspace 7";
        "${mod}+Shift+8" = "move container to workspace 8";
        "${mod}+Shift+9" = "move container to workspace 9";
        "${mod}+Shift+0" = "move container to workspace 10";
        # reload the configuration file
        "${sup}+c" = "reload";
        "${mod}+Shift+c" = "reload";
        # reload sway inplace
        "${sup}+r" = "reload";
        "${mod}+Shift+r" = "reload";
        # wmenu
        "${mod}+d" = ''
          exec ${pkgs.dmenu}/bin/dmenu_path \
          | ${pkgs.wmenu}/bin/wmenu -i -N 000000 -n 00ff00 -S 00ff00 -s 000000 \
          | ${pkgs.findutils}/bin/xargs swaymsg exec --
        '';
        # Mute key
        "XF86AudioMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        # Volume down
        "XF86AudioLowerVolume" =
          "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
        # Volume up
        "XF86AudioRaiseVolume" =
          "exec wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+";
        # Brightness down
        "XF86MonBrightnessDown" = "exec lightctl down";
        # Brightness down
        "XF86MonBrightnessUp" = "exec lightctl up";
      };
    output =
      let bg-path =
        "~/Pictures/wallpapers/nix-wallpaper-nineish-solarized-dark.png";
      in
      {
        eDP-1 = {
          bg = bg-path + " fill";
        };
        DP-8 = {
          bg = bg-path + " fill";
        };
        DP-9 = {
          bg = bg-path + " fill";
          scale = "1.5";
        };
        DP-10 = {
          bg = bg-path + " fill";
          scale = "1.5";
        };
    };
    startup = [
      # xdg-desktop-portal-gnome is broken, do not use
      # see https://bbs.archlinux.org/viewtopic.php?id=285590
      # { command = "systemctl --user mask xdg-desktop-portal-gnome"; }
      { command = "systemctl --user import-environment XDG_SESSION_TYPE XDG_CURRENT_DESKTOP"; }
      { command = "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway"; }
      { command = "nm-applet"; }
      { command = "avizo-service"; }
      { command = "swaync"; }
    ];
    terminal = "${pkgs.wezterm}/bin/wezterm";
    window = {
      border = 1;
      commands = [
        { criteria = { class = "^.*"; }; command = "border pixel 1"; }
      ];
      # hideEdgeBorders = "--i3 smart";
      titlebar = false;
    };
    workspaceLayout = "tabbed";
  };
  extraConfig = ''
    hide_edge_borders --i3 smart
    titlebar_border_thickness 1
  '';
  extraConfigEarly = ''
    set $mod Mod1
    set $sup Mod4
  '';
  extraOptions = [ "--unsupported-gpu" ];
  extraSessionCommands = ''
    export XDG_CURRENT_DESKTOP=sway
    export WLR_DRM_DEVICES=/dev/dri/card1
  '';
  # package = pkgs.swayfx;
  wrapperFeatures.gtk = true;
}