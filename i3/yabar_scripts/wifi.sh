#!/bin/bash
ip=`ifconfig wlp58s0 | grep inet | awk '{print $2}'`
ip=`echo $ip | awk '{print $1}' | tr -d '"'`
if [ $ip == "off/any" ]
then
	echo " OFF"
else
	echo " " $ip
fi
