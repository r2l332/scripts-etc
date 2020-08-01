#!/bin/bash

echo "Please supply file name and full path you are altering (e.g. /etc/nginx/sites-available/blah-blah.config): "
read FilePath

read -r -p "Is this the correct path $FilePath? [y/n] " response
for i in response
do
if [[ $response =~ '[yY](es)*' ]] 
then
echo "Great, moving on"; break
fi
done


