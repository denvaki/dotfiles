#!/bin/bash

PRIMARY_DIPSPLAY=$(xrandr | grep -w "connected" | grep -w "primary" | cut -d' ' -f1)
output=$(zenity --list --title="Choose monitor to connect" --column='Port' $(xrandr | grep -w "connected" | grep -v "primary" | cut -d' ' -f1))
[[ -z "${output}" ]] && exit 0;
position=$(zenity --list --title="Choose position relativly to primary display" --column='Position' left-of right-of above below)
[[ -z "${position}" ]] && exit 0;
xrandr --auto
xrandr --output  ${output} --auto "--${position}" ${PRIMARY_DIPSPLAY}
leftwm-command SoftReload
