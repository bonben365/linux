#!/bin/bash

version=$(cat /etc/os-release | grep "PRETTY_NAME" | sed 's/PRETTY_NAME=//g' | sed 's/["]//g' | awk '{print $1}')
version_id=$(cat /etc/os-release | grep "VERSION_ID" | sed 's/VERSION_ID=//g' | sed 's/["]//g' | awk '{print $1}')



if [ $version == "CentOS" ] && [ $version_id == "8" ]
then

  
  
fi


if [ $version == "CentOS" ] && [ $version_id == "9" ]
then


fi

if [ $version == "Ubuntu" ]
then



fi

if [ $version == "Fedora" ]
then

fi

if [ $version == "Red" ]
then
    
fi














