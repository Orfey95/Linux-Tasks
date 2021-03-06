1) Найти все системные группы и получить только их уникальные имена и id. Сохранить в файл. 
```
sasha1@task1:~$ cat /etc/group | egrep "x:([0-9]{1,3}):" | cut -d: -f1,3 | tr -s ":" " " > out.txt
sasha1@task1:~$ cat out.txt
vagrant@EPUAKHAW013DT11:~$ cat out.txt
root 0
daemon 1
bin 2
sys 3
adm 4
tty 5
disk 6
lp 7
mail 8
news 9
uucp 10
man 12
proxy 13
kmem 15
dialout 20
fax 21
voice 22
cdrom 24
floppy 25
tape 26
sudo 27
audio 29
dip 30
www-data 33
backup 34
operator 37
list 38
irc 39
src 40
gnats 41
shadow 42
utmp 43
video 44
sasl 45
plugdev 46
staff 50
games 60
users 100
systemd-journal 101
systemd-network 102
systemd-resolve 103
input 104
crontab 105
syslog 106
messagebus 107
lxd 108
mlocate 109
uuidd 110
ssh 111
landscape 112
admin 113
netdev 114
vboxsf 115
```
---
2) Найти все файлы и директории, который имеют права для доступа соответствующих user и group.
```
vagrant@task1:~$ find -uid 1000 -gid 1000
.
./.ssh
./.ssh/authorized_keys
./.bash_logout
./.gnupg
./.gnupg/private-keys-v1.d
./.cache
./.cache/motd.legal-displayed
./.profile
./scripts
./scripts/script2.sh
./scripts/sub_scripts
./scripts/sub_scripts/script3.sh
./scripts/script1.sh
./.bashrc
```
---
3) Найти все скрипты в указанной директории и ее поддиректориях.
<br>**Environment:**
```
vagrant@task1:~$ tree
.
└── scripts
    ├── script1.sh
    ├── script2.sh
    └── sub_scripts
        └── script3.sh

2 directories, 3 files
```
```
vagrant@EPUAKHAW013DT11:~/3$ find . -executable -regex '.*sh\|.*\.py'
./scripts/script2.sh
./scripts/sub_scripts/script3.sh
./scripts/script1.sh
```
---
4) Выполнить поиск файлов скриптов из под определенного пользователя.
```
vagrant@task1:~$ sudo find / -user vagrant -executable -regex '.*sh\|.*\.py'
/home/vagrant/scripts/script2.sh
/home/vagrant/scripts/sub_scripts/script3.sh
/home/vagrant/scripts/script1.sh
```
---
5) Выполнить рекурсивный поиск слов или фразы для определенного типа файлов. 
<br>**Environment:**
```
vagrant@EPUAKHAW013DT11:~/task3$ tree
.
├── script1.sh
├── script2.sh
└── sub_dir
    └── script3.sh
vagrant@EPUAKHAW013DT11:~/task3$ cat sub_dir/script3.sh script1.sh
Hello World!
Hello World!
```
```
vagrant@EPUAKHAW013DT11:~/task3$ find . -name "*.sh" -exec grep -rl Hello {} \;
./script1.sh
./sub_dir/script3.sh
```
---
6) Найти дубликаты файлов в заданных каталогах. Вначале сравнивать по размеру, затем по варианту (выбрать хешь функцию: CRC32, MD5, SHA-1, sha224sum). Результат должен быть отсортирован по имени файла. 
<br>**Environment:**
```
vagrant@task1:~/31$ cat file1 file2 file3 file4 file5
string 1
string 1
string 2
string 3
string 3
```
```
[vagrant@EPUAKHAWO13DT35 task6]$ find . -type f -exec du -h {} \; | sort
4.0K    ./file1
4.0K    ./file2
4.0K    ./file3
4.0K    ./file4
4.0K    ./file5

vagrant@task1:~/31$ find . ! -empty -type f -exec sha1sum {} + | grep "^$(find . ! -empty -type f -exec sha1sum {} + | cut -d' ' -f1 | sort | uniq -d)" | sort | uniq -w32 --all-repeated=separate
612d726f832ac6e9540339b9792c04abc06dccac  ./file4
612d726f832ac6e9540339b9792c04abc06dccac  ./file5

803c85afdbdef4e0907938d549d957f8f7830fb8  ./file1
803c85afdbdef4e0907938d549d957f8f7830fb8  ./file2
```
---
7) Найти по имени файла и его пути все символьные ссылки на него. 
<br>**Environment:**
```
vagrant@task1:~$ touch file
vagrant@task1:~$ ln -s file file_soft_link
vagrant@task1:~$ ls -li
total 2
 60377 -rw-rw-r-- 2 vagrant vagrant    0 Feb 12 15:56 file
 60380 lrwxrwxrwx 1 vagrant vagrant    4 Feb 12 15:57 file_sl -> file
```
```
vagrant@task1:~$ find -lname file
./file_soft_link
```
---
8) Найти по имени файла и его пути все жесткие ссылки на него. 
<br>**Environment:**
```
vagrant@task1:~$ touch file
vagrant@task1:~$ ln file file_hard_link
vagrant@task1:~$ ls -li
total 2
 60377 -rw-rw-r-- 2 vagrant vagrant    0 Feb 12 15:56 file
 60377 -rw-rw-r-- 2 vagrant vagrant    0 Feb 12 15:56 file_hl
```
```
vagrant@task1:~$ find -samefile file
./file
./file_hard_link
```
---
9) Имеется только inode файла найти все его имена. 
<br>**Environment:**
```
vagrant@task1:~$ ls -li
total 2
 60377 -rw-rw-r-- 2 vagrant vagrant    0 Feb 12 15:56 file
 60377 -rw-rw-r-- 2 vagrant vagrant    0 Feb 12 15:56 file_hl
```
```
vagrant@task1:~$ find -inum 60377
./file
./file_hl
```
---
10) Имеется только inode файла найти все его имена. Учтите, что может быть примонтированно несколько разделов.
<br>**Environment:**
```
vagrant@task1:~/links$ ls -li
278585 -rw-rw-r-- 2 vagrant vagrant 0 Feb 13 09:09 file
278585 -rw-rw-r-- 2 vagrant vagrant 0 Feb 13 09:09 file_hard_link
```
```
vagrant@task1:~/links$ find -mount -inum 278585
./file
./file_hard_link
```
---
11) Корректно удалить файл с учетом возможности существования символьных или жестких ссылок.
<br>**Environment:**
```
sasha1@task1:~/links$ ll -li
total 8
278632 drwxrwxr-x  2 sasha1 sasha1 4096 Feb 14 08:21 ./
278602 drwxr-xr-x 11 sasha1 sasha1 4096 Feb 13 15:21 ../
278633 -rw-rw-r--  2 sasha1 sasha1    0 Feb 13 13:55 file
278633 -rw-rw-r--  2 sasha1 sasha1    0 Feb 13 13:55 hard_link
278657 lrwxrwxrwx  1 sasha1 sasha1    4 Feb 14 08:21 soft_link -> file
```
```
sasha1@task1:~/links$ rm $(find -samefile file && find -lname file)
```
---
12) Рекурсивно изменить права доступа к файлам (задана маска файла) в заданной директории. 
<br>**Environment:**
```
sasha1@task1:~$ ll -Rl rights
rights:
total 12
drwxrwxr-x 3 sasha1 sasha1 4096 Feb 13 12:27 ./
drwxr-xr-x 6 sasha1 sasha1 4096 Feb 13 12:23 ../
-rw-rw-r-- 1 sasha1 sasha1    0 Feb 13 12:24 file1
-rw-rw-r-- 1 sasha1 sasha1    0 Feb 13 12:24 file2
-rw-rw-r-- 1 sasha1 sasha1    0 Feb 13 12:27 log
drwxrwxr-x 2 sasha1 sasha1 4096 Feb 13 12:24 sub_rights/

rights/sub_rights:
total 8
drwxrwxr-x 2 sasha1 sasha1 4096 Feb 13 12:24 ./
drwxrwxr-x 3 sasha1 sasha1 4096 Feb 13 12:27 ../
-rw-rw-r-- 1 sasha1 sasha1    0 Feb 13 12:24 file3
-rw-rw-r-- 1 sasha1 sasha1    0 Feb 13 12:24 file4
```
```
sasha1@task1:~$ find . -type f -name 'file*' -exec chmod +x {} \;
sasha1@task1:~$ ll -Rl rights
rights:
total 12
drwxrwxr-x 3 sasha1 sasha1 4096 Feb 13 12:27 ./
drwxr-xr-x 6 sasha1 sasha1 4096 Feb 13 12:23 ../
-rwxrwxr-x 1 sasha1 sasha1    0 Feb 13 12:24 file1*
-rwxrwxr-x 1 sasha1 sasha1    0 Feb 13 12:24 file2*
-rw-rw-r-- 1 sasha1 sasha1    0 Feb 13 12:27 log
drwxrwxr-x 2 sasha1 sasha1 4096 Feb 13 12:24 sub_rights/

rights/sub_rights:
total 8
drwxrwxr-x 2 sasha1 sasha1 4096 Feb 13 12:24 ./
drwxrwxr-x 3 sasha1 sasha1 4096 Feb 13 12:27 ../
-rwxrwxr-x 1 sasha1 sasha1    0 Feb 13 12:24 file3*
-rwxrwxr-x 1 sasha1 sasha1    0 Feb 13 12:24 file4*
```
---
13) \*Сравнить рекурсивно две директории и отобразить только отличающиеся файлы. * (вывести до 2 строки и после 3 строки относительно строки в которой найдено отличие). 
<br>**Environment:**
```
vagrant@task1:~$ tree task13/
task13/
├── folder1
│   ├── file1
│   ├── file2
│   ├── file3
│   └── sub_dir
│       └── file4
└── folder2
    ├── file1
    └── file2
```
```
vagrant@task1:~/task13$ find . -type f -exec basename {} \; | sort | uniq -u
file3
file4
```
---
14) Получить MAC-адреса сетевых интерфейсов.
```
vagrant@task1:~$ ifconfig | egrep "ether " | cut -b 15-31
02:57:a3:c3:eb:b7
08:00:27:99:fc:18
```
---
15) Вывести список пользователей, авторизованных в системе на текущий момент. 
```
vagrant@task1:~$ who
vagrant  pts/0        2020-02-12 14:39 (10.0.2.2)
```
---
16) Вывести список активных сетевых соединений в виде таблицы: тип состояния соединения и их количество. 
```
vagrant@EPUAKHAW013DT11:~$ ss -t | tail -n +2 | tr -s " " | cut -d' ' -f1 | sort | uniq -c
      1 ESTAB
```
---
17) Переназначить существующую символьную ссылку.
<br>**Environment:**
```
sasha1@task1:~/links$ ll
total 8
drwxrwxr-x 2 sasha1 sasha1 4096 Feb 13 13:36 ./
drwxr-xr-x 9 sasha1 sasha1 4096 Feb 13 13:35 ../
-rw-rw-r-- 1 sasha1 sasha1    0 Feb 13 13:35 file1
-rw-rw-r-- 1 sasha1 sasha1    0 Feb 13 13:35 file2
lrwxrwxrwx 1 sasha1 sasha1    5 Feb 13 13:36 soft_link -> file1
```
```
sasha1@task1:~/links$ ln -sf file2 soft_link
sasha1@task1:~/links$ ll
total 8
drwxrwxr-x 2 sasha1 sasha1 4096 Feb 13 13:37 ./
drwxr-xr-x 9 sasha1 sasha1 4096 Feb 13 13:35 ../
-rw-rw-r-- 1 sasha1 sasha1    0 Feb 13 13:35 file1
-rw-rw-r-- 1 sasha1 sasha1    0 Feb 13 13:35 file2
lrwxrwxrwx 1 sasha1 sasha1    5 Feb 13 13:37 soft_link -> file2
```
---
18) Имется список фалов с относительным путем и путем к каталогу в котором должна храниться символьная ссылка на файл. Создать символьные ссылки на эти файлы. 
<br>**Environment:**
```
vagrant@task1:~$ tree dir1 dir2
dir1
├── file1
├── file2
└── file3
dir2
```
```
vagrant@task1:~/dir2$ ln -s ../dir1/* /home/vagrant/dir2
vagrant@task1:~$ tree dir1 dir2
dir1
├── file1
├── file2
└── file3
dir2
├── file1 -> ../dir1/file1
├── file2 -> ../dir1/file2
└── file3 -> ../dir1/file3
```
---
19) Скопировать директорию с учетом, что в ней существуют как прямые так относительные символьные ссылки на файлы и директории. Предполагается, что копирование выполняется for backup on a removable storage. (сделать в двух вариантах, без rsync и с rsync). 
<br>**Environment:**
```
vagrant@task1:~$ tree links2 destination
links2
├── file
└── links
    ├── link -> ../file
    └── link2 -> ../file
destination
```
Без rsync
```
vagrant@task1:~$ cp -r links2/* destination
vagrant@task1:~$ tree links2 destination
links2
├── file
└── links
    ├── link -> ../file
    └── link2 -> ../file
destination
├── file
└── links
    ├── link -> ../file
    └── link2 -> ../file
```
C rsync
```
vagrant@task1:~$ rsync -r -l links2/* destination
vagrant@task1:~$ tree links2 destination
links2
├── file
└── links
    ├── link -> ../file
    └── link2 -> ../file
destination
├── file
└── links
    ├── link -> ../file
    └── link2 -> ../file
```
---
21) В директории проекта преобразовать все относительные ссылки в прямые.
<br>**Environment:**
```
vagrant@EPUAKHAW013DT11:~$ cd task21
vagrant@EPUAKHAW013DT11:~/task21$ tree
.
├── file
└── sub1
    └── sub2
        └── s_link -> ../../file

2 directories, 2 files
```
```
vagrant@EPUAKHAW013DT11:~/task21$ find ./ -type l -execdir bash -c 'ln -sfn "$(readlink -f "$0")" "$0"' {} \;
vagrant@EPUAKHAW013DT11:~/task21$ tree
.
├── file
└── sub1
    └── sub2
        └── s_link -> /home/vagrant/task21/file

2 directories, 2 files
```
---
22) В директории проекта преобразовать все прямые ссылки в относительные для директории проекта.
<br>**Environment:**
```
vagrant@EPUAKHAW013DT11:~/task22$ tree
.
├── file
└── sub1
    └── sub2
        └── s_link -> /home/vagrant/task22/file

2 directories, 2 files
```
```
vagrant@EPUAKHAW013DT11:~/task22$ find ./ -type l -exec bash -c 'ln -snf $(realpath --relative-to=$(dirname "$0") $(readlink -f "$0")) "$0"' {} \;
vagrant@EPUAKHAW013DT11:~/task22$ tree
.
├── file
└── sub1
    └── sub2
        └── s_link -> ../../file

2 directories, 2 files
```
---
23) В указанной директории найти все сломанные ссылки и удалить их. 
<br>**Environment:**
```
vagrant@task1:~/links$ ll
total 8
drwxrwxr-x 2 vagrant vagrant 4096 Feb 15 18:22 ./
drwxr-xr-x 6 vagrant vagrant 4096 Feb 15 18:15 ../
lrwxrwxrwx 1 vagrant vagrant   13 Feb 15 18:22 br_link1 -> no_exist_file
lrwxrwxrwx 1 vagrant vagrant   13 Feb 15 18:22 br_link2 -> no_exist_file
lrwxrwxrwx 1 vagrant vagrant   13 Feb 15 18:22 br_link3 -> no_exist_file
-rw-rw-r-- 1 vagrant vagrant    0 Feb 15 18:22 file
lrwxrwxrwx 1 vagrant vagrant    4 Feb 15 18:22 good_link -> file
```
```
vagrant@task1:~/links$ find . -xtype l -delete
vagrant@task1:~/links$ ll
total 8
drwxrwxr-x 2 vagrant vagrant 4096 Feb 15 18:22 ./
drwxr-xr-x 6 vagrant vagrant 4096 Feb 15 18:15 ../
-rw-rw-r-- 1 vagrant vagrant    0 Feb 15 18:22 file
lrwxrwxrwx 1 vagrant vagrant    4 Feb 15 18:22 good_link -> file
```
---
24) Распаковать из архива tar, gz, bz2, lz, lzma, xz, Z определенный каталог в указанное место. 
<br>**Environment:**
```
sasha1@task1:~/archives$ ll
total 40
drwxrwxr-x  2 sasha1 sasha1  4096 Feb 13 14:37 ./
drwxr-xr-x 10 sasha1 sasha1  4096 Feb 13 14:10 ../
-rw-rw-r--  1 sasha1 sasha1  6276 Feb 13 14:55 file.Z
-rw-rw-r--  1 sasha1 sasha1    14 Feb 13 14:23 bzip2.bz2
-rw-rw-r--  1 sasha1 sasha1    23 Feb 13 14:22 gz.gz
-rw-rw-r--  1 sasha1 sasha1    36 Feb 13 14:25 lz.lz
-rw-rw-r--  1 sasha1 sasha1    18 Feb 13 14:26 lzma.lzma
-rw-rw-r--  1 sasha1 sasha1 10240 Feb 13 14:13 tar.tar
-rw-rw-r--  1 sasha1 sasha1    32 Feb 13 14:27 xz.xz
```
```
sasha1@task1:~/archives$ tar -xvf tar.tar
sasha1@task1:~/archives$ gunzip gz.gz
sasha1@task1:~/archives$ bzip2 -d bzip2.bz2
sasha1@task1:~/archives$ lzip -d lz.lz
sasha1@task1:~/archives$ lzma -d lzma.lzma
sasha1@task1:~/archives$ unxz xz.xz
sasha1@task1:~/archives$ uncompress file.Z
```
tar
```
sasha1@task1:~/archives$ tar -cvf tar.tar dir1 dir2
sasha1@task1:~/archives$ tar -C /home/sasha1/archives2 -xf tar.tar dir2
```
gz
```
sasha1@task1:~/archives$ gzip tar.tar
sasha1@task1:~/archives$ tar -C /home/sasha1/archives2 -xf tar.tar.gz dir1
```
bz2
```
sasha1@task1:~/archives$ bzip2 tar.tar
sasha1@task1:~/archives$ tar -C /home/sasha1/archives2 -xf tar.tar.bz2 dir1
```
lz
```
sasha1@task1:~/archives$ lzip tar.tar
sasha1@task1:~/archives$ tar -C /home/sasha1/archives2 -xf tar.tar.lz dir1
```
lzma
```
sasha1@task1:~/archives$ lzma tar.tar
sasha1@task1:~/archives$ tar -C /home/sasha1/archives2 -xf tar.tar.lzma dir2
```
xz
```
sasha1@task1:~/archives$ xz tar.tar
sasha1@task1:~/archives$ tar -C /home/sasha1/archives2 -xf tar.tar.xz dir2
```
Z
```
sasha1@task1:~/archives$ compress tar.tar
sasha1@task1:~/archives$ tar -C /home/sasha1/archives2 -xf tar.tar.Z dir2
```
---
25) Рекурсивно скопировать структуру каталогов из указанной директории. (без файлов). 
<br>**Environment:**
```
sasha1@task1:~$ tree dir1 destination
dir1
├── dir2
│   ├── dir3
│   │   └── file3
│   └── file2
└── file1
destination
```
```
sasha1@task1:~$ rsync -av -f"+ */" -f"- *" "dir1" "destination"
sending incremental file list
dir1/
dir1/dir2/
dir1/dir2/dir3/

sent 134 bytes  received 28 bytes  324.00 bytes/sec
total size is 0  speedup is 0.00
sasha1@task1:~$ tree dir1 destination
dir1
├── dir2
│   ├── dir3
│   │   └── file3
│   └── file2
└── file1
destination
└── dir1
    └── dir2
        └── dir3

5 directories, 3 files
```
```
vagrant@task1:~/task25$ find folder1/ -type d -exec bash -c 'mkdir destination/{}' \;
vagrant@task1:~/task25$ tree
.
├── destination
│   └── folder1
│       └── folder2
│           └── folder3
└── folder1
    ├── file1
    └── folder2
        ├── file2
        └── folder3
            └── file3

7 directories, 3 files
```
---
26) Вывести список всех пользователей системы (только имена) по алфавиту.
```
sasha1@task1:~$ cat /etc/passwd | cut -d: -f1 | sort
_apt
backup
bin
daemon
dnsmasq
games
gnats
irc
landscape
list
lp
lxd
mail
man
messagebus
news
nobody
pollinate
proxy
root
sasha
sasha1
sshd
sync
sys
syslog
systemd-network
systemd-resolve
ubuntu
uucp
uuidd
vagrant
www-data
```
---
27) Вывести список всех системных пользователей системы отсортированных по id, в формате: login id. 
```
sasha1@task1:~$ cat /etc/passwd | egrep "x:(0?[1-9]|[1-9][0-9]):" | cut -d: -f1,3 | tr -s ':' ' ' | sort -k 2n
daemon 1
bin 2
sys 3
sync 4
games 5
man 6
lp 7
mail 8
news 9
uucp 10
proxy 13
www-data 33
backup 34
list 38
irc 39
gnats 41
```
---
28) Вывести список всех пользователей системы (только имена) отсортированные по id.
```
sasha1@task1:~$ cat /etc/passwd | egrep "x:(0?[1-9]|[1-9][0-9]):" | cut -d: -f1,3 | tr -s ':' ' ' | sort -k 2n | cut -d' ' -f1
daemon
bin
sys
sync
games
man
lp
mail
news
uucp
proxy
www-data
backup
list
irc
gnats
```
---
29) Вывести всех пользователей которые не имеют право авторизовываться или не имеют право авторизовываться в системе. (две команды).
```
vagrant@task1:~$ cat /etc/passwd | cut -d: -f1,7 | tr -s ':' ' ' | grep nologin
daemon /usr/sbin/nologin
bin /usr/sbin/nologin
sys /usr/sbin/nologin
games /usr/sbin/nologin
man /usr/sbin/nologin
lp /usr/sbin/nologin
mail /usr/sbin/nologin
news /usr/sbin/nologin
uucp /usr/sbin/nologin
proxy /usr/sbin/nologin
www-data /usr/sbin/nologin
backup /usr/sbin/nologin
list /usr/sbin/nologin
irc /usr/sbin/nologin
gnats /usr/sbin/nologin
nobody /usr/sbin/nologin
systemd-network /usr/sbin/nologin
systemd-resolve /usr/sbin/nologin
syslog /usr/sbin/nologin
messagebus /usr/sbin/nologin
_apt /usr/sbin/nologin
uuidd /usr/sbin/nologin
dnsmasq /usr/sbin/nologin
landscape /usr/sbin/nologin
sshd /usr/sbin/nologin
vagrant@task1:~$ cat /etc/passwd | cut -d: -f1,7 | tr -s ':' ' ' | grep -v nologin
root /bin/bash
sync /bin/sync
lxd /bin/false
pollinate /bin/false
vagrant /bin/bash
ubuntu /bin/bash
```
---
30) Вывести всех пользователей которые (имеют/не имеют) терминала (bash, sh, zsh and etc.) (две команды).
```
sasha1@task1:~$ cat /etc/passwd | cut -d: -f1,7 | tr -s ':' ' ' | grep bash | cut -d' ' -f1
root
vagrant
ubuntu
sasha1
sasha1@task1:~$ cat /etc/passwd | cut -d: -f1,7 | tr -s ':' ' ' | grep -v bash  | cut -d' ' -f1
daemon
bin
sys
sync
games
man
lp
mail
news
uucp
proxy
www-data
backup
list
irc
gnats
nobody
systemd-network
systemd-resolve
syslog
messagebus
_apt
lxd
uuidd
dnsmasq
landscape
sshd
pollinate
sasha
```
---
31) Со страницы из интернета закачать все ссылки, которые на странице. Закачивать параллельно. Использовать curl и wget. Дать рекомендации по использованию. 
wget
```
vagrant@task1:~$ wget -nd -r -P /home/vagrant/links/images -A jpeg,jpg,bmp,gif,png https://davidwalsh.name/scrape-images-wget
```
curl
```
vagrant@task1:~/31$ curl https://davidwalsh.name/scrape-images-wget | grep -Po "(http|https)://([\w_-]+(?:(?:\.[\w_-]+)+))([\w.,@?^=%&:/~+#-]*[\w@?^=%&/~+#-])?" | xargs -n 1 -P 2 -I{} wget {}
```
---
32) Остановить процессы, которые работают больше 5 дней. Команду ps не использовать. 

