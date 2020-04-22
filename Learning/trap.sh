#!/bin/bash

count=1
trap "echo \"count: \${count}. Trapped Ctrl-C \"" SIGINT

echo This is a test script
while [ $count -le 10 ]; do
   echo "Loop #$count"
   sleep 1
   count=$(( $count + 1 ))
done
