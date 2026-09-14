#!/usr/bin/env bash

# Kitty reloads its configuration on SIGUSR1. This updates existing windows
# without enabling Kitty remote control.
pkill -USR1 -x kitty 2>/dev/null || true
