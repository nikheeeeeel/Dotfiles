#!/bin/bash
# ~/.config/waybar/scripts/media.sh
# Shows currently playing song title from playerctl (Firefox, VLC, etc.)
# Returns empty output (hides module) when nothing is playing.

PLAYER=$(playerctl -l 2>/dev/null | grep -E "firefox|vlc|chromium|brave" | head -1)

# Fall back to any available player if preferred ones aren't found
if [ -z "$PLAYER" ]; then
    PLAYER=$(playerctl -l 2>/dev/null | head -1)
fi

# No player at all — hide the module
if [ -z "$PLAYER" ]; then
    echo ""
    exit 0
fi

STATUS=$(playerctl -p "$PLAYER" status 2>/dev/null)

# Not playing or paused — hide
if [ "$STATUS" != "Playing" ]; then
    echo ""
    exit 0
fi

TITLE=$(playerctl -p "$PLAYER" metadata title 2>/dev/null)

# Empty title — hide
if [ -z "$TITLE" ]; then
    echo ""
    exit 0
fi

# Truncate long titles
MAX=30
if [ ${#TITLE} -gt $MAX ]; then
    TITLE="${TITLE:0:$MAX}…"
fi

# Output as waybar JSON so special chars are escaped safely
printf '{"text": "♪ %s", "class": "playing"}\n' "$TITLE"