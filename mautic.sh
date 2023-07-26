sudo apt update -y
sudo apt install nginx unzip -y
systemctl start nginx && systemctl enable nginx
sudo iptables -I INPUT -p tcp --dport 80 -j ACCEPT
sudo iptables -I INPUT -p tcp --dport 443 -j ACCEPT


sudo apt install mariadb-server mariadb-client -y
sudo systemctl start mariadb && sudo systemctl enable mariadb

sudo apt install php8.1 php8.1-fpm php8.1-mysql php-common php8.1-cli php8.1-common php8.1-opcache php8.1-readline php8.1-mbstring php8.1-xml php8.1-gd php8.1-curl -y

sudo systemctl start php8.1-fpm && sudo systemctl enable php8.1-fpm

cd /var/www/
wget -q https://www.mautic.org/download/latest

unzip -qq latest -d mautic
sudo chown -R www-data:www-data /var/www/mautic

#Generate SSL Letsencrypt
sudo apt install certbot -y 


