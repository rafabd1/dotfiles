-- ~/.config/hypr/keybinds.lua
-- Migrated from keybinds.conf
-- Docs: https://wiki.hypr.land/Configuring/Basics/Binds/
--       https://wiki.hypr.land/Configuring/Basics/Dispatchers/

local home = os.getenv("HOME")
local superTapConsumed = false

local function consumeSuper(action)
    return function()
        superTapConsumed = true
        hl.dispatch(action)
    end
end

-- The Windows key opens the launcher only when tapped by itself. Tracking
-- chords here avoids the modifier-release regression in current Hyprland.
hl.bind(mainMod .. " + SUPER_L", function()
    superTapConsumed = false
end)
hl.bind(mainMod .. " + SUPER_L", function()
    if not superTapConsumed then
        hl.dispatch(hl.dsp.exec_cmd("qs -c caelestia ipc call drawers toggle launcher"))
    end
end, { release = true })

-- Launchers
hl.bind(mainMod .. " + T", consumeSuper(hl.dsp.exec_cmd(terminal)))
hl.bind(mainMod .. " + E", consumeSuper(hl.dsp.exec_cmd(fileManager)))
hl.bind(mainMod .. " + B", consumeSuper(hl.dsp.exec_cmd(browser)))

hl.bind(mainMod .. " + Q", consumeSuper(hl.dsp.window.close()))
hl.bind("SUPER + Tab", consumeSuper(hl.dsp.global("caelestia:lock")))
hl.bind(mainMod .. " + GRAVE", consumeSuper(hl.dsp.global("caelestia:session")))
hl.bind(mainMod .. " + W", consumeSuper(hl.dsp.exec_cmd("caelestia wallpaper -r")))

-- Maximise by default so browsers keep their tabs and address bar visible.
-- The shifted binding remains available for true fullscreen.
hl.bind(mainMod .. " + F", consumeSuper(hl.dsp.window.fullscreen({ mode = 1 })))
hl.bind(mainMod .. " + SHIFT + F", consumeSuper(hl.dsp.window.fullscreen({ mode = 0 })))

hl.bind(mainMod .. " + O", consumeSuper(hl.dsp.exec_cmd(home .. "/.config/hypr/scripts/opacity.sh")))

-- Mouse move/resize window
hl.bind(mainMod .. " + mouse:272", consumeSuper(hl.dsp.window.drag()), { mouse = true })
hl.bind(mainMod .. " + mouse:273", consumeSuper(hl.dsp.window.resize()), { mouse = true })

-- Caelestia panels
hl.bind(mainMod .. " + SHIFT + W", consumeSuper(hl.dsp.global("caelestia:showall")))
hl.bind(mainMod .. " + N", consumeSuper(hl.dsp.global("caelestia:sidebar")))

-- Clipboard
hl.bind(mainMod .. " + V", consumeSuper(hl.dsp.exec_cmd("pkill fuzzel || caelestia clipboard")))

-- Screenshots
hl.bind(mainMod .. " + Delete", consumeSuper(hl.dsp.exec_cmd("caelestia screenshot")))
hl.bind("Delete", hl.dsp.exec_cmd("caelestia screenshot -r"))

-- Keyboard layout
hl.bind(mainMod .. " + X", consumeSuper(hl.dsp.exec_cmd("hyprctl switchxkblayout all next")))

-- Toggle float window, center and rezise
hl.bind(mainMod .. " + Space", function()
    superTapConsumed = true
    hl.dispatch(hl.dsp.window.float({ action = "toggle" }))

    local w = hl.get_active_window()
    if w ~= nil and w.floating then
        local mon = hl.get_active_monitor()
        if mon ~= nil then
            local target_w = math.floor(mon.width * 0.7) 
            local target_h = math.floor(mon.height * 0.7)

            -- absolute resize (relative = false), not a delta
            hl.dispatch(hl.dsp.window.resize({ x = target_w, y = target_h, relative = false }))

            local mon_x = mon.x or 0
            local mon_y = mon.y or 0
            local target_x = mon_x + math.floor((mon.width - target_w) / 2)
            local target_y = mon_y + math.floor((mon.height - target_h) / 2)

            -- absolute move to the centered position
            hl.dispatch(hl.dsp.window.move({ x = target_x, y = target_y, relative = false }))
        end
    end
end)

