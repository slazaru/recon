### Description

A collection of recon scripts that have been optimised for usage on an Ubuntu VPS instance with 1 vCPU 1 GB RAM

### Setup 

You will need to install and add to $PATH the following software:

Amass: https://github.com/OWASP/Amass

Nmap: `sudo apt install nmap -y`

Python3: `sudo apt install python3 -y`

Massdns: https://github.com/blechschmidt/massdns

httprobe: https://github.com/tomnomnom/httprobe

Aquatone: https://github.com/michenriksen/aquatone

chromium-browser: `sudo apt install chromium-browser -y`

pathbrute: https://github.com/milo2012/pathbrute

waybackurls: https://github.com/tomnomnom/waybackurls

### Usage

$ git clone THISREPO

$ cd recon

$ ./enum.sh DOMAIN

The output will be put in the current directory

