#!/usr/bin/env bash

set -u

runtime_dir="${XDG_RUNTIME_DIR:-/tmp}"
lock_file="$runtime_dir/43pr-power-watch.lock"
exec 9>"$lock_file"
flock -n 9 || exit 0

power_state() {
    local supply type online
    local mains_found=false

    for supply in /sys/class/power_supply/*; do
        [[ -r "$supply/type" && -r "$supply/online" ]] || continue
        type="$(<"$supply/type")"
        [[ "$type" == "Mains" || "$type" == "USB" || "$type" == "USB_C" ]] || continue
        mains_found=true
        online="$(<"$supply/online")"
        if [[ "$online" == "1" ]]; then
            printf 'ac\n'
            return
        fi
    done

    [[ "$mains_found" == true ]] && printf 'battery\n' || printf 'unknown\n'
}

last_state=""

while hyprctl version >/dev/null 2>&1; do
    current_state="$(power_state)"

    if [[ "$current_state" != "unknown" && "$current_state" != "$last_state" ]]; then
        if command -v powerprofilesctl >/dev/null 2>&1; then
            if [[ "$current_state" == "ac" ]]; then
                powerprofilesctl set performance >/dev/null 2>&1 || powerprofilesctl set balanced >/dev/null 2>&1 || true
            else
                powerprofilesctl set balanced >/dev/null 2>&1 || true
            fi
        fi

        "$HOME/.config/hypr/scripts/set-display-power.sh" "$current_state"
        last_state="$current_state"
    fi

    sleep 15
done
