# Helpers for working with tmux windows.

tmux_rename_window() {
    if [[ -z "$TMUX" ]]; then
        printf 'tmux_rename_window: not inside a tmux session\n' >&2
        return 1
    fi
    if ! command -v tmux >/dev/null 2>&1; then
        printf 'tmux_rename_window: tmux command not found\n' >&2
        return 1
    fi

    local name="$*"
    if [[ -z "$name" ]]; then
        if command -v git >/dev/null 2>&1 && git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
            name="$(git rev-parse --show-toplevel 2>/dev/null)"
            name="${name##*/}"
        fi
        if [[ -z "$name" ]]; then
            name="${PWD##*/}"
        fi
        if [[ -z "$name" ]]; then
            name="shell"
        fi
    fi

    # Keep the window name concise and safe for tmux.
    name="${name// /-}"
    name="${name//[^A-Za-z0-9._-]/}"
    if (( ${#name} > 15 )); then
        name="${name:0:15}"
    fi

    tmux rename-window "$name"
}

alias trename='tmux_rename_window'
