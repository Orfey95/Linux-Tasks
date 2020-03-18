1) Task was to implement the following policies: <br>
- user’s password length 8+ characters; <br>
- require password changing every 3 months; <br>
- it is not allowed to repeat 3 last passwords; <br>
- number up case, low case, number digit and special chars; <br>
- ask password changing when the 1st user login; <br>
- deny executing ‘sudo su -’ and ‘sudo -s’; <br>
- prevent accidental removal of /var/log/auth.log (Debian) or /var/log/secure (RedHat). 

2) Create an user who can execute ‘iptables’ with any command line arguments. Let the user do not type ‘sudo iptables’ every time. 
```
vagrant@EPUAKHAWO13DT11:~$ ./task_2.sh newuser newpassword
```
3)  Grant access to the user to read file /var/log/syslog (Debian) or /var/log/messages (RedHat) without using SUDO for the permission. 
4) Write a script to automate applying policies from the 1 and 2. 
5) Отправить email. 

- \* временное отключения входа пользователя;

- \*\* Заблокировать вход в систему с определенных IP. Отправить email.