-- Screen recording. The command toggles recording and avoids a fixed monitor name.
hl.bind(mainMod .. " + R", consumeSuper(hl.dsp.exec_cmd("caelestia record -s")))

-- Zoom
local function zoomfunction(value)
    superTapConsumed = true
    local zoomvalue = hl.get_config("cursor:zoom_factor")
    if (zoomvalue + value) > 1.5 then
        hl.config({ cursor = { zoom_factor = 1.5 } })
    elseif (zoomvalue + value) < 1.0 then
        hl.config({ cursor = { zoom_factor = 1.0 } })
    else
        hl.config({ cursor = { zoom_factor = zoomvalue + value } })
    end
end
hl.bind(mainMod .. " + mouse_down", function() zoomfunction(-0.5) end, { repeating = true })
hl.bind(mainMod .. " + mouse_up", function() zoomfunction(0.5) end, { repeating = true })

--# Zoom with keypad
hl.bind(mainMod .. " + code:82", function() zoomfunction(-0.3) end, { repeating = true })
hl.bind(mainMod .. " + code:86", function() zoomfunction(0.3) end, { repeating = true })

-- VERIFY: exit dispatcher. Docs explicitly say to double check the exit
-- dispatcher call when moving to Lua.
hl.bind(mainMod .. " + SHIFT + E", consumeSuper(hl.dsp.exit()))

-- Focus (H/J/K/L = left/down/up/right, vim-style, matching your original)
hl.bind(mainMod .. " + H", consumeSuper(hl.dsp.focus({ direction = "left" })))
hl.bind(mainMod .. " + J", consumeSuper(hl.dsp.focus({ direction = "down" })))
hl.bind(mainMod .. " + K", consumeSuper(hl.dsp.focus({ direction = "up" })))
hl.bind(mainMod .. " + L", consumeSuper(hl.dsp.focus({ direction = "right" })))

-- VERIFY: move active window within layout (old `movewindow` dispatcher).
-- Confirmed pattern is hl.dsp.window.move({ workspace = N }) for sending to a
-- workspace (used below) - the direction-swap variant isn't shown in the
-- official example, so double check this fires like the old movewindow did.
hl.bind(mainMod .. " + SHIFT + H", consumeSuper(hl.dsp.window.move({ direction = "left" })))
hl.bind(mainMod .. " + SHIFT + J", consumeSuper(hl.dsp.window.move({ direction = "down" })))
hl.bind(mainMod .. " + SHIFT + K", consumeSuper(hl.dsp.window.move({ direction = "up" })))
hl.bind(mainMod .. " + SHIFT + L", consumeSuper(hl.dsp.window.move({ direction = "right" })))

-- VERIFY: resize active window by pixel delta (old `resizeactive`, repeating
-- while held via `binde`). Param names guessed as x/y - confirm with hyprctl eval.
hl.bind(mainMod .. " + CTRL + H", consumeSuper(hl.dsp.window.resize({ x = -40, y = 0 })), { repeating = true })
hl.bind(mainMod .. " + CTRL + L", consumeSuper(hl.dsp.window.resize({ x = 40, y = 0 })), { repeating = true })
hl.bind(mainMod .. " + CTRL + K", consumeSuper(hl.dsp.window.resize({ x = 0, y = -40 })), { repeating = true })
hl.bind(mainMod .. " + CTRL + J", consumeSuper(hl.dsp.window.resize({ x = 0, y = 40 })), { repeating = true })

-- Workspaces 1-10, and move-to-workspace with SHIFT (confirmed pattern from
-- the official example config)
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key, consumeSuper(hl.dsp.focus({ workspace = i })))
    hl.bind(mainMod .. " + SHIFT + " .. key, consumeSuper(hl.dsp.window.move({ workspace = i })))
end

-- Media keys (confirmed pattern from the official example config)
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })

hl.bind("XF86AudioPlay", hl.dsp.global("caelestia:mediaToggle"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.global("caelestia:mediaNext"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.global("caelestia:mediaPrev"), { locked = true })

hl.bind("XF86MonBrightnessUp", hl.dsp.global("caelestia:brightnessUp"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.global("caelestia:brightnessDown"), { locked = true, repeating = true })
