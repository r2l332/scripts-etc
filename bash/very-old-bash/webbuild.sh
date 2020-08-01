#!/bin/bash
#
# This script was written by Lee Jelley 09/11/2013
#
DBASE=wordpress
USER=root

echo "__      __                .___                                     "     
echo "/  \    /  \___________  __| _/____________   ____   ______ ______ "     
echo "\   \/\/   /  _ \_  __ \/ __ |\____ \_  __ \_/ __ \ /  ___//  ___/ "      
echo " \        (  <_> )  | \/ /_/ ||  |_> >  | \/\  ___/ \___ \ \___ \  "      
echo "  \__/\  / \____/|__|  \____ ||   __/|__|    \___  >____  >____  > "      
echo "       \/                   \/|__|               \/     \/     \/  "      
echo " __      __.__                         .___            ____    ____"___  
echo "/  \    /  \__|____________ _______  __| _/           /_   |   \   _  \   "
echo "\   \/\/   /  \___   /\__  \\_  __ \/ __ |    ______   |   |   /  /_\  \  " 
echo " \        /|  |/    /  / __ \|  | \/ /_/ |   /_____/   |   |   \  \_/   \ "
echo "  \__/\  / |__/_____ \(____  /__|  \____ |             |___| /\ \_____  / "
echo "       \/           \/     \/           \/                   \/       \/  "
echo "--------------------------------------------------------------------------"
echo "--------------------------------------------------------------------------"
echo "--------------------------------------------------------------------------"
echo "--------------------------------------------------------------------------"
sleep 1

########################################################
### First step in the script is to update the system ###
########################################################

while true; do
echo "Do you need to update your system?"
read yn
case "$yn" in
	[Yy]* ) apt-get update; break;;
	[Nn]* ) break;;
	* ) echo "Please answer yes or no. ";; 
esac 
done
sleep 1

###########################################################################
### Second task is to get the applications necessary to run the website ###
###########################################################################

echo "-------------------------------------------------------"
echo "-------------------------------------------------------"
echo "-------------------------------------------------------"
echo "-------------------------------------------------------"
while true; do
echo "Have you installed the prerequisites?"
read yn
case "$yn" in
	[Nn]* ) apt-get install apache2 -y; break;;
	[Yy]* ) break;;
	* ) echo "Please answer yes or no. ";;
esac
done
sleep 1


#################################################
### Step three is to configure Apache webpage ###
#################################################

echo "---------------------------------------------------"
echo "---------------------------------------------------"
echo "---------------------------------------------------"
echo "---------------------------------------------------"
echo "Creating Vhost page within sites-available"
echo "------------------------------------------"
echo -n "Please supply the name of your domain: "
read  DOMAIN
echo "You have entered $DOMAIN!"
touch /etc/apache2/sites-available/$DOMAIN
cp /etc/apache2/sites-available/default /etc/apache2/sites-available/$DOMAIN
hostname $DOMAIN
sleep 1

####################################################################
### Step four is to configure the document root/error pages etc. ###
####################################################################

echo "---------------------------------------------------"
echo "---------------------------------------------------"
echo "---------------------------------------------------"
echo "---------------------------------------------------"
echo "Configure the vhost page"
echo "-------------------------------------------"
echo -n "Please enter the document root for you website: "
read DOCROOT
echo "You have entered $DOCROOT"
sed -i 's;/var/www;'$DOCROOT';g' /etc/apache2/sites-available/$DOMAIN

##################################################################################
### Third step is to create the directory, this can be changed to your suiting ###
##################################################################################

mkdir -p $DOCROOT
cd $DOCROOT
mkdir wordpress

#############################################
### Now to download and install Wordpress ###
#############################################

