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
12) Рекурсивно изменить права доступа к файлам (задана маска файла) в заданной директории. 
<br>**Environment:**
```
./rights:
total 12
drwxrwxr-x 3 sasha1 sasha1 4096 Feb 13 11:31 ./
drwxr-xr-x 6 sasha1 sasha1 4096 Feb 13 11:31 ../
-rw-rw-r-- 1 sasha1 sasha1    0 Feb 13 11:31 file1
-rw-rw-r-- 1 sasha1 sasha1    0 Feb 13 11:31 file2
drwxrwxr-x 2 sasha1 sasha1 4096 Feb 13 11:31 sub_rights/

./rights/sub_rights:
total 8
drwxrwxr-x 2 sasha1 sasha1 4096 Feb 13 11:31 ./
drwxrwxr-x 3 sasha1 sasha1 4096 Feb 13 11:31 ../
-rw-rw-r-- 1 sasha1 sasha1    0 Feb 13 11:31 file3
-rw-rw-r-- 1 sasha1 sasha1    0 Feb 13 11:31 file4
```
```

```
13) \*Сравнить рекурсивно две директории и отобразить только отличающиеся файлы. * (вывести до 2 строки и после 3 строки относительно строки в которой найдено отличие). 
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
17) Переназначить существующую символьную ссылку.
18) Имется список фалов с относительным путем и путем к каталогу в котором должна храниться символьная ссылка на файл. Создать символьные ссылки на эти файлы. 
19) Скопировать директорию с учетом, что в ней существуют как прямые так относительные символьные ссылки на файлы и директории. Предполагается, что копирование выполняется for backup on a removable storage. (сделать в двух вариантах, без rsync и с rsync). 
20) Скопировать директорию с учетом, что в ней существуют прямые символьные относительные символьные ссылки. 
21) В директории проекта преобразовать все относительные ссылки в прямые.
22) В директории проекта преобразовать все прямые ссылки в относительные для директории проекта.
23) В указанной директории найти все сломанные ссылки и удалить их. 
24) Распаковать из архива tar, gz, bz2, lz, lzma, xz, Z определенный каталог в указанное место. 
25) Рекурсивно скопировать структуру каталогов из указанной директории. (без файлов). 
26) Вывести список всех пользователей системы (только имена) по алфавиту.
27) Вывести список всех системных пользователей системы отсортированных по id, в формате: login id. 
28) Вывести список всех пользователей системы (только имена) отсортированные по id.
29) Вывести всех пользователей которые не имеют право авторизовываться или не имеют право авторизовываться в системе. (две команды). 
30) Вывести всех пользователей которые (имеют/не имеют) терминала (bash, sh, zsh and etc.) (две команды).
31) Со страницы из интернета закачать все ссылки, которые на странице. Закачивать параллельно. Использовать curl и wget. Дать рекомендации по использованию. 
32) Остановить процессы, которые работают больше 5 дней. Команду ps не использовать. 
33) Имется дериктория, в которой, существуют папки и файлы (*.txt & *.jpeg). Файлы *.txt и *.jpeg однозначно связаны между собой по префиксу имени. Файлы могут находиться в различном месте данной директории. Нужно удалить все *.jpeg для которых не существует файла *.txt.
34) Find your IP address using the command line.
35) Получить все ip-адресса из текстового файла.
36) Найти все активные хосты в: - заданной сети,  - списке IP (hosts-server.txt) используя/не используя nMAP.
37) Используя результат таска 36. Получить ip поднятых хостов. 
38) Получить все поддомены из SSL сертификата.

