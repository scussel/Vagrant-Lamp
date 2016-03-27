#!/usr/bin/env bash

# Use single quotes instead of double quotes to make it work with special-character passwords
PASSWORD='12345678'
PARAMS='--add-drop-table --add-locks --extended-insert --single-transaction -quick'

mysqldump $PARAMS -u root -p$PASSWORD ibrap_site > /var/www/html/projects/Ibrap/_installation/ibrap_site.sql
mysqldump $PARAMS -u root -p$PASSWORD indicadores > /var/www/html/projects/Indicadores/_installation/indicadores.sql
mysqldump $PARAMS -u root -p$PASSWORD scussel_site > /var/www/html/projects/PanelAdmin/_installation/scussel_site.sql
mysqldump $PARAMS -u root -p$PASSWORD angular_tutorial > /var/www/html/projects/AngularJS/_installation/angular_tutorial.sql
