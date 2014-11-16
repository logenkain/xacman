#!/usr/bin/bash

if [ "$EUID" -ne 0 ];then # Check to see if root user
  echo "Please use sudo"
  exit
fi
 
xDir="/opt/xacman"
binDir="/usr/bin"
if [ -e "${binDir}/xacman" ] 
then 
	echo "Removing ${binDir}/xacman"
  echo "Removing ${xDir}/xacman.pl"
	echo "Removing ${xDir}"
  rm ${binDir}/xacman
  rm -r ${xDir} 
else
  echo "xacman is not installed"
fi
