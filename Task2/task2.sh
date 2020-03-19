vagrant@EPUAKHAWO13DT11:~$ cat task_2.sh
#!/bin/bash


# Username of new user
username=$1

# Password for new user
password=$2

# Install libpam-cracklib for password check
sudo apt install -y libpam-cracklib

# Check password
echo $password | cracklib-check | if grep -q "OK";
then

# Create user
sudo adduser $username --gecos "" --disabled-password

# Set password for new user
echo $username:$password | sudo chpasswd

# Set NORASSWD for iptables for new user
echo $username' ALL=NOPASSWD:/sbin/iptables' | sudo EDITOR='tee -a' visudo

# Crate alias without sudo for iptables for new user
echo "alias iptables='sudo iptables'" | sudo tee -a /home/$username/.bashrc
else
# If password check fail
echo "BAD password"
fi
