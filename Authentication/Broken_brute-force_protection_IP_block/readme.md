# Broken brute-force protection, IP block
## Description
Each time correct credentials are given, fail count resets and IP does not get locked. The maximum failed attempt number is three. Files `kond3_username.txt` and `kond3_pwd.txt` contains, each 3 lines, the matching correct credentials `wiener:peter`. 

These files were created through the `ip_block.sh` script, which I uploaded so it can be modified if needed.
## Instructions
- Load the kond3_user.txt file in the username payload.
- Load the kond3_pwd.txt file in the password payload.
- Start the attack.
