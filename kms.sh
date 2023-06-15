#!/bin/bash

version=$(cat /etc/os-release | grep "PRETTY_NAME" | sed 's/PRETTY_NAME=//g' | sed 's/["]//g' | awk '{print $1}')

if [ $version == "Ubuntu" ]
then
    sudo apt install git -y
    cd /home
    sudo git clone https://github.com/kebe7jun/linux-kms-server
    cd /linux-kms-server/vlmcsd
    cp vlmcsd /home && cd /home && mv vlmcsd kms
    sudo ./kms -R170d -L 0.0.0.0:1688 -l /home/kms.log
    firewall-cmd --zone=public --add-port=1688/tcp --permanent
    echo "@reboot cd /home && sudo ./kms -R170d -L 0.0.0.0:1688 -l /home/kms.log" >> /etc/crontab
    timedatectl set-timezone Asia/Ho_Chi_Minh
fi


if [ $version == "CentOS" ]
then
    sudo yum install git -y
    cd /home
    sudo git clone https://github.com/kebe7jun/linux-kms-server
    cd /linux-kms-server/vlmcsd
    cp vlmcsd /home && cd /home && mv vlmcsd kms
    sudo ./kms -R170d -L 0.0.0.0:1688 -l /home/kms.log
    firewall-cmd --zone=public --add-port=1688/tcp --permanent
    echo "@reboot cd /home && sudo ./kms -R170d -L 0.0.0.0:1688 -l /home/kms.log" >> /etc/crontab
    timedatectl set-timezone Asia/Ho_Chi_Minh
fi

if [ $version == "Debian" ]
then
    sudo apt-get update
    sudo apt-get install ca-certificates curl gnupg
    sudo mkdir -m 0755 -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    echo \
    "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
    "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo chmod a+r /etc/apt/keyrings/docker.gpg
    sudo apt-get update
    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    sudo systemctl start docker
    sudo systemctl status docker
fi

if [ $version == "Fedora" ]
then
    sudo dnf -y install dnf-plugins-core
    sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
    sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    sudo systemctl start docker
    sudo systemctl status docker
fi

if [ $version == "Red" ]
then
    sudo yum install -y yum-utils
    sudo yum-config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo
    sudo yum install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    sudo systemctl start docker
    sudo systemctl status docker
fi
















