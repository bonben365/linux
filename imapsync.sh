#!/bin/bash

version=$(cat /etc/os-release | grep "PRETTY_NAME" | sed 's/PRETTY_NAME=//g' | sed 's/["]//g' | awk '{print $1}')
version_id=$(cat /etc/os-release | grep "VERSION_ID" | sed 's/VERSION_ID=//g' | sed 's/["]//g' | awk '{print $1}')
client_idx="$(cat /home/imapsync/client_id.txt)"
client_secretx="$(cat /home/imapsync/client_secret.txt)"


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
  
  cd /home/imapsync
  wget https://raw.githubusercontent.com/bonben365/linux/main/mutt_oauth2.py
  sudo sed -i 's:DECRYPTION_PIPE = \['\''gpg'\'', '\''--decrypt'\''\]:DECRYPTION_PIPE = \['\''tee'\''\]:g' /home/imapsync/mutt_oauth2.py
  sudo sed -i 's:ENCRYPTION_PIPE = \['\''gpg'\'', '\''--encrypt'\'', '\''--recipient'\'', '\''YOUR_GPG_IDENTITY'\''\]:ENCRYPTION_PIPE = \['\''tee'\''\]:g' /home/imapsync/mutt_oauth2.py
  sudo sed -i 's:https\:\/\/login.microsoftonline.com\/common\/oauth2\/nativeclient:http\:\/\/localhost\/:g' /home/imapsync/mutt_oauth2.py
  
  sudo sed -i "s|YOUR_CLIENT_ID|$client_idx|g" /home/imapsync/mutt_oauth2.py
  sudo sed -i "s|YOUR_CLIENT_SECRET|$client_secretx|g" /home/imapsync/mutt_oauth2.py
  
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
  
  cd /home/imapsync
  wget https://raw.githubusercontent.com/bonben365/linux/main/mutt_oauth2.py
  sudo sed -i 's:DECRYPTION_PIPE = \['\''gpg'\'', '\''--decrypt'\''\]:DECRYPTION_PIPE = \['\''tee'\''\]:g' /home/imapsync/mutt_oauth2.py
  sudo sed -i 's:ENCRYPTION_PIPE = \['\''gpg'\'', '\''--encrypt'\'', '\''--recipient'\'', '\''YOUR_GPG_IDENTITY'\''\]:ENCRYPTION_PIPE = \['\''tee'\''\]:g' /home/imapsync/mutt_oauth2.py
  sudo sed -i 's:https\:\/\/login.microsoftonline.com\/common\/oauth2\/nativeclient:http\:\/\/localhost\/:g' /home/imapsync/mutt_oauth2.py
  
  sudo sed -i "s|YOUR_CLIENT_ID|$client_idx|g" /home/imapsync/mutt_oauth2.py
  sudo sed -i "s|YOUR_CLIENT_SECRET|$client_secretx|g" /home/imapsync/mutt_oauth2.py
fi

if [ $version == "Ubuntu" ]
then
  sudo apt-get install  \
    libauthen-ntlm-perl     \
    libclass-load-perl      \
    libcrypt-openssl-rsa-perl \
    libcrypt-ssleay-perl    \
    libdata-uniqid-perl     \
    libdigest-hmac-perl     \
    libdist-checkconflicts-perl \
    libencode-imaputf7-perl     \
    libfile-copy-recursive-perl \
    libfile-tail-perl       \
    libio-compress-perl     \
    libio-socket-inet6-perl \
    libio-socket-ssl-perl   \
    libio-tee-perl          \
    libjson-webtoken-perl   \
    libmail-imapclient-perl \
    libmodule-scandeps-perl \
    libnet-dbus-perl        \
    libnet-ssleay-perl      \
    libpar-packer-perl      \
    libproc-processtable-perl \
    libreadonly-perl        \
    libregexp-common-perl   \
    libsys-meminfo-perl     \
    libterm-readkey-perl    \
    libtest-fatal-perl      \
    libtest-mock-guard-perl \
    libtest-mockobject-perl \
    libtest-pod-perl        \
    libtest-requires-perl   \
    libtest-simple-perl     \
    libunicode-string-perl  \
    liburi-perl             \
    libtest-nowarnings-perl \
    libtest-deep-perl       \
    libtest-warn-perl       \
    make                    \
    cpanminus \
    time -y

  sudo cpanm Mail::IMAPClient
  wget -N https://raw.githubusercontent.com/imapsync/imapsync/master/imapsync
  sudo chmod +x imapsync
  sudo cp imapsync /usr/bin/

  sudo apt install software-properties-common -y
  sudo add-apt-repository ppa:deadsnakes/ppa
<<<<<<< Updated upstream
  sudo apt install python3.9 -y

=======
  sudo apt update -y
  sudo apt install python3 -y
  pip3 install requests schedule --user
  pip3 install --upgrade pip
>>>>>>> Stashed changes

  cd /home/imapsync
  wget https://raw.githubusercontent.com/bonben365/linux/main/mutt_oauth2.py
  sudo sed -i 's:DECRYPTION_PIPE = \['\''gpg'\'', '\''--decrypt'\''\]:DECRYPTION_PIPE = \['\''tee'\''\]:g' /home/imapsync/mutt_oauth2.py
  sudo sed -i 's:ENCRYPTION_PIPE = \['\''gpg'\'', '\''--encrypt'\'', '\''--recipient'\'', '\''YOUR_GPG_IDENTITY'\''\]:ENCRYPTION_PIPE = \['\''tee'\''\]:g' /home/imapsync/mutt_oauth2.py
  sudo sed -i 's:https\:\/\/login.microsoftonline.com\/common\/oauth2\/nativeclient:http\:\/\/localhost\/:g' /home/imapsync/mutt_oauth2.py
  
  sudo sed -i "s|YOUR_CLIENT_ID|$client_idx|g" /home/imapsync/mutt_oauth2.py
  sudo sed -i "s|YOUR_CLIENT_SECRET|$client_secretx|g" /home/imapsync/mutt_oauth2.py


fi

if [ $version == "Fedora" ]
then

fi

if [ $version == "Red" ]
then

fi















