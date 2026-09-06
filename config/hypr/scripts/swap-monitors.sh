#!/bin/bash

external=$(hyprctl monitors -j | jq -r '.[].name' | grep -v '^eDP-1$' | head -1)

if [ -z "$external" ]; then
    exit 0
fi

hyprctl dispatch "hl.dsp.workspace.swap_monitors({monitor1=\"eDP-1\", monitor2=\"$external\"})"
