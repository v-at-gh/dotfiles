#!/usr/bin/env bash
# gets info about files open by processes by PID passed as an argument

if [ "$#" -eq 0 ]; then
    # lists all open files
    PID=""
elif [ "$#" -eq 1 ]; then
    PID="-p $1"
fi

IFS=$'\n'
for f in $(lsof -nP "${PID}" | awk '$5 ~ /^REG$/ {for (i = 9; i <= NF; i++) printf "%s ", $i; print ""}' | sort | uniq); do
  # remove trailing whitespace
  f=${f% };
  ls -l $f;
  stat $f;
  file $f;
  echo;
done
