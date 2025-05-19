export ZDOTDIR="$HOME/.config/oh-my-zsh"

# use vim as the editor
export EDITOR=nvim

export PATH="$HOME/.local/bin:$PATH"
export PATH=/opt/homebrew/bin:$PATH

# Starship
export STARSHIP_CONFIG=~/.config/starship/starship.toml

# FZF
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow'
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

