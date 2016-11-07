#!/bin/bash

p=0

usage="Usage: BadUsers.sh [-p]"

#detecció d'opcions d'entrada: nomñes son vàlids: sense arametre i -p

if [ $# -ne 0 ]; then
  if [ $# -eq 1 ]; then
    if [ $1 == "-p" ]; then
      p=1
    else
      echo $usage; exit 1
    fi

  else
    echo $usage; exit 1
  fi
fi

for user in `cat /etc/passwd | cut -d: -f1`; do
  home=`cat /etc/passwd | grep "$user\>" | cut -d: -f6`
  if [ -d $home ]; then
    num_fich=`find $home -type f -user $user | wc -l`
  else
    num_fich=0
  fi

  if [ $num_fich -eq 0 ]; then
    if [ $p -eq 1]; then
      user_proc=`top -n 1 -U $user -b | sed -e '1,7d' | wc -l`

      if [ $user_proc -eq 0]; then
        echo "$user"
      fi

    else
      echo "$user"
    fi
  fi
done
