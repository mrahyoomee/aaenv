# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

#tmuxinator用
SHELL=/usr/bin/zsh

# LANG
#文字コード設定
export LANG=ja_JP.UTF-8

#コマンドをtypoしたときに聞きなおしてくれる
#setopt correct

#表示を詰めてくれる
setopt list_packed

#beepを消す
setopt nolistbeep

#便利aliasたち
#alias ls='ls --color=auto'
#alias ls='ls -G'
#alias ll='ls -alF'
#alias ll='ls -lh'
#alias ll='ls -l'
#alias la='ls -A'
#alias la='ls -a'
#alias l='ls -CF'
#alias l='clear && ll'
#alias ..2='cd ../..'
#alias ..3='cd ../../..'
#alias g='git'
#alias ga='git add'
#alias gd='git diff'
#alias gs='git status'
#alias gp='git push'
#alias gb='git branch'
#alias gst='git status'
#alias gco='git checkout'
#alias gf='git fetch'
#alias gc='git commit'
#alias top='htop'

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

#疑似Treeコマンド
alias tree="pwd;find . | sort | sed '1d;s/^\.//;s/\/\([^/]*\)$/|--\1/;s/\/[^/|]*/| /g'"

#cdとlsの省略
setopt auto_cd
#function chpwd() { ls }

#dirs -vで簡単に移動できる用でdirectory moduleに加えて0から開始
for index ({0..9}) alias "$index"="cd +${index}"; unset index

#pyenv
#PYENV_ROOT="${HOME}/.pyenv"
#if [ -d "${PYENV_ROOT}" ]; then
#    export PATH=${PYENV_ROOT}/bin:$PATH
#    eval "$(pyenv init -)"
#fi

# anyenv
if [ -d $HOME/.anyenv ] ; then
  export PATH="$HOME/.anyenv/bin:$PATH"
  eval "$(anyenv init - zsh)"
  for D in `\ls $HOME/.anyenv/envs`
  do
    export PATH="$HOME/.anyenv/envs/$D/shims:$PATH"
    export PATH="$HOME/.anyenv/envs/$D/bin:$PATH"
  done
  function _switch_env() {
    if [[ $fooenv == "" || $language_name == "" ]]; then
      return 0
    fi
    set -f
    versions=`$fooenv versions | peco`
    if [[ $versions == "" ]]; then
      return 0
    fi
    if [[ $versions == \** ]]; then
      version_name=`echo $versions | awk '{ print $2 }'`
    else
      version_name=`echo $versions | awk '{ print $1 }'`
    fi
    mode=local
    if [[ $1 == "--global" ]]; then
      mode=global
    fi
    echo "Set ${mode} ${language_name} version to ${version_name}"
    $fooenv $mode $version_name
  }
  function ppyenv() {
    language_name='Python'
    fooenv='pyenv'
    _switch_env $1
  }
  function prbenv() {
    language_name='Ruby'
    fooenv='rbenv'
    _switch_env $1
  }
  function pplenv() {
    language_name='Perl'
    fooenv='plenv'
    _switch_env $1
  }
  function pndenv() {
    language_name='Node'
    fooenv='ndenv'
    _switch_env $1
  }
  function pswiftenv() {
    language_name='Swift'
    fooenv='swiftenv'
    _switch_env $1
  }
fi

#yarn
type yarnpkg 1> /dev/null 2> /dev/null && PATH="$(yarnpkg global bin):$PATH"

#golang
if [ -d /usr/local/go/bin ]; then
  export PATH="$PATH:/usr/local/go/bin"
fi

#VS code
me=$USER
if [ -f /mnt/c/Windows/System32/cmd.exe ]; then
  me=`/mnt/c/Windows/System32/cmd.exe "/c" "echo %username%" 2> /dev/null|tr -d '\015'`
fi
if [ -d "/mnt/c/Users/$me/AppData/Local/Programs/Microsoft VS Code/bin" ]; then
  export PATH="/mnt/c/Users/$me/AppData/Local/Programs/Microsoft VS Code/bin":"$PATH"
fi

# history
HISTFILE=~/.histfile
HISTSIZE=5000
SAVEHIST=5000
DIRSTACKSIZE=10

# share .zshhistory
setopt inc_append_history
setopt share_history
setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_reduce_blanks

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
bindkey '^[' peco-cdr

# ghq ctrl+]
export GHQ_ROOT=/home/$USER/src
function peco-src () {
  local selected_dir=$(ghq list -p | peco --query "$LBUFFER")
  if [ -n "$selected_dir" ]; then
    BUFFER="cd ${selected_dir}"
    zle accept-line
  fi
  zle clear-screen
}
zle -N peco-src
bindkey '^]' peco-src

# Fuzzy matching of completions for when you mistype them:
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

# Ignore completion functions for commands you don’t have:
zstyle ':completion:*:functions' ignored-patterns '_*'

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/$USER/google-cloud-sdk/path.zsh.inc' ]; then . '/home/$USER/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/$USER/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/$USER/google-cloud-sdk/completion.zsh.inc'; fi

[ -d /home/$USER/.local/bin ] && export PATH="/home/$USER/.local/bin:$PATH"
[ -f /home/$USER/.local/bin/myfunc.sh ] && source /home/$USER/.local/bin/local.sh
[ -f /home/$USER/.local/bin/env.sh ] && source /home/$USER/.local/bin/env.sh

#need?
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

# .zshrcに変更があった場合、自動的にコンパイル
if [ ~/.zshrc -nt ~/.zshrc.zwc ]; then
   zcompile ~/.zshrc
fi
