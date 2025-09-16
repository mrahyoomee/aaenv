function ensure_zcompiled {
  local target_file="$1"
  local compiled_file="${target_file}.zwc"

  if [[ ! -f "$compiled_file" || "$target_file" -nt "$compiled_file" ]]; then
    print "Compiling $target_file..."
    zcompile "$target_file"
    if [[ $? -ne 0 ]]; then
      print "Error: zcompile failed for $target_file"
    fi
  fi
}

function source_with_zcompile {
  ensure_zcompiled "$1"
  builtin source "$@"
}

# p10k
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source_with_zcompile "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# source_with_zcompile Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source_with_zcompile "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source_with_zcompile ~/.p10k.zsh

#tmuxinator用
SHELL=/usr/bin/zsh

# LANG
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

alias tree="pwd;find . | sort | sed '1d;s/^\.//;s/\/\([^/]*\)$/|--\1/;s/\/[^/|]*/| /g'"

#cdとlsの省略
setopt auto_cd
#function chpwd() { ls }

#dirs -vで簡単に移動できる用でdirectory moduleに加えて0から開始
for index ({0..9}) alias "$index"="cd +${index}"; unset index

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

[[ -d $HOME/.local/bin ]] && export PATH=$HOME/.local/bin:$PATH
[[ -f $HOME/.local/env/local.sh ]] && source_with_zcompile $HOME/.local/env/local.sh
[[ -f $HOME/.local/env/peco_env.sh ]] && source_with_zcompile $HOME/.local/env/peco_env.sh
[[ -f $HOME/.local/env/anyenv_path.sh ]] && source_with_zcompile $HOME/.local/env/anyenv_path.sh
[[ -f $HOME/.local/env/myenv.sh ]] && source_with_zcompile $HOME/.local/env/myenv.sh
#need?
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

# .zshrcに変更があった場合、自動的にコンパイル
ensure_zcompiled ~/.zshrc
