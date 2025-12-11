#!/bin/bash

# Get Brightness
get_brightness() {
	brightness=$(brightnessctl g)
	echo "$brightness"
}

# Increase Brightness
inc_brightness() {
	brightnessctl set 15+
}

# Decrease Brightness
dec_brightness() {
    brightnessctl set --min-value=1 15-
}


# Execute accordingly
if [[ "$1" == "--inc" ]]; then
	inc_brightness
elif [[ "$1" == "--dec" ]]; then
	dec_brightness
fi
