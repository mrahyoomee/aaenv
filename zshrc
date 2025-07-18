# タイムスタンプをチェックしてzcompileを実行する関数
# 引数: コンパイルしたいZshスクリプトファイルのパス
function ensure_zcompiled {
  local target_file="$1"
  local compiled_file="${target_file}.zwc"

  # ファイルが存在しない、または元のファイルがコンパイル済みファイルよりも新しい場合
  # ! -f "$compiled_file": コンパイル済みファイルが存在しない
  # "$target_file" -nt "$compiled_file": 元のファイルがコンパイル済みファイルより新しい
  if [[ ! -f "$compiled_file" || "$target_file" -nt "$compiled_file" ]]; then
    print "Compiling $target_file..."
    zcompile "$target_file"
    # コンパイルエラーが発生した場合に備えて、コンパイルが成功したかチェックすることもできる
    if [[ $? -ne 0 ]]; then
      print "Error: zcompile failed for $target_file"
    fi
  fi
}

# 組み込みの 'source' コマンドをオーバーライドするラッパー関数
# これにより、'source' するすべてのファイルが自動的にコンパイルされるようになる
function source {
  # まず、コンパイルが必要かチェックし、必要ならコンパイル
  ensure_zcompiled "$1"

  # その後、組み込みの 'source' コマンドを実行
  # 'builtin' キーワードを使って、この関数自身ではなくZshの組み込みコマンドを呼び出す
  builtin source "$@"
}

# p10k
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

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

# editor
EDITOR=vim
VISUAL=vim

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
alias ll='ls -lh'
#alias ll='ls -l'
#alias la='ls -A'
alias la='ls -a'
#alias l='ls -CF'
alias l='clear && ll'
alias ..2='cd ../..'
alias ..3='cd ../../..'
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

#yarn
type yarnpkg 1> /dev/null 2> /dev/null && PATH="$(yarnpkg global bin):$PATH"

#golang
[[ -d /usr/local/go/bin ]] && export PATH="$PATH:/usr/local/go/bin"

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
setopt HIST_IGNORE_SPACE

# Fuzzy matching of completions for when you mistype them:
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

# Ignore completion functions for commands you don’t have:
zstyle ':completion:*:functions' ignored-patterns '_*'

# The next line updates PATH for the Google Cloud SDK.
[[ -f '/home/$USER/google-cloud-sdk/path.zsh.inc' ]] &&  source ~/google-cloud-sdk/path.zsh.inc

# The next line enables shell command completion for gcloud.
[[ -f '/home/$USER/google-cloud-sdk/completion.zsh.inc' ]] && source ~/google-cloud-sdk/completion.zsh.inc

[[ -d $HOME/.local/bin ]] && export PATH=$HOME/.local/bin:$PATH
[[ -f $HOME/.local/env/local.sh ]] && source $HOME/.local/env/local.sh
[[ -f $HOME/.local/env/peco_env.sh ]] && source $HOME/.local/env/peco_env.sh
[[ -f $HOME/.local/env/anyenv_path.sh ]] && source $HOME/.local/env/anyenv_path.sh
[[ -f $HOME/.local/env/myenv.sh ]] && source $HOME/.local/env/myenv.sh
#need?
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

# .zshrcに変更があった場合、自動的にコンパイル
ensure_zcompiled ~/.zshrc
