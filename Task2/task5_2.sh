#!/bin/bash


# Username of user
username=$1

# Email of user
email=$2

# IP address
ip=$3

# Disable ssh for specific ip
echo "sshd : $3" | sudo tee -a /etc/hosts.deny

# Install postfix for emailing
sudo DEBIAN_FRONTEND=noninteractive apt install -y postfix

# Text of email
echo "Hello, Dear $username

I have to notify you that the $(hostname) system ssh connection has been temporarily disabled for you.

Contact the property for more information.


Good luck!
" > mail.txt

# Send email
echo "Subject: Temporarily ssh disable" | cat - mail.txt | sendmail -t $email

# Remove text of email
rm mail.txt
