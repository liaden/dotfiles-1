## git. some to be used, some for reference.
alias gst='git status'
alias gbst='git branch -a -v'
alias gco='git checkout'
alias gb='git branch'
alias gsh='git show'
alias gshb='git show-branch'
alias gl='git log'
alias gm='git merge'
alias gd='git diff'
alias gds='git diff --cached'
alias gdhd='git diff HEAD'
alias gdst='git diff --stat'
alias stash='git stash'
alias unstash='git stash apply'
alias stash-ls='git stash list'
alias stash-patch='git stash show -p'

# doesn't work for merges, but generally it's good enough
function gci {
  if echo $PWD | grep 'chapcom' >/dev/null 2>&1; then
    command git-commit --author "Kyle Hargraves <kyleh@chaptercommunications.com>" $*
  else
    command git-commit $*
  fi
}

alias qg='open ~/bin/qgit.app'
