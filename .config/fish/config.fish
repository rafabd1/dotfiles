# Use CachyOS' Fish setup when the package is available. Fish keeps its
# built-in syntax highlighting and completions when this file is absent.
if test -r /usr/share/cachyos-fish-config/cachyos-config.fish
    source /usr/share/cachyos-fish-config/cachyos-config.fish
end

function fish_greeting
end
