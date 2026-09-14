#!/usr/bin/env bash

set -u

found=0

for vendor_file in /sys/bus/pci/devices/*/vendor; do
    [[ -r "$vendor_file" ]] || continue
    [[ "$(<"$vendor_file")" == "0x10de" ]] || continue

    device_dir="${vendor_file%/vendor}"
    class="$(<"$device_dir/class")"
    [[ "$class" == 0x03* ]] || continue

    found=1
    address="${device_dir##*/}"
    control="$(<"$device_dir/power/control")"
    status="$(<"$device_dir/power/runtime_status")"
    printf 'NVIDIA %s: control=%s runtime_status=%s\n' "$address" "$control" "$status"
done

if [[ "$found" -eq 0 ]]; then
    printf 'No NVIDIA display controller found.\n'
fi
