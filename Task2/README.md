1) Task was to implement the following policies: <br>
- user’s password length 8+ characters; <br>
```
if ! grep -q "minlen=8" /etc/pam.d/common-password;
then sudo sed -i 's/pam_unix.so /pam_unix.so minlen=8 /' /etc/pam.d/common-password;
fi
```
- require password changing every 3 months; <br>
```
sudo sed -i 's/PASS_MAX_DAYS\s[0-9]\+/PASS_MAX_DAYS\ 90/' /etc/login.defs
```
- it is not allowed to repeat 3 last passwords; <br>
```
if ! grep -q "use_authtok" /etc/pam.d/common-password;
then sudo sed -i 's/pam_unix.so /pam_unix.so use_authtok /' /etc/pam.d/common-password;
fi
if ! grep -q "password    required    pam_pwhistory.so  remember=3" /etc/pam.d/common-password;
# What is :a;N;$!ba;
# Create a label via :a.
# Append the current and next line to the pattern space via N.
# If we are before the last line, branch to the created label $!ba ($! means not to do it on the last line as there should be one final newline).
then sudo sed -i ':a;N;$!ba;s/(the "Primary" block)\n/(the "Primary" block)\npassword    required    pam_pwhistory.so  remember=3\n/' /etc/pam.d/common-password;
fi
```
- number up case, low case, number digit and special chars; <br>
```
sudo apt install -y libpam-cracklib
if ! grep -q "password requisite pam_cracklib.so" /etc/pam.d/common-password;
then echo "password requisite pam_cracklib.so ucredit=-1 lcredit=-1 dcredit=-1 ocredit=-1" | sudo tee -a /etc/pam.d/common-password;
fi
```
- ask password changing when the 1st user login; <br>
```
sudo chage -d 0 username
```
- deny executing ‘sudo su -’ and ‘sudo -s’; <br>
```
if ! sudo cat /etc/sudoers | grep "%sudo" | grep "SU";
then echo 1
sudo cat /etc/sudoers > temp_file
sed -i ':a;N;$!ba;s/Cmnd\salias\sspecification\n/Cmnd alias specification\nCmnd_Alias SU1=\/bin\/su -s\nCmnd_Alias SU2=\/bin\/su -\n/' temp_file
sed -i "s/sudo   ALL=(ALL:ALL) ALL/sudo   ALL=(ALL:ALL) ALL, \!SU1, \!SU2 /" temp_file;
cat temp_file | sudo EDITOR='tee' visudo
fi
```
- prevent accidental removal of /var/log/auth.log (Debian) or /var/log/secure (RedHat). 
```
sudo chattr +i /var/log/auth.log
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
