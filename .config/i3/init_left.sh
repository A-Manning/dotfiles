#!/bin/sh

# sleep 1
# i3-msg focus output HDMI-A-0 && \
#     i3-msg layout toggle split && \
#     gnome-terminal && \
#     i3-msg split vertical && \
#     telegram && \
#     i3-msg layout tabbed

    # i3-msg focus up

sleep 1
i3-msg focus output HDMI-A-0
i3-msg layout toggle split
i3-msg exec gnome-terminal
sleep 1
i3-msg split vertical
i3-msg exec telegram
sleep 1
i3-msg focus up
i3-msg split horizontal
i3-msg layout tabbed
i3-msg focus down
i3-msg split horizontal
i3-msg layout tabbed
i3-msg exec qbittorrent
sleep 1
i3-msg focus left
i3-msg focus parent
i3-msg focus parent
i3-msg split horizontal
i3-msg exec chromium-browser
sleep 0.5
i3-msg split horizontal
i3-msg layout tabbed
