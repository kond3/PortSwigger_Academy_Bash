# 2FA broken logic
## Instructions
- Open the BurpSuite
- Open Firefox, without setting the FoxyProxy Burp proxy for now
- Access the Lab page and take note of the random part of the url. This will be the argument requested by the script.

For example, if the url is `https://0a6b0066040558299fa58a0f00cb007f.web-security-academy.net/`, you will launch the script using
```
./otp1_bf.sh "0a6b0066040558299fa58a0f00cb007f"
```
- When the script prompts for a successful 302 redirect response, go to Burp, find that response, Right-click and select Show response in browser.
- Copy the link given by Burp.
- Go back to Firefox, select the FoxyProxy Burp proxy and paste the link.

