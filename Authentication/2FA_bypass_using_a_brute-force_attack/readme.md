# 2FA bypass using a brute-force attack
This one was a little tricky, because of the csrf token you have to handle. Spoiler, it was hidden in the html.
## Instructions
- Open the BurpSuite
- Open Firefox, without setting the FoxyProxy Burp proxy for now
- Access the Lab page and take note of the random part of the url. This will be the argument requested by the script.

  For example, if the url is `https://0a6b0066040558299fa58a0f00cb007f.web-security-academy.net/`, you will launch the script using
  ```
  ./otp2_bf.sh "0a6b0066040558299fa58a0f00cb007f"
  ```
- When the script prompts for a successful 302 redirect response, go to Burp, find that response, `Right-click` and select `Show response in browser`.

## Note
This script may not work on the first try, this is because to get a valid csrf token you have to repeat the credential login process each time, and a new OTP code is generated each time. For this reason, and because the OTP code was usually among them, it was preferred to "bet" on the first 3000 numbers and not iterate up to 9999.

Don't give up and keep on trying!
