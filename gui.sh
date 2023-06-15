#!/bin/bash

version=$(cat /etc/os-release | grep "PRETTY_NAME" | sed 's/PRETTY_NAME=//g' | sed 's/["]//g' | awk '{print $1}')
version_id=$(cat /etc/os-release | grep "VERSION_ID" | sed 's/VERSION_ID=//g' | sed 's/["]//g' | awk '{print $1}')

if [ $version == "CentOS" ] && [ $version_id == "8" ]
then

  sudo sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-Linux-*
  sudo sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-Linux-*
  sudo dnf update -y
  sudo dnf groupinstall "Server with GUI" -y
  sudo systemctl set-default graphical
fi


if [ $version == "CentOS" ] && [ $version_id == "7" ]
then
    sudo yum update -y

fi

if [ $version == "Debian" ]
then
    sudo apt update -y && sudo apt upgrade -y
    sudo apt install git net-tools -y
    cd /home
    sudo git clone https://github.com/kebe7jun/linux-kms-server
    sudo cp -R /home/linux-kms-server/vlmcsd/ /home/kms
    sudo mv /home/kms/vlmcsd /home/kms/kmsd
    cd /home/kms
    sudo ./kmsd -R170d -L 0.0.0.0:1688 -l /home/kms/kmsd.log
    sudo ufw allow 1688/tcp
    echo "@reboot cd /home/kms && sudo ./kmsd -R170d -L 0.0.0.0:1688 -l /home/kms/kms.log" >> /etc/crontab
    timedatectl set-timezone Asia/Ho_Chi_Minh
    sudo netstat -ano | grep 1688
fi

if [ $version == "Fedora" ]
then
    sudo yum update -y
    sudo apt install git net-tools -y
    cd /home
    sudo git clone https://github.com/kebe7jun/linux-kms-server
    sudo cp -R /home/linux-kms-server/vlmcsd/ /home/kms
    sudo mv /home/kms/vlmcsd /home/kms/kmsd
    cd /home/kms
    sudo ./kmsd -R170d -L 0.0.0.0:1688 -l /home/kms/kmsd.log
    firewall-cmd --zone=public --add-port=1688/tcp --permanent
    echo "@reboot cd /home/kms && sudo ./kmsd -R170d -L 0.0.0.0:1688 -l /home/kms/kms.log" >> /etc/crontab
    timedatectl set-timezone Asia/Ho_Chi_Minh
    sudo netstat -ano | grep 1688
fi

if [ $version == "Red" ]
then
    sudo yum update -y
    sudo apt install git net-tools -y
    cd /home
    sudo git clone https://github.com/kebe7jun/linux-kms-server
    sudo cp -R /home/linux-kms-server/vlmcsd/ /home/kms
    sudo mv /home/kms/vlmcsd /home/kms/kmsd
    cd /home/kms
    sudo ./kmsd -R170d -L 0.0.0.0:1688 -l /home/kms/kmsd.log
    firewall-cmd --zone=public --add-port=1688/tcp --permanent
    echo "@reboot cd /home/kms && sudo ./kmsd -R170d -L 0.0.0.0:1688 -l /home/kms/kms.log" >> /etc/crontab
    timedatectl set-timezone Asia/Ho_Chi_Minh
    sudo netstat -ano | grep 1688
fi

if [ $version == "Alpine" ]
then
    cd /home
    git clone https://github.com/Wind4/vlmcsd
    cd vlmcsd
    make
    cp /home/vlmcsd/bin/vlmcsd /home/kmsd
    echo 'name="kmsd"' >> /etc/init.d/kmsd
    echo 'pidfile="/run/$RC_SVCNAME.pid"' >> /etc/init.d/kmsd
    echo 'command="/home/kmsd"' >> /etc/init.d/kmsd
    echo 'command_args="-p $pidfile -v -l /home/kmsd.log"' >> /etc/init.d/kmsd
    echo 'depend() {need net' >> /etc/init.d/kmsd
    echo '}' >> /etc/init.d/kmsd
    chmod +x /etc/init.d/kmsd
    rc-update add kmsd
    /etc/init.d/kmsd start
    netstat -ano | grep 1688
fi














