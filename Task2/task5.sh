#!/bin/bash


# Username of user
username=$1

# Email of user
email=$2

# Disable user
sudo chsh -s /bin/false $username

# Text of email
echo "Hello, Dear $username

I have to notify you that the $(hostname) system login has been temporarily disabled for you.

Contact the property for more information.


Good luck!
" > mail.txt

# Send email
echo "Subject: Temporarily disable" | cat - mail.txt | sendmail -t $email

# Remove text of email
rm mail.txt
