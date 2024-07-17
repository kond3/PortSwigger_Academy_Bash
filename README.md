# PortSwigger Academy
This repository contains a collection of BASH scripts that I used to solve some PortSwigger Academy labs. In particular, some of the labs that require the Professional version of BurpSuite can also be solved with a work around. The result of how I did it is collected in this repository.
Anyone who, just like me, only has the Community version of Burp and wants to participate in expanding and improving this project is very welcome.

Il repository, esattamente come l'Academy di PortSwigger, e' suddiviso per topics (al momento solo il topic "Authentication" e' coperto). In ciascuno di questi ci sono le sottodirectory specifiche per ogni laboratorio, contenenti istruzioni, le wordlist custom e gli script.
***
## Requirements
Since the purpose of the repository is to aid in solving PortSwigger Academy labs, it goes without saying that the first requirement for using it is a basic knowledge of BurpSuite. I solved the labs using Firefox and the FoxyProxy extension, and I suggest you do the same. Anyway, any other alternative/similar configuration should go just fine.

Also, to avoid wasting time trying multiple times, or even giving up on solving the lab, you should carefully read the `readme.txt` of each subdirectory, which are written with Github formatting. These scripts work and without them I could not have solved the labs that require the Professional version of BurpSuite, since the Intruder in the Community version is very slow, represents only a demo version of the original one, and the attacks are time throttled.
