-- Caelestia writes this module whenever the wallpaper palette changes.
local scheme_ok, scheme = pcall(require, "scheme.current")
if not scheme_ok then
    scheme = {
        primary = "82dccc",
        secondary = "00aa84",
        tertiary = "01ccff",
        surface = "111826",
        onSurface = "ffffff",
        onSurfaceVariant = "798bb2",
    }
end

CACHYLGREEN = "rgba(" .. scheme.primary .. "ff)"
CACHYMGREEN = "rgba(" .. scheme.secondary .. "ff)"
CACHYDGREEN = "rgba(" .. scheme.secondary .. "cc)"
CACHYLBLUE  = "rgba(" .. scheme.tertiary .. "ff)"
CACHYMBLUE  = "rgba(" .. scheme.primary .. "cc)"
CACHYDBLUE  = "rgba(" .. scheme.surface .. "ff)"
CACHYWHITE  = "rgba(" .. scheme.onSurface .. "ff)"
CACHYGREY   = "rgba(" .. scheme.onSurfaceVariant .. "ff)"
CACHYGRAY   = "rgba(" .. scheme.onSurfaceVariant .. "ff)"
