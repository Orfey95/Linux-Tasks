#!/bin/bash


# Username of new user
username=$1

# Password for new user
password=$2

# Create user
sudo adduser $username --gecos "" --disabled-password

# Set password for new user
echo $username:$password | sudo chpasswd

# Set NORASSWD for iptables for new user
echo $username' ALL=NOPASSWD:/sbin/iptables' | sudo EDITOR='tee -a' visudo

# Crate alias without sudo for iptables for new user
echo "alias iptables='sudo iptables'" | sudo tee -a /home/$username/.bashrc
