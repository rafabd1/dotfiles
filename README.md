# CachyOS + Hyprland + Caelestia

Hyprland setup for CachyOS focused on development, security work and good
battery life on a hybrid AMD/NVIDIA laptop.

[Caelestia Shell](https://github.com/caelestia-dots/shell) provides the bar,
launcher, notifications, OSD, lock screen, session menu, dashboard and wallpaper
picker. The setup keeps Brave, Kitty with Fish, Thunar and the existing Hyprland
window workflow.

## Main features

- Caelestia as the only desktop shell
- Wallpaper-based Material You colours in Caelestia, Hyprland and Kitty
- Fast spatial animations without elastic overshoot or panel deformation
- Fish syntax highlighting, autosuggestions and completions
- Brave as the default browser
- Brazilian ABNT2 keyboard by default, with US International as secondary
- No automatic session lock; the display still turns off after five idle minutes
- 60 Hz internal display on battery and preferred refresh rate on AC
- NVIDIA Runtime D3 and no background NVIDIA polling
- CachyOS power profiles: balanced on battery and the fastest profile exposed by the firmware on AC

The wallpapers in `Wallpapers/` are copied to `~/Pictures/Wallpapers`, the
default folder used by Caelestia. The installer keeps a valid wallpaper already
selected by Caelestia. Otherwise, it selects the first compatible image it
finds in that folder.

Caelestia extracts a dynamic palette from the active wallpaper. Its custom Kitty
template is written to `~/.local/state/caelestia/theme/kitty.conf`; open Kitty
windows reload when the palette changes. This changes terminal colours only.
Fish remains responsible for command syntax highlighting.

The session never locks automatically. After five idle minutes the display
turns off and wakes without a password. `Super + Tab` still locks it manually.

## Keybinds

`Super` is the Windows key.

| Keybind | Action |
| --- | --- |
| `Super + T` | Open Kitty |
| `Super` | Open the Caelestia launcher when tapped by itself |
| `Super + E` | Open Thunar |
| `Super + B` | Open Brave |
| `Super + W` | Pick another random wallpaper |
| `Super + Shift + W` | Show or hide all Caelestia panels |
| `Super + N` | Open the Caelestia sidebar |
| `Super + V` | Open clipboard history |
| `Super + O` | Switch window opacity |
| `Super + X` | Switch keyboard layout |
| `Super + Tab` | Lock the session |
| `Super + Grave` | Open the session menu |
| `Super + R` | Start or stop screen recording with audio |
| `Super + Q` | Close the active window |
| `Super + F` | Maximise without hiding browser controls |
| `Super + Shift + F` | Toggle true fullscreen |
| `Super + Space` | Toggle floating mode |
| `Super + H/J/K/L` | Move focus left/down/up/right |
| `Super + Shift + H/J/K/L` | Move the active window |
| `Super + Ctrl + H/J/K/L` | Resize the active window |
| `Super + 1..0` | Switch to workspace 1..10 |
| `Super + Shift + 1..0` | Send a window to workspace 1..10 |
| `Super + Delete` | Capture the full screen |
| `Delete` | Select and capture a region |
| `Super + mouse wheel` | Zoom the desktop |

For the visual wallpaper picker, open the launcher and enter `>wallpaper`.
To select the dynamic colour scheme again, enter `>scheme` or run:

```bash
caelestia scheme set -n dynamic
```

## Installation

The installer targets Arch-based systems and installs official and AUR packages
with `pacman` plus `paru` or `yay`. If neither AUR helper exists, it tries to
build `yay` first.

```bash
git clone https://github.com/rafabd1/dotfiles.git
cd dotfiles
chmod +x install.sh
./install.sh
```

Existing configuration folders replaced by this repository are copied to a
timestamped directory under `~/.config-backups/`. Log out and back into
Hyprland after installation.

## Hybrid GPU and battery

On a detected Acer Nitro with AMD and NVIDIA graphics, the installer also:

- installs Power Profiles Daemon and Powertop;
- applies `balanced` on battery and `performance` on AC when the firmware exposes it, otherwise it keeps `balanced`;
- configures the NVIDIA GPU for Runtime D3 suspend;
- switches the internal display to 60 Hz on battery;
- disables Caelestia GPU monitoring so its dashboard does not wake the GTX.

Reboot once after installation, then check the NVIDIA state without querying it
through `nvidia-smi`:

```bash
~/.config/hypr/scripts/nvidia-power-status.sh
```

With no NVIDIA workload running, `runtime_status=suspended` is the expected
result. Applications can wake the dedicated GPU when needed; it should suspend
again after they exit.

Use Powertop for measurement only. Its automatic tuning can overwrite settings
managed by the active power profile.

## Notes

- `gpuType` is set to `None` and the GPU card is hidden from Caelestia's
  dashboard to avoid periodic NVIDIA probes.
- Adaptive Chromium theming is disabled, so Brave keeps its own selected theme
  and does not receive a managed browser policy.
- GTK and Qt theme rewriting is disabled. Caelestia and the terminal still
  follow the wallpaper without taking over unrelated application settings.
