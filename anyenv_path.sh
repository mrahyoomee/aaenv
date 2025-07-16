#/usr/bin/env sh

# have anyenv?
[[ -d $HOME/.anyenv ]] || return

# add anyenv path
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

fnction ppyenv() {
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

# have peco?
type peco 1> /dev/null 2> /dev/null || return

# add version select using peco
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

