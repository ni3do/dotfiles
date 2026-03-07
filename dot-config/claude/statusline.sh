#!/bin/bash
# Enhanced statusline for Claude Code
# Shows: directory, git branch & status, model name, context usage, session time, and message count

# Read JSON input from stdin
input=$(cat)

# Extract values from JSON
cwd=$(echo "$input" | jq -r '.workspace.current_dir')
model=$(echo "$input" | jq -r '.model.display_name')
transcript=$(echo "$input" | jq -r '.transcript_path')

# Shorten directory path (replace $HOME with ~)
short_dir="${cwd/#$HOME/\~}"

# Get context percentage - use accurate value from Claude Code 2.1.6+, fallback to improved estimation
pct=$(echo "$input" | jq -r 'if .context_window.used_percentage then (.context_window.used_percentage | floor) else empty end')
if [ -z "$pct" ]; then
    # Fallback for Claude Code < 2.1.6: improved estimation from transcript file size
    if [ -f "$transcript" ]; then
        chars=$(wc -c < "$transcript" 2>/dev/null || echo 0)
        # Better char/token ratio (3.5) with system overhead buffer (~15k tokens)
        estimated_tokens=$(( (chars * 2 / 7) + 15000 ))
        pct=$(( estimated_tokens * 100 / 200000 ))
    else
        pct=0
    fi
fi

# Context usage with bar gauge
ctx=""
if [ -n "$pct" ] && [ "$pct" -ge 0 ] 2>/dev/null; then
    # Clamp to 0-100 range
    [ "$pct" -gt 100 ] 2>/dev/null && pct=100

    # Color code based on percentage
    if [ $pct -ge 80 ]; then
        cc="\033[38;5;203m"  # Red for 80%+
    elif [ $pct -ge 60 ]; then
        cc="\033[38;5;221m"  # Yellow for 60-79%
    else
        cc="\033[38;5;108m"  # Green for <60%
    fi

    # Create bar gauge (10 segments, each representing 10%)
    bar_width=10
    filled=$((pct / 10))
    [ $filled -gt 10 ] && filled=10
    empty=$((bar_width - filled))

    # Build the bar with filled and empty segments
    bar=""
    for ((i=0; i<filled; i++)); do
        bar="${bar}█"
    done
    for ((i=0; i<empty; i++)); do
        bar="${bar}░"
    done

    ctx=" ${cc}[${bar}] ${pct}%\033[0m"
fi

# Calculate session uptime from transcript file creation time
session_time=""
if [ -f "$transcript" ]; then
    # Get file creation time (or modification time as fallback)
    if stat --version 2>/dev/null | grep -q GNU; then
        # GNU stat (Linux)
        start_time=$(stat -c %W "$transcript" 2>/dev/null)
        [ "$start_time" = "0" ] && start_time=$(stat -c %Y "$transcript" 2>/dev/null)
    else
        # BSD stat (macOS)
        start_time=$(stat -f %B "$transcript" 2>/dev/null || stat -f %m "$transcript" 2>/dev/null)
    fi

    if [ -n "$start_time" ] && [ "$start_time" -gt 0 ] 2>/dev/null; then
        now=$(date +%s)
        elapsed=$((now - start_time))

        hours=$((elapsed / 3600))
        mins=$(((elapsed % 3600) / 60))

        if [ $hours -gt 0 ]; then
            session_time="${hours}h${mins}m"
        else
            session_time="${mins}m"
        fi
    fi
fi

# Count messages in transcript (JSONL format)
msg_count=""
if [ -f "$transcript" ]; then
    # Count user messages - each line with "type":"user" is a user turn
    human_msgs=$(grep -c '"type":"user"' "$transcript" 2>/dev/null || echo 0)
    if [ "$human_msgs" -gt 0 ]; then
        msg_count="${human_msgs}"
    fi
fi

# Get git information if in a git repository
git_info=""
if git -C "$cwd" --no-optional-locks -c core.useBuiltinFSMonitor=false rev-parse --git-dir >/dev/null 2>&1; then
    branch=$(git -C "$cwd" --no-optional-locks -c core.useBuiltinFSMonitor=false branch --show-current 2>/dev/null)

    if [ -n "$branch" ]; then
        # Count different types of changes
        status=$(git -C "$cwd" --no-optional-locks -c core.useBuiltinFSMonitor=false status --porcelain 2>/dev/null)
        staged=0
        modified=0
        deleted=0
        untracked=0

        while IFS= read -r line; do
            [ -z "$line" ] && continue

            index="${line:0:1}"
            worktree="${line:1:1}"

            # Check for staged changes
            case "$index$worktree" in
                A\ *|M\ *|C\ *|R\ *) staged=$((staged+1));;
            esac

            # Check for modified files
            case "$worktree" in
                M) modified=$((modified+1));;
                D) deleted=$((deleted+1));;
            esac

            # Check for untracked files
            [ "$index" = "?" ] && [ "$worktree" = "?" ] && untracked=$((untracked+1))
        done <<< "$status"

        # Build changes summary with color coding
        changes=""
        [ $staged -gt 0 ] && changes="$changes \033[38;5;108m+$staged\033[0m"      # Green
        [ $modified -gt 0 ] && changes="$changes \033[38;5;221m~$modified\033[0m"  # Yellow
        [ $deleted -gt 0 ] && changes="$changes \033[38;5;203m-$deleted\033[0m"    # Red
        [ $untracked -gt 0 ] && changes="$changes \033[38;5;147m?$untracked\033[0m" # Blue

        git_info=" \033[38;5;183mon \033[38;5;183m\033[1m$branch\033[0m$changes"
    fi
fi

# Build session info with clear labels
session_info=""
if [ -n "$session_time" ] || [ -n "$msg_count" ]; then
    parts=""
    # Clock symbol for time
    [ -n "$session_time" ] && parts="⏱️ ${session_time}"
    # Message symbol for count
    [ -n "$msg_count" ] && parts="${parts:+$parts  }💬 ${msg_count}"
    session_info=" \033[38;5;245m$parts\033[0m"
fi

# Output formatted statusline
printf "%b" "\033[38;5;147m\033[1m$short_dir\033[0m \033[38;5;108m\033[1m➜\033[0m$git_info  \033[38;5;147m$model\033[0m$session_info$ctx"
