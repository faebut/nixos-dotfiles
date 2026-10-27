#!/usr/bin/env bash

PRIMARY_MONITOR="eDP-1"
SCALES="1 1.25 1.333333 1.5 1.6 1.666667 1.75 2 2.5 3"

menu() {
	rofi -dmenu -i -p "$1"
}

abort() {
	echo "$1" >&2
	exit 1
}

monitor() {
	hyprctl eval "hl.monitor({ $1 })"
}

MONITORS_JSON=$(hyprctl monitors all -j)

primary() {
	jq -r --arg name "${PRIMARY_MONITOR}" ".[] | select(.name == \$name) | $1" <<<"${MONITORS_JSON}"
}

secondary() {
	jq -r --arg name "${SECONDARY_MONITOR}" ".[] | select(.name == \$name) | $1" <<<"${MONITORS_JSON}"
}

CANDIDATES=$(jq -r --arg name "${PRIMARY_MONITOR}" \
	'.[] | select(.name != $name) | "\(.name)  \(.description)"' <<<"${MONITORS_JSON}")
[ -z "${CANDIDATES}" ] && abort "No secondary monitor connected"

if [ "$(wc -l <<<"${CANDIDATES}")" -eq 1 ]; then
	SECONDARY_MONITOR=$(awk '{print $1}' <<<"${CANDIDATES}")
else
	SECONDARY_MONITOR=$(menu "Monitor" <<<"${CANDIDATES}" | awk '{print $1}')
fi
[ -z "${SECONDARY_MONITOR}" ] && abort "No monitor selected"

LAYOUT=$(printf "Right\nLeft\nTop\nBottom\nMirror\nDisable\n" | menu "${SECONDARY_MONITOR} layout" |
	tr '[:upper:]' '[:lower:]')
[ -z "${LAYOUT}" ] && abort "No layout selected"

case ${LAYOUT} in
disable)
	monitor "output = \"${SECONDARY_MONITOR}\", disabled = true"
	exit 0
	;;
mirror)
	monitor "output = \"${SECONDARY_MONITOR}\", mode = \"preferred\", position = \"auto\", scale = \"auto\", mirror = \"${PRIMARY_MONITOR}\""
	exit 0
	;;
right | left | top | bottom) ;;
*) abort "Unknown layout: ${LAYOUT}" ;;
esac

PREFERRED_MODE=$(secondary '.availableModes[0]')
OTHER_MODES=$(secondary '.availableModes[1:]
	| map(capture("(?<w>[0-9]+)x(?<h>[0-9]+)@(?<r>[0-9.]+)"))
	| sort_by(-(.w | tonumber), -(.h | tonumber), -(.r | tonumber))
	| .[] | "\(.w)x\(.h)@\(.r)Hz"')
MODE=$(printf "%s (preferred)\n%s\n" "${PREFERRED_MODE}" "${OTHER_MODES}" | menu "Resolution" |
	awk '{print $1}' | sed 's/Hz$//')
[ -z "${MODE}" ] && abort "No resolution selected"

MODE_WIDTH=$(cut -d'x' -f1 <<<"${MODE}")
MODE_HEIGHT=$(cut -d'x' -f2 <<<"${MODE}" | cut -d'@' -f1)

VALID_SCALES=$(for scale in ${SCALES}; do
	awk -v w="${MODE_WIDTH}" -v h="${MODE_HEIGHT}" -v s="${scale}" 'BEGIN {
		lw = w / s; lh = h / s
		if ((lw - int(lw + 0.5))^2 < 0.0001 && (lh - int(lh + 0.5))^2 < 0.0001)
			printf "%s  (%dx%d)\n", s, int(lw + 0.5), int(lh + 0.5)
	}'
done)
SCALE=$(menu "Scale" <<<"${VALID_SCALES}" | awk '{print $1}')
[ -z "${SCALE}" ] && abort "No scale selected"

PRIMARY_X=$(primary '.x')
PRIMARY_Y=$(primary '.y')
PRIMARY_LOGICAL_WIDTH=$(primary '(.width / .scale) | round')
PRIMARY_LOGICAL_HEIGHT=$(primary '(.height / .scale) | round')
SECONDARY_LOGICAL_WIDTH=$(awk -v w="${MODE_WIDTH}" -v s="${SCALE}" 'BEGIN { printf "%d", w / s + 0.5 }')
SECONDARY_LOGICAL_HEIGHT=$(awk -v h="${MODE_HEIGHT}" -v s="${SCALE}" 'BEGIN { printf "%d", h / s + 0.5 }')

case ${LAYOUT} in
right)
	POS_X=$((PRIMARY_X + PRIMARY_LOGICAL_WIDTH))
	POS_Y=${PRIMARY_Y}
	;;
left)
	POS_X=$((PRIMARY_X - SECONDARY_LOGICAL_WIDTH))
	POS_Y=${PRIMARY_Y}
	;;
top)
	POS_X=${PRIMARY_X}
	POS_Y=$((PRIMARY_Y - SECONDARY_LOGICAL_HEIGHT))
	;;
bottom)
	POS_X=${PRIMARY_X}
	POS_Y=$((PRIMARY_Y + PRIMARY_LOGICAL_HEIGHT))
	;;
esac

monitor "output = \"${SECONDARY_MONITOR}\", mode = \"${MODE}\", position = \"${POS_X}x${POS_Y}\", scale = ${SCALE}"
