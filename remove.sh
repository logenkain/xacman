#!/usr/bin/bash

if [ "$EUID" -ne 0 ];then
  echo "Please use sudo"
  exit
fi
 
xDir="/usr/bin/xacman"
if [ -e "$xDir" ] 
then 
  echo "Removing ${xDir}"
 rm ${xDir}
else
  echo "xacman is not installed"
fi
