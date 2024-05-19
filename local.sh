#!/bin/bash

alias c='clear'
alias q='stty sane'
alias ts='sudo hwclock -s'
alias createPassword='pwgen -1 16 10;pwgen -1 -s -y 16 10'
alias mydate='date +"%Y-%m%d-%H%M%S"'
alias gip='curl inet-ip.info'
alias delete1m="find . -maxdepth 1 -mtime +30|xargs rm -rf"
alias noh='setopt HIST_IGNORE_SPACE'

grepp(){
	if [ $# != 1 ]; then
		echo usage: $0 string
		return 1
	fi
	grep $1 -rnI
}

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

gmk(){
	if [ $# != 1 ]; then
		echo usage: $0 input.go
		return 1
	fi
	dst=`echo $1|sed -e "s/.go/_mock.go/g"`
	package=`head -n 1 $1|awk '{print $2}'`
	~/go/bin/mockgen -source $1 -destination ${dst} -package ${package}
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



