sudo apt update -y
sudo apt install nginx unzip -y
systemctl start nginx && systemctl enable nginx
sudo iptables -I INPUT -p tcp --dport 80 -j ACCEPT
sudo iptables -I INPUT -p tcp --dport 443 -j ACCEPT


sudo apt install mariadb-server mariadb-client -y
sudo systemctl start mariadb && sudo systemctl enable mariadb

#Installing PHP on Ubuntu
sudo apt install software-properties-common ca-certificates lsb-release apt-transport-https -y
LC_ALL=C.UTF-8 sudo add-apt-repository ppa:ondrej/php -y

sudo apt install php7.4 php7.4-fpm php7.4-mysql php-common php7.4-cli php7.4-common php7.4-opcache php7.4-readline php7.4-mbstring php7.4-xml php7.4-gd php7.4-curl -y
sudo systemctl start php7.4-fpm && sudo systemctl enable php7.4-fpm

#Download Mautic
cd /var/www/
LATEST_RELEASE=$(curl -L -s -H 'Accept: application/json' https://github.com/mautic/mautic/releases/latest)
LATEST_VERSION=$(echo $LATEST_RELEASE | sed -e 's/.*"tag_name":"\([^"]*\)".*/\1/')
ARTIFACT_URL="https://github.com/mautic/mautic/releases/download/$LATEST_VERSION/$LATEST_VERSION.zip"
wget $ARTIFACT_URL
sudo mkdir -p /var/www/mautic/
sudo unzip "$LATEST_VERSION.zip" -d /var/www/mautic/
sudo chown -R www-data:www-data /var/www/mautic

#Generate SSL Letsencrypt
sudo apt install certbot -y 


