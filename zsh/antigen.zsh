source ~/.config/antigen/antigen.zsh

export ANTIGE_CACHE=false

antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions

antigen bundle jeffreytse/zsh-vi-mode

antigen bundle "MichaelAquilina/zsh-you-should-use"

antigen apply
