#!/bin/bash


# Turn on script logging
set -x

# Find network_checker.sh
script=$(find / -name network_checker.sh)

# Turn off emailing
sed "s/echo \"Subject:/#echo \"Subject:/" $script
