#!/bin/sh

# Name regex: ^[\w:\-.]+
# Section regex: \(\w+\)
# Both regex: ^[\w:\-.]+\s\(\w+\)

#man -k . | column -t | dmenu -l 20 -fn 'Jua-14' | awk '{print $1}' | xargs -r man -Tpdf | zathura -

NAME_SEC=$(man -k . | bemenu -l 15 -p 'Open man page as PDF' -P '->' -i 5 --scrollbar=always -n --fn 'Google Sans 12' | grep -Po '^[\w:\-.]+\s\(\w+\)')
NAME=$(echo "$NAME_SEC" | awk '{print $1}')
SEC=$(echo "$NAME_SEC" | awk '{print $2}' | grep -Po '\w+')

if [[ -n "$NAME" && -n "$SEC" ]]; then
    man -Tpdf "$SEC" "$NAME" | zathura -
else
    exit 1
fi