echo "---------------------------------------------------"
echo "---------------------------------------------------"
echo "---------------------------------------------------"
echo "Retreiving the latest Wordpress package"
wget http://wordpress.org/latest.tar.gz
tar -xzvf latest.tar.gz
cp $DOCROOT/wordpress/wp-config-sample.php $DOCROOT/wordpress/wp-config.php
#sed -i 's;database_name_here;'$DBASE';g' $DOCROOT/wordpress/wp-config.php
#sed -i 's;username_here;'$USER';g' $DOCROOT/wordpress/wp-config.php
#sed -i 's;password_here;'$PASS';g' $DOCROOT/wordpress/wp-config.php

###########################################
### Now for the MySql install step five ###
###########################################

echo "---------------------------------------------------"
echo "---------------------------------------------------"
echo "---------------------------------------------------"
echo "---------------------------------------------------"
while true; do
echo "Do you want to in install MySql?"
read yn
case "$yn" in
        [Yy]* ) apt-get install mysql-server php5-mysql php5 -y; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no. ";;
esac
done
sleep 1
echo "---------------------------------------------------"
echo "---------------------------------------------------"
echo "---------------------------------------------------"
echo "---------------------------------------------------"
echo -n "What password have you set in mysql?: "
read PASS
echo "---------------------------------------------------"
echo "---------------------------------------------------"
echo "---------------------------------------------------"
########################################
### Configure MySql tables and users ###
########################################
echo "creating database called wordpress"
echo "---------------------------------------------------"
echo "---------------------------------------------------"
echo "---------------------------------------------------"
mysqladmin -u root -p$PASS create wordpress

sed -i 's;database_name_here;'$DBASE';g' $DOCROOT/wordpress/wp-config.php
sed -i 's;username_here;'$USER';g' $DOCROOT/wordpress/wp-config.php
sed -i 's;password_here;'$PASS';g' $DOCROOT/wordpress/wp-config.php

########################################################
### Now to restart both MySQL and Apache in step six ###
########################################################

echo "---------------------------------------------------"
echo "---------------------------------------------------"
echo "---------------------------------------------------"
echo "Restarting Apache."
service apache2 restart
sleep 1
echo "---------------------------------------------------"
echo "---------------------------------------------------"
echo "---------------------------------------------------"
echo "---------------------------------------------------"
echo "Restarting MySql."
service mysql restart
sleep 1

###############################################################################
### Now, for step seven the script will create an Iptables rule and save it ###
###############################################################################
echo "---------------------------------------------------"
echo "---------------------------------------------------"
echo "---------------------------------------------------"
echo "Creating Iptables rule for port 80"
echo "---------------------------------------------------"
echo "---------------------------------------------------"
iptables -I INPUT -p tcp --dport 80 -j ACCEPT
iptables-save > /etc/iptables.rule
sleep 1

#############################################################
### Now step eight will post up rule within the interface ###
#############################################################

cd /etc/network
echo 'post-up iptables-restore > /etc/iptables.rule' >> interfaces
cd ~/

#######
###
######

echo "Disabling default site"
echo "------------------------------------------------------"
echo "------------------------------------------------------"
echo "------------------------------------------------------"
a2dissite default
echo "Enabling new site configuration"
echo "------------------------------------------------------"
echo "------------------------------------------------------"
echo "------------------------------------------------------"
a2ensite $DOMAIN
echo "restart necessary services!!"
echo "------------------------------------------------------"
echo "------------------------------------------------------"
echo "------------------------------------------------------"
service apache2 restart
service mysql restart
sleep 1
echo "------------------------------------------------------"
echo "------------------------------------------------------"
echo "------------------------------------------------------"
echo "Please navigate to http://$DOMAIN/wordpress/wp-admin/install.php to finish installation"
echo "------------------------------------------------------"
echo "------------------------------------------------------"
echo "------------------------------------------------------"
echo "Or alternatively navigate to http://IPADDRESS/wordpress/wp-admin/install.php to finish installation"
echo "------------------------------------------------------"
while true; do
echo "Do you want to know your current IP address?"
read yn
case "$yn" in
[Yy]* ) ifconfig eth0 | awk '/inet / { print $2 }' | sed -e s/addr://; break;;
[Nn]* ) exit;;
* ) echo "Please answer yes or no. ";;
esac
done




