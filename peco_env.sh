#/usr/bin/env sh

type peco  1> /dev/null 2> /dev/null || return

#git + peco
#git push GR GB
#git push origin GB
alias -g GB='`git branch -a | peco --prompt "GIT BRANCH>" | head -n 1 | sed -e "s/^\*\s*//g"`'
alias -g GR='`git remote | peco --prompt "GIT REMOTE>" | head -n 1`'
alias -g GH='`git log --oneline|head -n 20|peco|awk "{print $1}"`'
#git diff GL GL
alias -g GL='`git log --oneline | peco | cut -d" " -f1`'
#git reset --hard GRL
alias -g GRL='`git reflog | peco | cut -d" " -f1`'

#docker
alias -g DI='`docker images |peco|awk "{print \$3}"`'
alias dkr='docker run -it $(docker images |peco|awk "{print \$3}") bash'
alias dke='docker exec -it $(docker ps |peco|awk "{print \$1}") bash'

# peco ctr+r でコマンド履歴
function peco-history-selection() {
    BUFFER=`history -n 1 | tac  | awk '!a[$0]++' | peco`
    CURSOR=$#BUFFER
    zle reset-prompt
}
zle -N peco-history-selection
bindkey '^R' peco-history-selection

# cdr ctr+[ でディレクトリ移動履歴
if [[ -n $(echo ${^fpath}/chpwd_recent_dirs(N)) && -n $(echo ${^fpath}/cdr(N)) ]]; then
    autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
    add-zsh-hook chpwd chpwd_recent_dirs
    zstyle ':completion:*' recent-dirs-insert both
    zstyle ':chpwd:*' recent-dirs-default true
    zstyle ':chpwd:*' recent-dirs-max 1000
    zstyle ':chpwd:*' recent-dirs-file "$HOME/.cache/chpwd-recent-dirs"
fi
function peco-cdr () {
    local selected_dir="$(cdr -l | sed 's/^[0-9]\+ \+//' | peco --prompt="cdr >" --query "$LBUFFER")"
    if [ -n "$selected_dir" ]; then
        BUFFER="cd ${selected_dir}"
        zle accept-line
    fi
}
zle -N peco-cdr
bindkey '^~' peco-cdr

# git repository ctrl+]
export SRC_ROOT=~/src
function peco-src () {
  local selected_dir=$(find $SRC_ROOT -maxdepth 5 -name .git|sed "s/\/.git//g"|peco --query "$LBUFFER")
  if [ -n "$selected_dir" ]; then
    BUFFER="cd ${selected_dir}"
    zle accept-line
  fi
  zle clear-screen
}
zle -N peco-src
bindkey '^\' peco-src

# git repository ctrl+\
export SSH_ROOT=~/src
function peco-ssh () {
  local selected_host=$(grep "^Host " ~/.ssh/config|awk "{print \$2}"|peco --query "$LBUFFER")
  if [ -n "$selected_host" ]; then
    BUFFER="ssh ${selected_host}"
    zle accept-line
  fi
  zle clear-screen
}
zle -N peco-ssh
bindkey '^]' peco-ssh

