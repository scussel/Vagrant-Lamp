#!/usr/bin/env bash

# Use single quotes instead of double quotes to make it work with special-character passwords
PASSWORD='12345678'
PROJECTFOLDER='projects'

# create project folder
sudo mkdir "/var/www/html/${PROJECTFOLDER}"

# update / upgrade
sudo apt-get update
sudo apt-get -y upgrade

# install apache 2.5 and php 5.5
sudo apt-get install -y apache2
sudo apt-get install -y php5

# install mysql and give password to installer
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $PASSWORD"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $PASSWORD"
sudo apt-get -y install mysql-server
sudo apt-get install php5-mysql

# install phpmyadmin and give password(s) to installer
# for simplicity I'm using the same password for mysql and phpmyadmin
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password $PASSWORD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password $PASSWORD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password $PASSWORD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2"
sudo apt-get -y install phpmyadmin

# setup hosts file
VHOST=$(cat <<EOF
<VirtualHost *:80>
    DocumentRoot "/var/www/html/${PROJECTFOLDER}"
    <Directory "/var/www/html/${PROJECTFOLDER}">
        AllowOverride All
        Require all granted
    </Directory>
    SetEnv APPLICATION_ENV "development"
</VirtualHost>
EOF
)
echo "${VHOST}" > /etc/apache2/sites-available/000-default.conf

# enable mod_rewrite
sudo a2enmod rewrite

# restart apache
service apache2 restart

# install git
sudo apt-get -y install git

# install Composer
curl -s https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer

# crreate databases
mysql -u root -p$PASSWORD -e "create database ibrap_site"
mysql -u root -p$PASSWORD -e "create database indicadores"
mysql -u root -p$PASSWORD -e "create database scussel_site"
mysql -u root -p$PASSWORD -e "create database angular_tutorial"

# import databases on mysql
mysql -u root -p$PASSWORD ibrap_site < /var/www/html/projects/Ibrap/_installation/ibrap_site.sql
mysql -u root -p$PASSWORD indicadores < /var/www/html/projects/Indicadores/_installation/indicadores.sql
mysql -u root -p$PASSWORD scussel_site < /var/www/html/projects/PanelAdmin/_installation/scussel_site.sql
mysql -u root -p$PASSWORD angular_tutorial < /var/www/html/projects/AngularJS/_installation/angular_tutorial.sql

# config timezone
sudo rm /etc/localtime
sudo ln -s /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
sudo dpkg-reconfigure --frontend noninteractive tzdata
