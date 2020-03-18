#!/bin/bash


# Username of user
username=$1

# Give permissions to read file /var/log/syslog to user
sudo setfacl -m u:$username:r /var/log/syslog
