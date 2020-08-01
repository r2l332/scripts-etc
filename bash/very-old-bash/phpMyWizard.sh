#!/bin/sh
#
#  phpMyWizard.sh
#  
#
#  Created by Lee Jelley on 05/02/2014.
#
#
echo "       .__                                  .__                         .___"
echo "______ |  |__ ______   _____ ___.__.__  _  _|__|____________ _______  __| _/"
echo "\____ \|  |  \\____ \ /     <   |  |\ \/ \/ /  \___   /\__  \\_  __ \/ __ | "
echo "|  |_> >   Y  \  |_> >  Y Y  \___  | \     /|  |/    /  / __ \|  | \/ /_/ | "
echo "|   __/|___|  /   __/|__|_|  / ____|  \/\_/ |__/_____ \(____  /__|  \____ | "
echo "|__|        \/|__|         \/\/                      \/     \/           \/ "
#
##########################################################
###   First we must download the repo for PHPmyadmin   ###
##########################################################
echo "---------------------------------------------------"
echo "---------------------------------------------------"
echo "---------------------------------------------------"
while true; do
echo "Have you downloaded the rpm?"
read yn
case "$yn" in
[Yy]* ) break;;
[Nn]* ) cd /tmp && wget http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm && rpm -Uvh epel-release-6-8.noarch.rpm; break;;
* ) echo "Please answer yes or no. ";;
esac
done
##########################################################
###  Secondly we must install the repo for PHPmyadmin  ###
##########################################################
while true; do
echo "Would you like to install phpMyadmin?"
read yn
case "$yn" in
[Yy]* ) yum install phpmyadmin -y; break;;
[Nn]* ) echo "Closing script, goodbye!" exit;;
* ) echo "Please answer yes or no. ";;
esac
done
echo "---------------------------------------------------"
echo "---------------------------------------------------"
echo "---------------------------------------------------"
###############################################################
###   The third step we need to have PHPmyadmin configured  ###
###############################################################
echo "Now we must configure phpmyadmin using"
while true; do
echo "Would you like to secure phpmyadmin, to only allow access from your local machine?"
read yn
case "$yn" in
[Yy]* ) echo -n "Please type in you're public IP address: " && read IP && sed -i 's;127.0.0.1;'$IP';g' /etc/httpd/conf.d/phpMyAdmin.conf; break;;
[Nn]* ) sed -i 's;Deny;'Allow';g' /etc/httpd/conf.d/phpMyAdmin.conf && sed -i 's;Allow,Allow;'Allow,Deny';g' /etc/httpd/conf.d/phpMyAdmin.conf; break;;
* ) echo "Please answer yes or no. ";;
esac
done
echo "----------------------------------------------------"
echo "----------------------------------------------------"
############################################################################
###   Finally we will need to restart Httpd this will enable PHPmyadmin  ###
############################################################################
echo "Restarting Httpd Service"
echo "----------------------------------------------------"
service httpd restart
echo "----------------------------------------------------"
echo "----------------------------------------------------"
echo "Now exiting the script, please navigate to your domain or IP address adding /phpmyadmin"
exit;
