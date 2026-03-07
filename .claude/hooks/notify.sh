#!/bin/bash

# Claude Code notification hook for Ghostty terminal
# Supports both OSC sequences and macOS native notifications

# Read notification input from stdin
input=$(cat)
message=$(echo "$input" | jq -r '.message // "Claude Code notification"')
notification_type=$(echo "$input" | jq -r '.notification_type // "unknown"')

# Send OSC 9 notification sequence (works in Ghostty and many modern terminals)
# This will show a system notification via the terminal emulator
printf '\033]9;%s\007' "$message"

# Alternative: Use macOS native notification via osascript
# Uncomment the line below if you prefer native notifications
# osascript -e "display notification \"$message\" with title \"Claude Code\" subtitle \"$notification_type\""

# Optional: Log notifications for debugging
# echo "[$(date)] [$notification_type] $message" >> "$HOME/.claude/notifications.log"

exit 0
