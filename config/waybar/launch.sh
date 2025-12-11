#!/bin/sh
#
# waybar startup script

kill $(pidof waybar)

waybar 