Check ps
```
vagrant@EPUAKHAW013DT11:~$ ps -wo pid,etime
```
```
vagrant@task1:~$ kill -9 $(find /proc -maxdepth 1 -user vagrant -type d -mmin +60 -exec basename {} \; | tail -n +3)
```
---
33) Имется дериктория, в которой, существуют папки и файлы (\*.txt & \*.jpeg). Файлы \*.txt и \*.jpeg однозначно связаны между собой по префиксу имени. Файлы могут находиться в различном месте данной директории. Нужно удалить все \*.jpeg для которых не существует файла \*.txt.
<br>**Environment:**
```
vagrant@task1:~$ tree txt_jpeg
txt_jpeg
├── company_logo.jpeg
├── no_link.jpeg
├── sub_dir
│   └── company_bio.txt
├── user_bio.txt
└── user_photo.jpeg
```
```
vagrant@task1:~/txt_jpeg$ rm -r $(find . -type f -exec basename {} \; | cut -d_ -f1 | sort | uniq -u)*
vagrant@task1:~$ tree txt_jpeg
txt_jpeg
├── company_logo.jpeg
├── sub_dir
│   └── company_bio.txt
├── user_bio.txt
└── user_photo.jpeg
```
---
34) Find your IP address using the command line.
```
vagrant@task1:~$ ip a | grep inet | cut -d' ' -f6 | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}"
127.0.0.1
10.0.2.15
192.168.0.100
```
---
35) Получить все ip-адресса из текстового файла.
<br>**Environment:**
```
vagrant@task1:~$ cat list_of_ip.txt
First ip address: 144.238.220.42
Second ip address: 151.48.136.207
Third ip address: 219.13.196.88
Fourth ip address: 159.112.101.88
Fifth ip address: 5.103.172.2
Sixth ip address: 57.70.94.162
Seventh ip address: 78.15.39.147
Eighth ip address: 90.123.201.145
Nineth ip address: 132.190.227.76
Tenth ip address: 117.58.60.172
```
```
vagrant@task1:~$ grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}" list_of_ip.txt
144.238.220.42
151.48.136.207
219.13.196.88
159.112.101.88
5.103.172.2
57.70.94.162
78.15.39.147
90.123.201.145
132.190.227.76
117.58.60.172
```
---
36) Найти все активные хосты в: 
<br> Не использую nMAP
- заданной сети 
```
vagrant@task1:~$ echo 192.168.0.{1..254} | xargs -n1 -P0 ping -c1|grep "bytes from" | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}"
192.168.0.1
192.168.0.101
192.168.0.105
192.168.0.104
```
- списке IP (hosts-server.txt) 
```
vagrant@task1:~$ cat /etc/hosts | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}" | xargs -n1 -P0 ping -c1 | grep "bytes from" | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}"
127.0.0.1
127.0.1.1
127.0.1.1
```
Использую nMAP
- заданной сети
```
vagrant@task1:~$ nmap -sn -oG - -v 192.168.0.0/24 | grep 'Status: Up'
Host: 192.168.0.101 ()  Status: Up
Host: 192.168.0.105 ()  Status: Up
```
- списке IP (hosts-server.txt)
```
vagrant@task1:~$ nmap -sn -oG - -v $(cat /etc/hosts | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}") | grep 'Status: Up'
Host: 127.0.0.1 (localhost)     Status: Up
Host: 127.0.1.1 (task1) Status: Up
Host: 127.0.1.1 (task1) Status: Up
```
---
37) Получить все поддомены из SSL сертификата.
```
vagrant@task1:~$ openssl x509 -text -noout -in /etc/ssl/certs/*.crt | grep -oP '[a-z0-9]+\.[a-z]+\.[a-z]+' | cut -d. -f1
www
ocsp
www
www
```
```
vagrant@EPUAKHAW013DT11:~$ nmap -p 443 --script ssl-cert ya.ru | egrep "DNS:" | tr -s "DNS:" " " | cut -d" " -f5-
*.yandex.az, *.yandex.tm, *.yandex.com.ua, *.yandex.de, yandex.jobs, *.yandex.net, *.xn--d1acpjx3f.xn--p1ai, *.yandex.com.ge, yandex.fr, *.yandex.fr, yandex.kz, yandex.aero, *.yandex.jobs, *.yandex.ee, yandex.com, yandex.tm, yandex.ru, *.yandex.ru, yandex.lv, *.yandex.lt, yandex.az, yandex.net, yandex.lt, ya.ru, yandex.md, yandex.ua, yandex.com.tr, yandex.co.il, yandex.by, yandex.com.ru, *.yandex.com.am, yandex.com.ua, *.yandex.com, yandex.kg, *.yandex.lv, *.yandex.co.il, yandex.uz, *.ya.ru, *.yandex.org, *.yandex.aero, yandex.com.am, xn--d1acpjx3f.xn--p1ai, *.yandex.uz, *.yandex.md, yandex.ee, *.yandex.com.ru, *.yandex.by, yandex.de, yandex.tj, *.yandex.ua, yandex.com.ge, *.yandex.tj, *.yandex.kz, *.yandex.kg, *.yandex.com.tr, yandex.org
```
---
