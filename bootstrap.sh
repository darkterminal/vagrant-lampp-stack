#!/bin/bash
# Script will auto terminate on errors
set -euo pipefail
IFS=$'\n\t'

# Update Packages
apt-get update
# Upgrade Packages
apt-get -y upgrade

# Basic Linux Stuff
apt-get install -y git

#Add Onrej PPA Repo
echo -e "\e[96m Adding PPA  \e[39m"
apt-get install -y software-properties-common
add-apt-repository -y ppa:ondrej/apache2
add-apt-repository -y ppa:ondrej/php
apt-get update

# Install PHP
echo -e "\e[96m Installing php  \e[39m"
apt-get install -y php7.4
apt-get install -y php7.4-common php7.4-mysql php7.4-xml php7.4-xmlrpc php7.4-curl php7.4-gd php7.4-imagick php7.4-cli php7.4-dev php7.4-imap php7.4-mbstring php7.4-opcache php7.4-soap php7.4-zip php7.4-intl curl mcrypt php7.4-mcrypt php7.1-json php-gettext

# Apache
echo -e "\e[96m Installing apache  \e[39m"
apt-get install -y apache2

# Enable Apache Mods
echo -e "\e[96m Enable mod_rewrite  \e[39m"
a2enmod rewrite

# Restart Apache
echo -e "\e[96m Restart apache server to reflect changes  \e[39m"
service apache2 restart

echo -e "\e[96m Installing mysql server \e[39m"
echo -e "\e[93m User: root, Password: root \e[39m"
# Set MySQL Pass
debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'

# Install MySQL
apt-get install -y mysql-server

# Restart Apache
service apache2 restart

echo -e "\e[96m Begin silent install phpMyAdmin \e[39m"

# Add phpMyAdmin PPA for latest version
# Warning!!! Don't add this PPA if you are running php v5.6
cd /tmp
wget https://files.phpmyadmin.net/phpMyAdmin/5.1.0/phpMyAdmin-5.1.0-english.tar.gz
tar xvzf phpMyAdmin-5.1.0-english.tar.gz
mv phpMyAdmin-5.1.0-english /usr/share/phpmyadmin
cd ~

mkdir -p /var/lib/phpmyadmin/tmp
mkdir /etc/phpmyadmin/
chown -R www-data:www-data /var/lib/phpmyadmin

cp /usr/share/phpmyadmin/config.sample.inc.php /usr/share/phpmyadmin/config.inc.php
cd /tmp
wget https://gist.githubusercontent.com/darkterminal/0ea14d2b956b8ffe73d54260ff66119d/raw/f599c84ee2aff096bba6701273f319448c3614ad/phpmyadmin.conf
mv phpmyadmin.conf /etc/apache2/conf-enabled/
cd ~

# Restart apache server
sudo service apache2 restart

# Check php version
php --version

# Check apache version
apache2 --version

# Check mysql version
mysql --version

# Check if php is working or not
php -r 'echo "\nYour PHP installation is working fine.\n";'

echo -e "\e[92m Open http://localhost:8181/ to check if apache is working or not. \e[39m"

# Clean up
apt-get clean

echo -e "\e[92m phpMyAdmin installed successfully \e[39m"
echo -e "\e[92m Remember: password for root user is root \e[39m"