#!/bin/bash


# Turn on script logging
set -x

# Find network_checker.sh
script=$(find / -name network_checker.sh)

# Turn on emailing
sed -i "s/#echo/echo/" $script
