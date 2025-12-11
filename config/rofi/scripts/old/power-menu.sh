#!/bin/bash

rofi -show p -modi p:'~/.config/rofi/scripts/rofi-power-menu --symbols-font "JetBrains Mono NF" --choices=lockscreen/suspend/hibernate/shutdown/reboot/logout' -font "JetBrains Mono NF 16" -theme-str 'window {width: 12em; height: 11.2em; padding: 0em 0em; } mainbox{ children: [listview];} listview {lines: 6; columns: 1;} button {enabled: false;}' --protocol layer-shell
