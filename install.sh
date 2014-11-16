#!/usr/bin/bash

if [ "$EUID" -ne 0 ];then
	echo "Please use sudo"
	exit
fi

xDir="/opt/xacman"
binDir="/usr/bin"

if [ -e "${binDir}/xacman" ] 
then																		#Remove files/syms
	echo "Reinstalling xacman  to ${xDir}"
	rm ${binDir}/xacman
	rm -r ${xDir}
else
	echo "Installing xacman to ${xDir}"
fi
mkdir ${xDir}

cp ./xacman.pl ${xDir}
ln -s ${xDir}/xacman.pl /usr/bin/xacman
