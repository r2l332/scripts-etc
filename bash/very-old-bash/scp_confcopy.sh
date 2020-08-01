#!/bin/bash

FileName=$(echo $FilePath | sed 's@.*/@@')

echo "WELCOME TO CONFCOPY 0.1"
echo "It's science........"

sleep 1 

# User input to specify location of modified/created file.

echo "Please supply file name and full path you wish to copy (e.g. /etc/nginx/sites-available/blah-blah.config): "
read FilePath

sleep 1

echo "OK I'm copying $FilePath"
echo "Copying................."

# Copies file from lb01 to lb02. 

scp $FilePath server.com:$FilePath

echo "Copy complete"

# Request user input to determine if this file is a new vhost.

echo "Is this a new vhost file you are copying?"
read answer
Case "$answer" in
	[Yy]* ) ssh lb02 "ln -s $FilePath /etc/nginx/sites-enabled/$FileName"; echo "Sym linking vhost...." ;;
	[Nn]* ) echo "Ok moving on";;
	* ) echo "Please answer yes or no! ";;
esac

sleep 1

# Asks user if Nginx needs a reload.

echo "Would you like to reload Nginx?"
read answer
case "$answer" in
	[Yy]* ) ssh lb02 '/etc/init.d/nginx reload';echo "All Done, bye bye..........." exit;;
	[Nn]* ) echo "All Done, bye bye..........." exit;;
	* ) echo "Please answer yes or no! ";;
esac 

sleep 1
