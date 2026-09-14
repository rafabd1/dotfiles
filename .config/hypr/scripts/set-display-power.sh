#!/usr/bin/env bash

set -u

state="${1:-}"
[[ "$state" == "ac" || "$state" == "battery" ]] || exit 2
command -v hyprctl >/dev/null 2>&1 || exit 0
command -v jq >/dev/null 2>&1 || exit 0

monitor_json="$(hyprctl -j monitors all 2>/dev/null)" || exit 0
monitor="$(jq -c '[.[] | select(.name | startswith("eDP"))][0] // empty' <<<"$monitor_json")"
[[ -n "$monitor" ]] || exit 0

name="$(jq -r '.name' <<<"$monitor")"
x="$(jq -r '.x' <<<"$monitor")"
y="$(jq -r '.y' <<<"$monitor")"
scale="$(jq -r '.scale' <<<"$monitor")"

if [[ "$state" == "ac" ]]; then
    hyprctl eval "hl.monitor({ output = \"$name\", mode = \"preferred\", position = \"${x}x${y}\", scale = $scale })" >/dev/null
    exit 0
fi

resolution="$(jq -r '"\(.width)x\(.height)"' <<<"$monitor")"
mode="$({
    jq -r '.availableModes[]' <<<"$monitor" \
        | awk -v resolution="$resolution" '
            index($0, resolution "@") == 1 {
                split($0, fields, "@")
                rate = fields[2]
                sub(/Hz$/, "", rate)
                if ((rate + 0) <= 61) print rate "|" $0
            }
        ' \
        | sort -t '|' -k1,1nr \
        | head -n 1 \
        | cut -d '|' -f 2- \
        | sed 's/Hz$//'
} 2>/dev/null)"

[[ -n "$mode" ]] || exit 0
hyprctl eval "hl.monitor({ output = \"$name\", mode = \"$mode\", position = \"${x}x${y}\", scale = $scale })" >/dev/null
