#!/usr/bin/bash

if [ "$EUID" -ne 0 ];then
	echo "Please use sudo"
	exit
fi

xDir="/usr/bin/xacman"
if [ -e "$xDir" ] 
then
	echo "xacman reinstalling to ${xDir}"
else
	echo "Installing xacman to ${xDir}"
fi
cp ./xacman.pl ${xDir}
