-- ~/.config/hypr/hyprland.lua
-- Docs: https://wiki.hypr.land/Configuring/Start/

local scheme_ok, scheme = pcall(require, "scheme.current")
if not scheme_ok then
    scheme = {
        primary = "82dccc",
        onSurfaceVariant = "798bb2",
    }
end

---- MY PROGRAMS ----

mainMod    = "SUPER"
terminal   = "kitty"
fileManager = "thunar"
browser    = "brave"


---- AUTOSTART ----

hl.on("hyprland.start", function()
    hl.exec_cmd("caelestia shell -d")
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
    hl.exec_cmd("/usr/lib/polkit-kde-authentication-agent-1")
    hl.exec_cmd(os.getenv("HOME") .. "/.config/hypr/scripts/power-watch.sh")
end)

---- ENVIRONMENT VARIABLES ----

hl.env("XCURSOR_SIZE", "14")
hl.env("QT_QPA_PLATFORM", "wayland")
hl.env("MOZ_ENABLE_WAYLAND", "1")

---- INPUT ----

hl.config({
    input = {
        -- Brazilian ABNT2 is the default layout. US International is the
        -- secondary layout and can be selected with Super+X.
        kb_model = "abnt2",
        kb_layout = "br,us",
        kb_variant = "abnt2,intl",
        kb_options = "grp:alt_shift_toggle",
        follow_mouse = 1,
        sensitivity = 0.5,
        touchpad = {
            natural_scroll = false,
            tap_to_click = true,
        },
    },
})

---- LOOK AND FEEL ----

hl.config({ render = { expand_undersized_textures = false}})
hl.config({
    general = {
        gaps_in = 3,
        gaps_out = 3,
        border_size = 1,
        col = {
            active_border = "rgba(" .. scheme.primary .. "e6)",
            inactive_border = "rgba(" .. scheme.onSurfaceVariant .. "22)",
        },
        resize_on_border = true,
        allow_tearing = false,
        layout = "dwindle",
    },
    decoration = {
        rounding = 8,
        blur = {
            enabled = true,
            size = 5,
            passes = 1,
            vibrancy = 0.2,
        },
        shadow = {
            enabled = true,
            range = 8,
            render_power = 3,
        },
    },
    animations = {
        enabled = true,
    },
})

-- Standard cubic ease-out: keeps the opening motion, but reaches the final
-- position smoothly instead of snapping during the last frames.
hl.curve("easeOut", { type = "bezier", points = { {0.33, 1.0}, {0.68, 1.0} } })

hl.animation({ leaf = "windows",    enabled = true, speed = 5, bezier = "easeOut" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 5, bezier = "easeOut" })
hl.animation({ leaf = "border",     enabled = true, speed = 5, bezier = "default" })
hl.animation({ leaf = "fade",       enabled = true, speed = 4, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 7, bezier = "easeOut", style = "slidefade" })

-- LAYOUT
hl.config({
    dwindle = { preserve_split = true },
})
hl.config({
    master = { new_status = "master" },
})

-- MISC
hl.config({
    misc = {
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
    },
})

---- SPLIT-OUT FILES ----

require("monitors")
require("keybinds")
require("rules")

local ok, err = pcall(require, "hyprland-gui")
if not ok then
    print("hyprland-gui not found, skipping (install HyprMod to enable it)")
end
