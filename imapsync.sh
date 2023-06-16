#!/bin/bash

version=$(cat /etc/os-release | grep "PRETTY_NAME" | sed 's/PRETTY_NAME=//g' | sed 's/["]//g' | awk '{print $1}')
version_id=$(cat /etc/os-release | grep "VERSION_ID" | sed 's/VERSION_ID=//g' | sed 's/["]//g' | awk '{print $1}')

if [ $version == "CentOS" ] && [ $version_id == "8" ]
then

  sudo sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-Linux-*
  sudo sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-Linux-*
  sudo dnf update -y
  sudo dnf install epel-release -y

  sudo yum groupinstall "Development Tools" -y
  sudo yum install openssl-devel libffi-devel bzip2-devel -y
  wget https://www.python.org/ftp/python/3.9.16/Python-3.9.16.tgz
  tar xvf Python-*.tgz
  cd Python-3.9*/
  sudo ./configure --with-system-ffi --with-computed-gotos --enable-loadable-sqlite-extensions 
  sudo make -j ${nproc} 
  sudo make altinstall
  sudo rm Python-3.9.16.tgz 
  /usr/local/bin/python3.9 -m pip install --upgrade pip
  pip3.9 install requests schedule --user
  pip3.9 install --upgrade pip

  sudo dnf install --enablerepo=powertools imapsync -y
  sudo dnf install perl-Proc-ProcessTable -y
  wget -N https://imapsync.lamiral.info/imapsync
  sudo chmod +x imapsync
  sudo mv /usr/bin/imapsync  /usr/bin/imapsync_old
  sudo cp ./imapsync /usr/bin/imapsync
  
  cd /home
  sudo mkdir imapsync && cd imapsync
  wget https://gitlab.com/muttmua/mutt/-/raw/master/contrib/mutt_oauth2.py
  sudo sed -i 's:DECRYPTION_PIPE = \['\''gpg'\'', '\''--decrypt'\''\]:DECRYPTION_PIPE = \['\''tee'\''\]:g' /home/imapsync/mutt_oauth2.py
  sudo sed -i 's:ENCRYPTION_PIPE = \['\''gpg'\'', '\''--encrypt'\'', '\''--recipient'\'', '\''YOUR_GPG_IDENTITY'\''\]:ENCRYPTION_PIPE = \['\''tee'\''\]:g' /home/imapsync/mutt_oauth2.py
  sudo sed -i 's:https\:\/\/login.microsoftonline.com\/common\/oauth2\/nativeclient:http\:\/\/localhost\/:g' /home/imapsync/mutt_oauth2.py
  
  sudo sed -i 's:'\''client_id'\''\: '\'''\'',:'\''client_id'\''\: '\''66cf6639-b31d-44d9-9e6d-e5f39d79a1ef'\'',:g' /home/imapsync/mutt_oauth2.py
  sudo sed -i 's:'\''client_secret'\''\: '\'''\'',:'\''client_secret'\''\: '\''Sqf8Q~Olte450gMpk0rmJW8DGVh6NDWwwVH~IbH8'\'',:g' /home/imapsync/mutt_oauth2.py
  
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















