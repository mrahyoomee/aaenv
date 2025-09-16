#!/bin/bash

alias c='clear'
#ターミナルが文字化けした時用
alias q='stty sane'
alias ts='sudo hwclock -s'
alias createPassword='pwgen -1 16 10;pwgen -1 -s -y 16 10'
alias mydate='date +"%Y-%m%d-%H%M%S"'
alias gip='curl inet-ip.info'
alias delete1m="find . -maxdepth 1 -mtime +30|xargs rm -rf"


type zoxide  1> /dev/null 2> /dev/null && eval "$(zoxide init zsh)"
type batcat  1> /dev/null 2> /dev/null && alias bat=batcat
type batcat  1> /dev/null 2> /dev/null && alias fd=fdfind
type rg 1> /dev/null 2> /dev/null && alias rg="rg --glob '!*\.P' --glob '!*\.syml' --no-heading"
type yarnpkg 1> /dev/null 2> /dev/null && PATH="$(yarnpkg global bin):$PATH"
[[ -d /usr/local/go/bin ]] && export PATH="$PATH:/usr/local/go/bin"

#VS code
me=$USER
if [ -f /mnt/c/Windows/System32/cmd.exe ]; then
  me=`/mnt/c/Windows/System32/cmd.exe "/c" "echo %username%" 2> /dev/null|tr -d '\015'`
fi
if [ -d "/mnt/c/Users/$me/AppData/Local/Programs/Microsoft VS Code/bin" ]; then
  export PATH="/mnt/c/Users/$me/AppData/Local/Programs/Microsoft VS Code/bin":"$PATH"
fi

# The next line updates PATH for the Google Cloud SDK.
[[ -f '/home/$USER/google-cloud-sdk/path.zsh.inc' ]] &&  source ~/google-cloud-sdk/path.zsh.inc

# The next line enables shell command completion for gcloud.
[[ -f '/home/$USER/google-cloud-sdk/completion.zsh.inc' ]] && source ~/google-cloud-sdk/completion.zsh.inc

ss(){
	if [ $# != 1 ]; then
		echo usage: $0 position
		return 1
	fi
	awk "{print \$$1}"
}

trashbox=~/.gomi
gomi(){
	if [ ! -d ${trashbox} ]; then
		mkdir ${trashbox}
	fi
	if [ $# != 0 ]; then
		echo mv -f ${@:1} ${trashbox}
	fi
}

upgrade(){
	sudo apt update && \
	sudo dpkg --configure -a --force-confdef --force-confold && \
	sudo apt upgrade -y --fix-broken --fix-missing -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' && \
	sudo apt autoremove -y
	#dpkg --list |grep "^rc" | cut -d " " -f 3 | xargs dpkg --purge
	purges=(`dpkg --list |grep "^rc" | cut -d " " -f 3`)
	for i in "${!purges[@]}"; do
		sudo dpkg --purge ${purges[$i]}
	done
}

getNvidiaInfo(){
        IFS=$'\n'
        temp=(`nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader`)
        fan=(`nvidia-smi --query-gpu=fan.speed --format=csv,noheader`)
        power=(`nvidia-smi --query-gpu=power.draw --format=csv,noheader`)
        for ((i=0; i < ${#temp[@]}; i++)); do
                echo GPU$i ${temp[i]}°C,  FanPower ${temp[i]}%, ${power[i]}W
        done
}

loopSeq(){
	for cnt in `seq -f %07g 0 10`
	do
		echo $cnt
	done
}

loopFile(){
	ls -1 . > /tmp/tmp.txt
	while read line
	do
		echo $line
	done < /tmp/tmp.txt
	rm -f /tmp/tmp.txt
}


loopFile2(){
	ls -1 |while read line
	do
		echo $line
	done
}



