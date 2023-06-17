#!/bin/bash

version=$(cat /etc/os-release | grep "PRETTY_NAME" | sed 's/PRETTY_NAME=//g' | sed 's/["]//g' | awk '{print $1}')
version_id=$(cat /etc/os-release | grep "VERSION_ID" | sed 's/VERSION_ID=//g' | sed 's/["]//g' | awk '{print $1}')
client_idx="$(cat /home/imapsync/client_id.txt)"
client_secretx="$(cat /home/imapsync/client_secret.txt)"



if [ $version == "CentOS" ] && [ $version_id == "7" ]
then

  sudo yum update -y
  sudo yum install epel-release -y

  sudo yum install imapsync -y

  sudo yum install perl-App-cpanminus \
      perl-Dist-CheckConflicts \
      perl-HTML-Parser \
      perl-libwww-perl \
      perl-Module-Implementation \
      perl-Module-ScanDeps \
      perl-Package-Stash \
      perl-Package-Stash-XS \
      perl-PAR-Packer \
      perl-Regexp-Common \
      perl-Sys-MemInfo \
      perl-Test-Fatal \
      perl-Test-Mock-Guard \
      perl-Test-Requires \
      perl-Test-Deep \
      perl-File-Tail \
      perl-Unicode-String \
      perl-Test-NoWarnings \
      perl-Test-Simple \
      perl-Test-Warn \
      perl-Sub-Uplevel \
      perl-Proc-ProcessTable \
      ca-certificates -y

  wget -N https://imapsync.lamiral.info/imapsync
  chmod +x imapsync
  sudo mv /usr/bin/imapsync  /usr/bin/imapsync_old
  sudo cp ./imapsync /usr/bin/imapsync
  cpanm Encode::IMAPUTF7 

  sudo yum -y update
  sudo yum install -y make gcc perl-core pcre-devel wget zlib-devel
  wget wget https://ftp.openssl.org/source/openssl-3.1.1.tar.gz
  sudo tar -xzvf openssl-3*.tar.gz
  cd openssl-3*
  ./config --prefix=/usr --openssldir=/etc/ssl --libdir=lib no-shared zlib-dynamic
  sudo make -j ${nproc} 
  sudo make test
  sudo make install -j ${nproc} 
  echo "export LD_LIBRARY_PATH=/usr/local/lib:/usr/local/lib64" >> /etc/profile.d/openssl.sh
  source /etc/profile.d/openssl.sh
  openssl version

  sudo yum groupinstall "Development Tools" -y
  sudo yum install libffi-devel bzip2-devel -y
  wget https://www.python.org/ftp/python/3.9.16/Python-3.9.16.tgz
  tar xvf Python-*.tgz
  cd Python-3.9*/
  sudo ./configure --with-system-ffi --with-computed-gotos --enable-loadable-sqlite-extensions 
  sudo make -j ${nproc} 
  sudo make altinstall
  sudo rm ../Python-3.9.16.tgz -f 
  /usr/local/bin/python3.9 -m pip install --upgrade pip
  pip3.9 install requests schedule --user
  pip3.9 install --upgrade pip
  
  cd /home/imapsync
  wget https://gitlab.com/muttmua/mutt/-/raw/master/contrib/mutt_oauth2.py
  sudo sed -i 's:DECRYPTION_PIPE = \['\''gpg'\'', '\''--decrypt'\''\]:DECRYPTION_PIPE = \['\''tee'\''\]:g' /home/imapsync/mutt_oauth2.py
  sudo sed -i 's:ENCRYPTION_PIPE = \['\''gpg'\'', '\''--encrypt'\'', '\''--recipient'\'', '\''YOUR_GPG_IDENTITY'\''\]:ENCRYPTION_PIPE = \['\''tee'\''\]:g' /home/imapsync/mutt_oauth2.py
  sudo sed -i 's:https\:\/\/login.microsoftonline.com\/common\/oauth2\/nativeclient:http\:\/\/localhost\/:g' /home/imapsync/mutt_oauth2.py
  
  sudo sed -i "s|YOUR_CLIENT_ID|$client_idx|g" /home/imapsync/mutt_oauth2.py
  sudo sed -i "s|YOUR_CLIENT_SECRET|$client_secretx|g" /home/imapsync/mutt_oauth2.py
  
