# Nushell Config File
#
# version = "0.95.0"

# Color Theme
# source ~/.config/nushell/catppuccin_macchiato.nu
source ~/.config/nushell/catppuccin_latte.nu

$env.config.table.mode = "rounded"
$env.config.table.header_on_separator = true
$env.config.table.padding = {left: 0, right: 0}
$env.config.table.index_mode = "always"

$env.config.history.file_format = "sqlite"

$env.config.footer_mode = 4

$env.config.color_config.separator = "dark_gray"

alias l = ls -l
alias c = clear
alias la = ls -la
alias le = eza --tree --level=1 --long --icons --git
alias lt = eza --tree --level=2 --long --icons --git
alias vi = nvim
alias nds = darwin-rebuild switch --flake ~/repos/nixos#madara

# Git
alias gc = git commit -m
alias gca = git commit -a -m "auto-commit"
alias gp = git push origin HEAD
alias gpu = git pull origin
alias gs = git status
alias glog = git log --graph --topo-order --pretty='%w(100,0,6)%C(yellow)%h%C(bold)%C(black)%d %C(cyan)%ar %C(green)%an%n%C(bold)%C(white)%s %N' --abbrev-commit
alias gdiff = git diff
alias gco = git checkout
alias gb = git branch
alias gba = git branch -a
alias gadd = git add
alias ga = git add -p
alias gcoall = git checkout -- .
alias gr = git remote
alias gre = git reset

source ~/.config/nushell/env.nu
source ~/.config/nushell/prompt.nu

source ~/.zoxide.nu

mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")

source ~/.local/share/atuin/init.nu
