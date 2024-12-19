
# Aliases for common dirs
alias home="cd ~"

# System Aliases
alias ..="cd .."
alias x="exit"
alias vi="nvim"


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

# Disco Cluster Settings
[[ -f /itet-stor/siwachte/net_scratch/conda/bin/conda ]] && eval "$(/itet-stor/siwachte/net_scratch/conda/bin/conda shell.bash hook)"

export SLURM_CONF=/home/sladmitet/slurm/slurm.conf
alias smon_free="grep --color=always --extended-regexp 'free|$' /home/sladmitet/smon.txt"
alias smon_mine="grep --color=always --extended-regexp '${USER}|$' /home/sladmitet/smon.txt"
alias watch_smon_free="watch --interval 300 --no-title --differences --color \"grep --color=always --extended-regexp 'free|$' /home/sladmitet/smon.txt\""
alias watch_smon_mine="watch --interval 300 --no-title --differences --color \"grep --color=always --extended-regexp '${USER}|$' /home/sladmitet/smon.txt\""

alias smon_free="grep --color=always --extended-regexp 'free|$' /home/sladmitet/smon.txt"
alias smon_mine="grep --color=always --extended-regexp '${USER}|$' /home/sladmitet/smon.txt"
alias myjobs="squeue -u $USER"

alias log="bash /itet-stor/siwachte/net_scratch/fingnn/scripts/log_manager.sh" 
alias logl="log -l"
alias logu="log -u"
alias logs="log -s $1"
alias logl="log -j"
alias logul="log -u && log -l"

# Starship
eval "$(starship init zsh)"

