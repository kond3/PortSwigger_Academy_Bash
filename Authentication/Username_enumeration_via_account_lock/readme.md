# Username enumeration via account lock
## Description
According to PortSwigger Academy, the correct solution for this lab is to
- Add a payload to the username parameter and a Null Payload (selected also as type, setting 5 payload)

  Resulting in something like `username=§test§&password=test§§`, this step should make try every login 5 times.
- Use the attack type Cluster Bombs

But I couldn't get it done this way, because logins for the same user were not repeated in one after another and the real user was therefore not blocked. So created the custom wordlist `repeat_user.txt` as a workaround, with the following code, where `username.txt` is the username wordlists provided by PortSwigger Academy.
```
#!/bin/bash

while read -r line <&7;do
    for i in {1..5};do
        echo "$line">> repeat_username.txt
    done
done 7< username.txt
```
## Instructions
- Add a payload to the username parameter loading the `repeat_user.txt` file.
