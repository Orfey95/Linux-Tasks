#!/bin/bash


# Set user’s password length 8+ characters
if ! grep -q "minlen=8" /etc/pam.d/common-password;
then sudo sed -i 's/pam_unix.so /pam_unix.so minlen=8 /' /etc/pam.d/common-password;
fi

# Set require password changing every 3 months
sudo sed -i 's/PASS_MAX_DAYS\s[0-9]\+/PASS_MAX_DAYS\ 90/' /etc/login.defs

# Set it is not allowed to repeat 3 last passwords
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

# Set require number up case, low case, number digit and special chars
sudo apt install -y libpam-cracklib
if ! grep -q "password requisite pam_cracklib.so" /etc/pam.d/common-password;
then echo "password requisite pam_cracklib.so ucredit=-1 lcredit=-1 dcredit=-1 ocredit=-1" | sudo tee -a /etc/pam.d/common-password;
fi

# Set ask password changing when the 1st user login
