#!/bin/bash


# Set user’s password length 8+ characters
if ! grep -q "minlen=8" /etc/pam.d/common-password;
then sudo sed -i 's/obscure sha512/obscure sha512 minlen=8/' /etc/pam.d/common-password;
fi

# Set require password changing every 3 months
sudo sed -i 's/PASS_MAX_DAYS\s[0-9]\+/PASS_MAX_DAYS\ 90/' /etc/login.defs

# Set it is not allowed to repeat 3 last passwords