fi


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
  sudo rm ../Python-3.9.16.tgz -f 
  /usr/local/bin/python3.9 -m pip install --upgrade pip
  pip3.9 install requests schedule --user
  pip3.9 install --upgrade pip

  sudo dnf install --enablerepo=powertools imapsync -y
  sudo dnf install perl-Proc-ProcessTable -y
  wget -N https://imapsync.lamiral.info/imapsync
  sudo chmod +x imapsync
  sudo mv /usr/bin/imapsync  /usr/bin/imapsync_old
  sudo cp ./imapsync /usr/bin/imapsync
  
  sudo mkdir /home/imapsync && cd /home/imapsync
  wget https://gitlab.com/muttmua/mutt/-/raw/master/contrib/mutt_oauth2.py
  sudo sed -i 's:DECRYPTION_PIPE = \['\''gpg'\'', '\''--decrypt'\''\]:DECRYPTION_PIPE = \['\''tee'\''\]:g' /home/imapsync/mutt_oauth2.py
  sudo sed -i 's:ENCRYPTION_PIPE = \['\''gpg'\'', '\''--encrypt'\'', '\''--recipient'\'', '\''YOUR_GPG_IDENTITY'\''\]:ENCRYPTION_PIPE = \['\''tee'\''\]:g' /home/imapsync/mutt_oauth2.py
  sudo sed -i 's:https\:\/\/login.microsoftonline.com\/common\/oauth2\/nativeclient:http\:\/\/localhost\/:g' /home/imapsync/mutt_oauth2.py
  
  sudo sed -i "s|'client_id': '',|'client_id': '$client_id',|g" /home/imapsync/mutt_oauth2.py
  sudo sed -i "s|'client_secret': '',|'client_secret': '$client_secret',|g" /home/imapsync/mutt_oauth2.py
  
fi


if [ $version == "CentOS" ] && [ $version_id == "9" ]
then
  sudo dnf update -y
  sudo dnf install epel-release -y

  sudo dnf groupinstall "Development Tools" -y
  sudo dnf install openssl-devel libffi-devel bzip2-devel -y
  wget https://www.python.org/ftp/python/3.9.16/Python-3.9.16.tgz
  tar xvf Python-*.tgz
  cd Python-3.9*/
  sudo ./configure --with-system-ffi --with-computed-gotos --enable-loadable-sqlite-extensions 
  sudo make -j ${nproc} 
  sudo make altinstall
  sudo rm ../Python-3.9.16.tgz -f 
  /usr/local/bin/python3.9 -m pip install --upgrade pip
  pip3.9 install requests schedule --user
  pip3.9 install --upgrade pip

  sudo dnf config-manager --set-enabled crb
  sudo dnf install imapsync -y
  sudo dnf install perl-Proc-ProcessTable -y
  wget -N https://imapsync.lamiral.info/imapsync
  sudo chmod +x imapsync
  sudo mv /usr/bin/imapsync  /usr/bin/imapsync_old
  sudo cp ./imapsync /usr/bin/imapsync
  
  sudo mkdir /home/imapsync && cd /home/imapsync
  wget https://gitlab.com/muttmua/mutt/-/raw/master/contrib/mutt_oauth2.py
  sudo sed -i 's:DECRYPTION_PIPE = \['\''gpg'\'', '\''--decrypt'\''\]:DECRYPTION_PIPE = \['\''tee'\''\]:g' /home/imapsync/mutt_oauth2.py
  sudo sed -i 's:ENCRYPTION_PIPE = \['\''gpg'\'', '\''--encrypt'\'', '\''--recipient'\'', '\''YOUR_GPG_IDENTITY'\''\]:ENCRYPTION_PIPE = \['\''tee'\''\]:g' /home/imapsync/mutt_oauth2.py
  sudo sed -i 's:https\:\/\/login.microsoftonline.com\/common\/oauth2\/nativeclient:http\:\/\/localhost\/:g' /home/imapsync/mutt_oauth2.py
  
  sudo sed -i "s|'client_id': '',|'client_id': '$client_id',|g" /home/imapsync/mutt_oauth2.py
  sudo sed -i "s|'client_secret': '',|'client_secret': '$client_secret',|g" /home/imapsync/mutt_oauth2.py

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















