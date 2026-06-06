# System
alias c='clear'
alias e='exit'

# Git
alias g='git'
alias ga='git add'
alias gf='git fetch'
alias gs='git status'
alias gss='git status -s'
alias gup='git fetch && git rebase'
alias gtd='git tag --delete'
alias gtdr='git tag --delete origin'
alias glo='git pull origin'
alias gl='git pull'
alias gb='git branch '
alias gbr='git branch -r'
alias gd='git diff'
alias gco='git checkout '
alias gcob='git checkout -b '
alias gre='git remote'
alias gres='git remote show'
alias glgg='git log --graph --max-count=5 --decorate --pretty="oneline"'
alias gm='git merge'
alias gp='git push'
alias gpo='git push origin'
alias ggpush='git push origin $(current_branch)'
alias gc='git commit -v'
alias gcm='git commit -m'
alias gcmnv='git commit --no-verify -m'
alias gcanenv='git commit --amend --no-edit --no-verify'
alias gsc='git switch -c'
alias gsm='git switch main'
alias gsp='git stash push'
alias gspop='git stash pop'

# zsh
alias zr='source ~/.zshrc'
theme() {
  ~/.config/toggle-theme.sh "$@"
  [[ $? -eq 0 && -n "${1:-}" ]] && source ~/.zshrc
}

# Brew
#alias bsrb='brew services restart borders'
alias bo='brew outdated'
alias bug='brew upgrade'
alias bud='brew update'
alias bog='brew outdated --greedy-auto-updates'
alias bug='brew upgrade --greedy-auto-updates'