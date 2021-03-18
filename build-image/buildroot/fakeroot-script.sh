#!/bin/bash

# Force password of "core" user to be change on first login
cp $1/etc/shadow $1/etc/shadow-
awk -F: "BEGIN {OFS=FS;} \$1 == \"core\" {\$3=0} 1" $1/etc/shadow- > $1/etc/shadow
rm $1/etc/shadow-
