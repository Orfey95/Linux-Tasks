#!/bin/bash


# Turn on script logging
set -x

# Chech date time
date

# Check operation system
if echo $(hostnamectl | grep "Operating System: ") | grep -q "Ubuntu 18.04"; then
   os="Ubuntu"
elif echo $(hostnamectl | grep "Operating System: ") | grep -q "CentOS Linux 7"; then
   os="Centos"
else
   echo "Your operating system does not support this script."
   exit 0
fi

# Install wget for Ubuntu 18.04
if [ "$os" = "Ubuntu" ]; then
   if [ "$(dpkg -l | grep wget)" == "" ]; then
      apt install -y wget > /dev/null
   fi
fi

# Install wget for Centos 7
if [ "$os" = "Centos" ]; then
   if [ "$(yum list installed | grep wget)" = "" ]; then
      yum install -y wget > /dev/null
   fi
fi

# Download network_checker.sh
wget https://raw.githubusercontent.com/Orfey95/Linux-Tasks/master/Task3/network_checker.sh

# Make the file executable
script_name=$(realpath network_checker.sh)
chmod +x $script_name

# Add to cron
if ! grep -q "$script_name" /etc/crontab; then
   echo "*/5 * * * * root $script_name > /dev/null 2>&1" >> /etc/crontab
fi

# Run network_checker.sh
bash network_checker.sh 2>&1 | tee mail2.txt

# Email report 
# For Ubuntu 18.04
if [ "$os" = "Ubuntu" ]; then
   DEBIAN_FRONTEND=noninteractive apt install -y postfix > /dev/null
   echo "Subject: Logging installer.sh" | cat - mail2.txt | sendmail -t sasha7692@gmail.com
   rm mail2.txt
fi
# For Centos 7
if [ "$os" = "Centos" ]; then
   echo "Subject: Logging installer.sh" | cat - mail2.txt | sendmail -t sasha7692@gmail.com
   rm mail2.txt
fi
