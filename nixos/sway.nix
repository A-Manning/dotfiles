{ lib, ... }:

{
  enable = true;
  config = {
    bars = [
      { command = "waybar"; }
    ];
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
        # reload sway inplace (preserves your layout/session, can be used to upgrade i3)
        "${sup}+r" = "reload";
        "${mod}+Shift+r" = "reload";
      };
    startup = [
      # xdg-desktop-portal-gnome is broken, do not use
      # see https://bbs.archlinux.org/viewtopic.php?id=285590
      # { command = "systemctl --user mask xdg-desktop-portal-gnome"; }
      { command = "systemctl --user import-environment XDG_SESSION_TYPE XDG_CURRENT_DESKTOP"; }
      { command = "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway"; }
      { command = "nm-applet"; }
    ];
    window = {
      # hideEdgeBorders = "--i3 smart";
      titlebar = false;
    };
    workspaceLayout = "tabbed";
  };
  extraConfig = ''
    hide_edge_borders --i3 smart
  '';
  extraConfigEarly = ''
    set $mod Mod1
    set $sup Mod4
  '';
  extraSessionCommands = ''
    export XDG_CURRENT_DESKTOP=sway
  '';
  wrapperFeatures.gtk = true;
}