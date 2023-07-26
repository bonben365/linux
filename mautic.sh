#!/bin/bash

version=$(cat /etc/os-release | grep "PRETTY_NAME" | sed 's/PRETTY_NAME=//g' | sed 's/["]//g' | awk '{print $1}')
version_id=$(cat /etc/os-release | grep "VERSION_ID" | sed 's/VERSION_ID=//g' | sed 's/["]//g' | awk '{print $1}')

if [ $version == "Ubuntu" ]
then
#Install and configure LEMP
sudo apt update -y
sudo apt install nginx unzip -y
sudo systemctl start nginx && sudo systemctl enable nginx
sudo iptables -I INPUT -p tcp --dport 80 -j ACCEPT
sudo iptables -I INPUT -p tcp --dport 443 -j ACCEPT

sudo apt install software-properties-common ca-certificates lsb-release apt-transport-https -y
LC_ALL=C.UTF-8 sudo add-apt-repository ppa:ondrej/php -y
sudo apt update -y
sudo apt install -y php7.4
sudo apt install php7.4-{cli,fpm,json,common,mysql,zip,gd,mbstring,curl,xml,bcmath,imap,intl} -y
sudo sed -i 's/memory_limit = 128M/memory_limit = 512M/g' /etc/php/7.4/fpm/php.ini
sudo sed -i 's/;date.timezone =/date.timezone = America\/New_York/g' /etc/php/7.4/fpm/php.ini
sudo systemctl reload php7.4-fpm

sudo apt install mariadb-server mariadb-client -y
sudo systemctl start mariadb && sudo systemctl enable mariadb

#Download Mautic
cd /var/www/
LATEST_RELEASE=$(curl -L -s -H 'Accept: application/json' https://github.com/mautic/mautic/releases/latest)
LATEST_VERSION=$(echo $LATEST_RELEASE | sed -e 's/.*"tag_name":"\([^"]*\)".*/\1/')
ARTIFACT_URL="https://github.com/mautic/mautic/releases/download/$LATEST_VERSION/$LATEST_VERSION.zip"
wget $ARTIFACT_URL
sudo mkdir -p /var/www/mautic/
sudo unzip "$LATEST_VERSION.zip" -d /var/www/mautic/

sudo mkdir -p /var/www/mautic/.well-known/acme-challenge
sudo chown www-data:www-data /var/www/mautic/.well-known/acme-challenge

sudo chown -R www-data:www-data /var/www/mautic/
sudo chmod -R 755 /var/www/mautic/

#Generate SSL Letsencrypt
sudo apt install certbot -y
sudo apt install python3-certbot-nginx -y

sudo apt remove apache2 -y
sudo wget https://raw.githubusercontent.com/bonben365/linux/main/mautic.conf -P /etc/nginx/conf.d/
fi





