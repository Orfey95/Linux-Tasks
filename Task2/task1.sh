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
sudo DEBIAN_FRONTEND=noninteractive apt install -y libpam-cracklib
if ! grep -q "password requisite pam_cracklib.so" /etc/pam.d/common-password;
then echo "password requisite pam_cracklib.so ucredit=-1 lcredit=-1 dcredit=-1 ocredit=-1" | sudo tee -a /etc/pam.d/common-password;
fi

# Set ask password changing when the 1st user login
username=$1
sudo chage -d 0 $username

# Deny executing ‘sudo su -’ and ‘sudo -s’
if ! sudo cat /etc/sudoers | grep "%sudo" | grep "SU";
then echo 1
sudo cat /etc/sudoers > temp_file
sed -i ':a;N;$!ba;s/Cmnd\salias\sspecification\n/Cmnd alias specification\nCmnd_Alias SU1=\/bin\/su -\nCmnd_Alias SU2=\/bin\/bash\n/' temp_file
sed -i "s/sudo   ALL=(ALL:ALL) ALL/sudo   ALL=(ALL:ALL) ALL, \!SU1, \!SU2 /" temp_file;
cat temp_file | sudo EDITOR='tee' visudo
fi

# Prevent accidental removal of /var/log/auth.log (Debian) or /var/log/secure (RedHat)
# Not immutable
sudo chattr +i /var/log/auth.log
# Remove only owner
sudo chmod +t /var/log/auth.log
