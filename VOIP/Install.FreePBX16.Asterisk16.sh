
#!/bin/bash
#Disable Selinux then install the prerequisite packages
sed -i 's/\(^SELINUX=\).*/\SELINUX=disabled/' /etc/sysconfig/selinux
sed -i 's/\(^SELINUX=\).*/\SELINUX=disabled/' /etc/selinux/config
sudo dnf -y update

dnf -y group install "Development Tools"
adduser asterisk -m -c "Asterisk User"
dnf config-manager --set-enabled powertools
dnf -y install lynx tftp-server unixODBC mariadb-server mariadb httpd ncurses-devel sendmail sendmail-cf newt-devel libxml2-devel libtiff-devel gtk2-devel subversion git wget vim uuid-devel sqlite-devel net-tools gnutls-devel texinfo libuuid-devel libedit-devel
dnf config-manager --set-disabled powertools
dnf install -y https://downloads.mysql.com/archives/get/p/10/file/mysql-connector-odbc-8.0.21-1.el8.x86_64.rpm

dnf install -y epel-release
dnf install -y libid3tag
dnf install -y https://forensics.cert.org/cert-forensics-tools-release-el8.rpm
dnf --enablerepo=forensics install -y sox
dnf install -y audiofile-devel
dnf install -y python3-devel

sudo dnf -y install yum-utils
sudo dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
sudo dnf -y install https://rpms.remirepo.net/enterprise/remi-release-8.rpm
sudo dnf remove -y reset php*
sudo dnf module -y reset php
sudo dnf module -y install php:remi-7.4

sudo dnf install -y wget php php-pear php-cgi php-common php-curl php-mbstring php-gd php-mysqlnd php-gettext php-bcmath php-zip php-xml php-json php-process php-snmp
sudo pear install Console_Getopt

sudo firewall-cmd --add-port={80,443}/tcp --permanent
sudo firewall-cmd --reload

sudo sed -i 's/\(^upload_max_filesize = \).*/\l20M/' /etc/php.ini
sudo sed -i 's/\(^upload_max_filesize = \).*/\1128M/' /etc/php.ini

sudo sed -i 's/\(^memory_limit = \).*/\1128M/' /etc/php.ini
sudo sed -i 's/^\(User\|Group\).*/\1 asterisk/' /etc/httpd/conf/httpd.conf
sudo sed -i 's/AllowOverride None/AllowOverride All/' /etc/httpd/conf/httpd.conf
sudo sed -i 's/\(^user = \).*/\1asterisk/' /etc/php-fpm.d/www.conf
sudo sed -i 's/\(^group = \).*/\1asterisk/' /etc/php-fpm.d/www.conf
sudo sed -i 's/\(^listen.acl_users = \).*/\1apache,nginx,asterisk/' /etc/php-fpm.d/www.conf

dnf module enable nodejs:12 -y
dnf install -y nodejs

systemctl enable mariadb.service
systemctl start mariadb
systemctl enable httpd.service
systemctl start httpd.service


cd /usr/src/
git clone https://github.com/akheron/jansson.git
cd jansson
autoreconf -i
./configure --prefix=/usr/
make -j$(nproc)
make install

cd /usr/src/
git clone https://github.com/pjsip/pjproject.git
cd pjproject
./configure CFLAGS="-DNDEBUG -DPJ_HAS_IPV6=1" --prefix=/usr --libdir=/usr/lib64 --enable-shared --disable-video --disable-sound --disable-opencore-amr
make dep
make -j$(nproc)
make install
ldconfig

cd /usr/src
wget http://downloads.asterisk.org/pub/telephony/asterisk/asterisk-16-current.tar.gz
cd /usr/src
tar xvfz asterisk-16-current.tar.gz
rm -f asterisk-16-current.tar.gz
cd asterisk-*
./configure --libdir=/usr/lib64

make menuselect.makeopts
menuselect/menuselect --enable app_macro --enable format_mp3 menuselect.makeopts

contrib/scripts/get_mp3_source.sh
./contrib/scripts/install_prereq install

make -j$(nproc)
make install
make config
make samples
ldconfig

sudo groupadd asterisk
sudo useradd -r -d /var/lib/asterisk -g asterisk asterisk
sudo usermod -aG audio,dialout asterisk
sudo chown -R asterisk.asterisk /etc/asterisk /var/{lib,log,spool}/asterisk /usr/lib64/asterisk

sudo sed -i 's/#AST_USER="asterisk"/AST_USER="asterisk"/g' /etc/sysconfig/asterisk
sudo sed -i 's/#AST_GROUP="asterisk"/AST_GROUP="asterisk"/g' /etc/sysconfig/asterisk
cat /etc/sysconfig/asterisk | grep AST

sudo sed -i 's/;runuser = asterisk/runuser = asterisk/g' /etc/asterisk/asterisk.conf
sudo sed -i 's/;rungroup = asterisk/rungroup = asterisk/g' /etc/asterisk/asterisk.conf
cat /etc/asterisk/asterisk.conf | grep run

sudo systemctl restart asterisk
sudo systemctl enable asterisk

#Install and configure FreePBX
wget http://mirror.freepbx.org/modules/packages/freepbx/7.4/freepbx-16.0-latest.tgz

tar xfz freepbx-16.0-latest.tgz
cd freepbx
systemctl stop asterisk
./start_asterisk start
./install -n

fwconsole ma disablerepo commercial
fwconsole ma installall
fwconsole ma delete firewall
fwconsole reload
fwconsole restart
systemctl restart httpd php-fpm

