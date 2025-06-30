# Nix Commands
alias ndswitch="darwin-rebuild switch --flake ~/repos/nixos#madara"
alias nupdate="nix --extra-experimental-features 'nix-command flakes' flake update"

# Git
alias gc="git commit -m"
alias gca="git commit --all -m 'auto-commit'"
alias gp="git push"
alias gpu="git pull"
alias gs="git status"
alias glog="git log --graph --topo-order --pretty='%w(100,0,6)%C(yellow)%h%C(bold)%C(black)%d %C(cyan)%ar %C(green)%an%n%C(bold)%C(white)%s %N' --abbrev-commit"
alias gdiff="git diff"
alias gco="git checkout"
alias gb='git branch'
alias gba='git branch -a'
alias gadd='git add'
alias ga='git add -p'
alias gcoall='git checkout -- .'
alias gr='git remote'
alias gre='git reset'

# Nvim
alias vi=nvim

# Eza
alias l="eza -l --icons --git -a"
alias lt="eza --tree --level=2 --long --icons --git"
alias ltree="eza --tree --level=2  --icons --git"
