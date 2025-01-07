# Source zsh plugins
source /run/current-system/sw/share/zsh/plugins/nix/nix-zsh-completions.plugin.zsh

# Aliases for common dirs
alias home="cd ~"

# System Aliases
alias ..="cd .."
alias x="exit"
alias vi="nvim"

alias mm="micromamba"
# Git Aliases
alias add="git add"
alias commit="git commit"
alias pull="git pull"
alias gss="git status --short"
alias stat="git status"
alias gdiff="git diff HEAD"
alias vdiff="git difftool HEAD"
alias log="git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias push="git push"
alias g="lazygit"
alias gaa="git add ."
alias gac="git add .; git commit -m 'auto-commit'; git push"
alias gacpp="git add .; git commit -m 'auto-commit'; git push; ssh disco-world 'cd /itet-stor/siwachte/net_scratch/fingnn && git pull'"

# Keybinding Aliases
alias helpskhd="cat ~/.config/skhd/skhdrc"
alias helpyabai="cat ~/.config/yabai/yabairc"

# Starship
eval "$(starship init zsh)"

alias ssh="TERM=xterm-256color ssh"

alias n="nnn"
function nnn () {
  command nnn "$@"

  if [ -f "$NNN_TMPFILE" ]; then
          . "$NNN_TMPFILE"
  fi
}

function kill () {
  command kill -KILL $(pidof "$@")
}

function suyabai () {
  SHA256=$(shasum -a 256 /opt/homebrew/bin/yabai | awk "{print \$1;}")
  if [ -f "/private/etc/sudoers.d/yabai" ]; then
    sudo sed -i '' -e 's/sha256:[[:alnum:]]*/sha256:'${SHA256}'/' /private/etc/sudoers.d/yabai
  else
    echo "sudoers file does not exist yet"
  fi
}

export EDITOR="$(which nvim)"
export VISUAL="$(which cursor)"
export MANPAGER="$(which nvim) +Man!"
export XDG_CONFIG_HOME="$HOME/.config"

# >>> mamba initialize >>>
# !! Contents within this block are managed by 'mamba init' !!
export MAMBA_EXE='/run/current-system/sw/bin/micromamba';
export MAMBA_ROOT_PREFIX='/Users/simon/micromamba';
__mamba_setup="$("$MAMBA_EXE" shell hook --shell zsh --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__mamba_setup"
else
    alias micromamba="$MAMBA_EXE"  # Fallback on help from mamba activate
fi
unset __mamba_setup
# <<< mamba initialize <<<
