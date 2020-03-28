#!/bin/bash


# Turn on script logging
set -x

# Chech date time
date
date | tee mail.txt

# Check operation system
if echo $(hostnamectl | grep "Operating System: ") | grep -q "Ubuntu 18.04"; then
   os="Ubuntu"
elif echo $(hostnamectl | grep "Operating System: ") | grep -q "CentOS Linux 7"; then
   os="Centos"
else
   echo "Your operating system does not support this script."
   exit 0
fi

# Email report 
# For Ubuntu 18.04
if [ "$os" = "Ubuntu" ]; then
   DEBIAN_FRONTEND=noninteractive apt install -y postfix > /dev/null
   echo "Subject: Logging network_checker.sh" | cat - mail.txt | sendmail -t sasha7692@gmail.com
   rm mail.txt
fi
# For Centos 7
if [ "$os" = "Centos" ]; then
   echo "Subject: Logging network_checker.sh" | cat - mail.txt | sendmail -t sasha7692@gmail.com
   rm mail.txt
fi

connection_check_first_try(){
   wget -q --spider google.com
   # If connection true, first try
   if [ $? -eq 0 ]; then
      exit 0
   # If connection false, first try
   else
      # Network restart
          if [ "$os" = "Ubuntu" ]; then
             netplan apply
          elif [ "$os" = "Centos" ]; then
             systemctl restart network
      fi
      sleep 1
   fi
}

connection_check_second_try(){
   wget -q --spider google.com
   # If connection true, second try
   if [ $? -eq 0 ]; then
      exit 0
   # If connection false, second try
   else
      # Reboot
      echo "No Connection"
      reboot
   fi
}

# If Ubuntu 18.04
if [ "$os" = "Ubuntu" ]; then
   connection_check_first_try
   connection_check_second_try
# If Centos 7
elif [ "$os" = "Centos" ]; then
   # Check wget, first try
   if [ "$(yum list installed | grep wget)" = "" ]; then
      yum install -y wget > /dev/null
   fi
   # Check wget, second try
   if [ "$(yum list installed | grep wget)" = "" ]; then
      systemctl restart network
      sleep 1
      yum install -y wget > /dev/null
   else
      exit 0
   fi
   # Check wget, third try
   if [ "$(yum list installed | grep wget)" = "" ]; then
      reboot
   fi
   connection_check_first_try
   connection_check_second_try
fi
