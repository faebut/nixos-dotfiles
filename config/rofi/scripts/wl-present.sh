#!/bin/bash
if [[ $(pidof wl-mirror) > 0 ]]; then
  rofi -show wlpresent -modi wlpresent:~/.config/rofi/scripts/wl-present-options -theme-str 'window {width: 12em; height: 8.5em; padding: 0em 0em;} mainbox{ children: [listview];} prompt {enabled : false;} textbox-promt-colon {enabled: false;} button {enabled: false;}'
  else
wl-present mirror    
fi

