#!/bin/bash


# Username of new user
username=$1

# Password for new user
password=$2

# Set require number up case, low case, number digit and special chars
# Set user’s password length 8+ characters
sudo DEBIAN_FRONTEND=noninteractive apt install -y libpam-cracklib
sed -i 's/pam_cracklib.*/pam_cracklib.so retry=3 lcredit=0 ucredit=-1 dcredit=-1 ocredit=-1 difok=1 minlen=8/' /etc/pam.d/common-password

# Set it is not allowed to repeat 3 last passwords
sed -i 's/pam_unix.so.*/pam_unix.so use_authtok obscure try_first_pass sha512 remember=3/' /etc/pam.d/common-password

# Prevent accidental removal of /var/log/auth.log (Debian) or /var/log/secure (RedHat)
# Not immutable
sudo chattr +a /var/log/auth.log

# Create user
sudo adduser $username --gecos "" --disabled-password

# Set password for new user
echo $username:$password | sudo chpasswd

# Add to sudo group
sudo usermod -aG sudo $username

# Set require password changing every 3 months
sudo chage -M 90 $username

# Set ask password changing when the 1st user login
sudo chage -d 0 $username

# Deny executing ‘sudo su -’ and ‘sudo -s’
if ! sudo cat /etc/sudoers | grep "%sudo" | grep "SU";
then 
touch /etc/sudoers.d/$username
echo "$username  ALL=(ALL) !/bin/su, !/usr/bin/su, !/bin/bash" > /etc/sudoers.d/$username
fi
