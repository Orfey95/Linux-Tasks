#!/bin/bash


# Username of new user
username=$1

sudo setfacl -m u:$username:r /var/log/syslog
