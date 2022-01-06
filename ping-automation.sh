#!/bin/bash

ping -c 1 $1

#if test "$?" -eq "0"; then
if [ "$?" -eq "0" ] ; then


        echo -e  "\n$1 IP is reachable"
else
    	echo -e "\n$1 IP is not reachable"

fi

exit


