#!/bin/bash
# Quick script created by Lee Jelley

echo "SSH KEY COPY"
break 1

echo  "Please enter IP address: "
read IP
break 1

echo  "Please enter username for remote server: "
read USER

echo  "Please enter ssh key location, including full path: "
read SSH
break 1

echo "Copy SSH keys from host to remote server"
cat $SSH | ssh -o "StrictHostKeyChecking no" $USER@$IP "cat >> ~/.ssh/authorized_keys"
