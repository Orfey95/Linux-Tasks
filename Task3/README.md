# List Function:
1) Install script;
- Check network connection;
- Restart network;
- emailing;
- Reboot.
2) Stop emailing;
3) Start emailing.

# Function ONE - Install script:
Command for script installing:
```
curl https://raw.githubusercontent.com/Orfey95/Linux-Tasks/master/Task3/installer.sh | sudo bash
```
Log of script:
```
+ date
+ tee mail.txt
Sat Mar 28 14:33:15 UTC 2020
+ grep -q 'Ubuntu 18.04'
++ hostnamectl
++ grep 'Operating System: '
+ echo Operating System: Ubuntu 18.04.3 LTS
+ os=Ubuntu
+ '[' Ubuntu = Ubuntu ']'
+ connection_check_first_try
+ wget -q --spider google.com
+ '[' 0 -eq 0 ']'
+ echo 'Network TRUE'
+ tee -a mail.txt
Network TRUE
+ emailing
+ '[' Ubuntu = Ubuntu ']'
+ DEBIAN_FRONTEND=noninteractive
+ apt install -y postfix

WARNING: apt does not have a stable CLI interface. Use with caution in scripts.

+ cat - mail.txt
+ echo 'Subject: Logging network_checker.sh'
+ sendmail -t sasha7692@gmail.com
+ rm mail.txt
+ '[' Ubuntu = Centos ']'
+ exit 0
```
Emailing:<br>
Case 1:
```
Sat Mar 28 15:25:01 UTC 2020
Network TRUE
```
Case 2:
```
Sat Mar 28 17:30:01 UTC 2020
Network restart
Network TRUE
```
# Function TWO - Stop emailing:
Command for stop emailing:
```
curl https://raw.githubusercontent.com/Orfey95/Linux-Tasks/master/Task3/stop_emailing.sh | sudo bash
```
# Function THREE - Start emailing:
Command for start emailing:
```
curl https://raw.githubusercontent.com/Orfey95/Linux-Tasks/master/Task3/start_emailing.sh | sudo bash
```
