Task was to implement the following policies: 

user’s password length 8+ characters; 

require password changing every 3 months; 

it is not allowed to repeat 3 last passwords; 

number up case, low case, number digit and special chars; 

ask password changing when the 1st user login; 

deny executing ‘sudo su -’ and ‘sudo -s’; 

prevent accidental removal of /var/log/auth.log (Debian) or /var/log/secure (RedHat). 

1) Create an user who can execute ‘iptables’ with any command line arguments. Let the user do not type ‘sudo iptables’ every time. 
2)  Grant access to the user to read file /var/log/syslog (Debian) or /var/log/messages (RedHat) without using SUDO for the permission. 
3) Write a script to automate applying policies from the 1 and 2. 
4) Отправить email. 

\* временное отключения входа пользователя;

\*\* Заблокировать вход в систему с определенных IP. Отправить email.
