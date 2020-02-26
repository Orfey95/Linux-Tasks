#!/bin/bash

#Task3
mkdir task3
mkdir task3/sub_dir
touch task3/script1.sh task3/script2.sh task3/sub_dir/script3.sh
sudo chmod +x task3/script1.sh task3/script2.sh task3/sub_dir/script3.sh
echo "Hello World!" > task3/script1.sh task3/sub_dir/script3.sh
#Task6
mkdir task6
touch task6/file1 task6/file2 task6/file3 task6/file4 task6/file5
echo "string 1" > task6/file1
echo "string 1" > task6/file2
echo "string 2" > task6/file3
echo "string 3" > task6/file4
echo "string 3" > task6/file5
#Task7
mkdir task7
touch task7/file
ln -s task7/file task7/soft_link_file
#Task8
mkdir task8
touch task8/file
ln task8/file task8/hard_link_file
#Task9
mkdir task9
touch task9/file
ln task9/file task9/hard_link_file
#Task10
mkdir task10
touch task10/file
ln task10/file task10/hard_link_file
#Task11
mkdir task11
touch task11/file
ln task11/file task11/hard_link_file
ln -s task11/file task11/soft_link_file
#Task12
mkdir task12
mkdir task12/sub_dir
touch task12/file1 task12/file2 task12/log task12/sub_dir/file3 task12/sub_dir/file4
#Task13
mkdir task13
mkdir task13/folder1 task13/folder2
mkdir task13/folder1/sub_dir
touch task13/folder1/file1 task13/folder1/file2 task13/folder1/file3 task13/folder2/file1 task13/folder2/file2 task13/folder1/sub_dir/file4
#Task17
mkdir task17
touch task17/file1 task17/file2
ln -s task17/file1 task17/soft_link
#Task18
mkdir task18
mkdir task18/folder1 task18/folder2
touch task18/file1 task18/file2 task18/file3
#Task19
mkdir task19
mkdir task19/links
touch task19/file
ln -s task19/file task19/links/link1
ln -s task19/file task19/links/link2
#Task21
mkdir task21
touch task21/file
ln -s task21/file task21/link
#Task22
mkdir task22
touch task22/file1 task22/file2
ln task22/file1 task22/h_link1
ln task22/file2 task22/h_link2
#Task23
mkdir task23
touch task23/file
ln -s task23/file task23/true_link
ln -s task23/no_file task23/false_link1
ln -s task23/no_file task23/false_link2
ln -s task23/no_file task23/false_link3
#Task24
mkdir task24
mkdir task24/folder1 task24/folder2
touch task24/folder1/file
#Task25
mkdir task25
mkdir task25/folder1 task25/destination
mkdir task25/folder1/folder2
mkdir task25/folder1/folder2/folder3
touch task25/folder1/file1 task25/folder1/folder2/file2 task25/folder1/folder2/folder3/file3
#Task31
mkdir task31
mkdir task31/wget_links
mkdir task31/curl_links
#Task33
mkdir task33
mkdir task33/sub_dir
touch task33/company_logo.jpeg task33/no_link.jpeg task33/user_bio.txt task33/user_photo.jpeg task33/sub_dir/company_bio.txt
#Task35
mkdir task35
touch task35/list_of_ip.txt
echo "
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
" | tee task35/list_of_ip.txt
