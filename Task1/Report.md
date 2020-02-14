1) Найти все системные группы и получить только их уникальные имена и id. Сохранить в файл. 
```
sasha1@task1:~$ cat /etc/group | egrep "x:(0?[1-9]|[1-9][0-9]):" | cut -d: -f1,3 > out.txt
sasha1@task1:~$ cat out.txt
daemon:1
bin:2
sys:3
adm:4
tty:5
disk:6
lp:7
mail:8
news:9
uucp:10
man:12
proxy:13
kmem:15
dialout:20
fax:21
voice:22
cdrom:24
floppy:25
tape:26
sudo:27
audio:29
dip:30
www-data:33
backup:34
operator:37
list:38
irc:39
src:40
gnats:41
shadow:42
utmp:43
video:44
sasl:45
plugdev:46
staff:50
games:60
```
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
3) Найти все скрипты в указанной директории и ее поддиректориях.
<br>Alt-H1**Environment:**
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
vagrant@task1:~$ find . -name "*.sh"
./scripts/script2.sh
./scripts/sub_scripts/script3.sh
./scripts/script1.sh
```
4) Выполнить поиск файлов скриптов из под определенного пользователя.
```
vagrant@task1:~$ sudo find / -user vagrant -name "*.sh"
/home/vagrant/scripts/script2.sh
/home/vagrant/scripts/sub_scripts/script3.sh
/home/vagrant/scripts/script1.sh
```
5) Выполнить рекурсивный поиск слов или фразы для определенного типа файлов. 
```
vagrant@task1:~$ find . -name "script*" -name "*.sh"
./scripts/script2.sh
./scripts/sub_scripts/script3.sh
./scripts/script1.sh
```
6) Найти дубликаты файлов в заданных каталогах. Вначале сравнивать по размеру, затем по варианту (выбрать хешь функцию: CRC32, MD5, SHA-1, sha224sum). Результат должен быть отсортирован по имени файла. 
<br>**Environment:**
```
vagrant@task1:~/duplicate$ cat file1 file2
Hello World!
Hello World!
```
```
vagrant@task1:~/duplicate$ ls -l --block-size=M
total 1M
-rw-rw-r-- 1 vagrant vagrant 1M Feb 13 08:52 file1
-rw-rw-r-- 1 vagrant vagrant 1M Feb 13 08:52 file2
vagrant@task1:~/duplicate$ find . ! -empty -type f -exec sha1sum {} +
a0b65939670bc2c010f4d5d6a0b3e4e4590fb92b  ./file1
a0b65939670bc2c010f4d5d6a0b3e4e4590fb92b  ./file2
```
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
sasha1@task1:~/links$ rm $(find -samefile file; find -lname file)
```
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
sasha1@task1:~$ find -name file* -exec chmod +x {} \;
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
13) \*Сравнить рекурсивно две директории и отобразить только отличающиеся файлы. * (вывести до 2 строки и после 3 строки относительно строки в которой найдено отличие). 
<br>**Environment:**
```
sasha1@task1:~$ tree folder1 folder2
folder1
├── file1
├── file2
└── file3
folder2
├── file1
└── file2
```
```
sasha1@task1:~$ diff -r folder1 folder2
Only in folder1: file3
```
14) Получить MAC-адреса сетевых интерфейсов.
```
vagrant@task1:~$ ifconfig | egrep "ether " | cut -b 15-31
02:57:a3:c3:eb:b7
08:00:27:99:fc:18
```
15) Вывести список пользователей, авторизованных в системе на текущий момент. 
```
vagrant@task1:~$ who
vagrant  pts/0        2020-02-12 14:39 (10.0.2.2)
```
16) Вывести список активных сетевых соединений в виде таблицы: тип состояния соединения и их количество. 
```
sasha1@task1:~$ netstat -ant  | tail -n +3 | cut -c69- | sort | uniq -c | sort -nr
      3 LISTEN
      1 ESTABLISHED
```
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
18) Имется список фалов с относительным путем и путем к каталогу в котором должна храниться символьная ссылка на файл. Создать символьные ссылки на эти файлы. 
19) Скопировать директорию с учетом, что в ней существуют как прямые так относительные символьные ссылки на файлы и директории. Предполагается, что копирование выполняется for backup on a removable storage. (сделать в двух вариантах, без rsync и с rsync). 
20) Скопировать директорию с учетом, что в ней существуют прямые символьные относительные символьные ссылки. 
21) В директории проекта преобразовать все относительные ссылки в прямые.
<br>**Environment:**
```
sasha1@task1:~/links$ ll
total 8
drwxrwxr-x 2 sasha1 sasha1 4096 Feb 13 13:55 ./
drwxr-xr-x 9 sasha1 sasha1 4096 Feb 13 13:35 ../
-rw-rw-r-- 1 sasha1 sasha1    0 Feb 13 13:55 file
lrwxrwxrwx 1 sasha1 sasha1    4 Feb 13 13:55 soft_link -> file
```
```
sasha1@task1:~/links$ find -type l -exec bash -c 'ln -f "$(readlink -m "$0")" "$0"' {} \;
sasha1@task1:~/links$ ll -li
total 8
278632 drwxrwxr-x 2 sasha1 sasha1 4096 Feb 13 13:56 ./
278602 drwxr-xr-x 9 sasha1 sasha1 4096 Feb 13 13:35 ../
278633 -rw-rw-r-- 2 sasha1 sasha1    0 Feb 13 13:55 file
278633 -rw-rw-r-- 2 sasha1 sasha1    0 Feb 13 13:55 soft_link
```
22) В директории проекта преобразовать все прямые ссылки в относительные для директории проекта.
23) В указанной директории найти все сломанные ссылки и удалить их. 
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
29) Вывести всех пользователей которые не имеют право авторизовываться или не имеют право авторизовываться в системе. (две команды). 
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
31) Со страницы из интернета закачать все ссылки, которые на странице. Закачивать параллельно. Использовать curl и wget. Дать рекомендации по использованию. 
32) Остановить процессы, которые работают больше 5 дней. Команду ps не использовать. 
33) Имется дериктория, в которой, существуют папки и файлы (\*.txt & \*.jpeg). Файлы \*.txt и \*.jpeg однозначно связаны между собой по префиксу имени. Файлы могут находиться в различном месте данной директории. Нужно удалить все \*.jpeg для которых не существует файла \*.txt.
34) Find your IP address using the command line.
35) Получить все ip-адресса из текстового файла.
36) Найти все активные хосты в: 
- заданной сети,  
- списке IP (hosts-server.txt) 
<br>используя/не используя nMAP.
37) Используя результат таска 36. Получить ip поднятых хостов. 
38) Получить все поддомены из SSL сертификата.
