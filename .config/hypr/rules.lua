-- ~/.config/hypr/rules.lua
-- Migrated from rules.conf
-- Docs: https://wiki.hypr.land/Configuring/Basics/Window-Rules/

-- Applications are opaque by default. Transparency is limited to a small
-- allowlist of desktop utilities.
hl.window_rule({
    match = { class = ".*" },
    opacity = "1.0 override",
})

local nativeOpacity = "0.9 override"
local translucentSystemApps = "^(kitty|thunar|pavucontrol|org\\.pulseaudio\\.pavucontrol|nm-connection-editor|blueman-manager|btrfs-assistant)$"

hl.window_rule({
    match = { class = translucentSystemApps },
    opacity = nativeOpacity,
})

hl.window_rule({
    match = { class = ".*", fullscreen = true },
    opacity = "1.0 override",
})

hl.window_rule({
    name = "float-pavucontrol",
    match = { class = "^(pavucontrol)$" },
    float = true,
})

hl.window_rule({
    name = "float-nm-connection-editor",
    match = { class = "^(nm-connection-editor)$" },
    float = true,
})

hl.window_rule({
    name = "float-blueman-manager",
    match = { class = "^(blueman-manager)$" },
    float = true,
})

hl.window_rule({
    name = "float-open-file",
    match = { title = "^(Open File)$" },
    float = true,
})

hl.window_rule({
    name = "float-save-file",
    match = { title = "^(Save File)$" },
    float = true,
})
