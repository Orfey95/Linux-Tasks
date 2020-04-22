1) Task was to implement the following policies: <br>
- user’s password length 8+ characters; 
- require password changing every 3 months; 
- it is not allowed to repeat 3 last passwords; 
- number up case, low case, number digit and special chars; 
- ask password changing when the 1st user login; 
- deny executing ‘sudo su -’ and ‘sudo -s’.
Script for task 1:
```
vagrant@EPUAKHAWO13DT11:~$ ./task1.sh newuser newpassword
```
- prevent accidental removal of /var/log/auth.log (Debian) or /var/log/secure (RedHat). 
```
# Only sudo (root)
sudo chattr +a /var/log/auth.log
```
```
# Not immutable
sudo chattr +i /var/log/auth.log
```
```
# Remove only owner
sudo chmod +t /var/log/auth.log
```
2) Create an user who can execute ‘iptables’ with any command line arguments. Let the user do not type ‘sudo iptables’ every time. 
```
# Username of new user
username=sasha
# Password for new user
password=123
# Create user
sudo adduser $username --gecos "" --disabled-password
# Set password for new user
echo $username:$password | sudo chpasswd
# Set NORASSWD for iptables for new user
echo $username' ALL=NOPASSWD:/sbin/iptables' | sudo EDITOR='tee -a' visudo
# Crate alias without sudo for iptables for new user
echo "alias iptables='sudo iptables'" | sudo tee -a /home/$username/.bashrc
```
3)  Grant access to the user to read file /var/log/syslog (Debian) or /var/log/messages (RedHat) without using SUDO for the permission.
```
# Username of user
username=sasha
# Give permissions to read file /var/log/syslog to user
sudo setfacl -m u:$username:r /var/log/syslog
```
4) Write a script to automate applying policies from the 2 and 3. <br>

Script for task 2:
```
vagrant@EPUAKHAWO13DT11:~$ ./task2.sh newuser newpassword
```
Script for task 3:
```
vagrant@EPUAKHAWO13DT11:~$ ./task3.sh username
```
5) Отправить email. 

- \* временное отключения входа пользователя;
```
vagrant@EPUAKHAWO13DT11:~$ ./task5_1.sh username email
```
- \*\* Заблокировать вход в систему с определенных IP. Отправить email.
```
vagrant@EPUAKHAWO13DT11:~$ ./task5_2.sh username email ip_address
```
