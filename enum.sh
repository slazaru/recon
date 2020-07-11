#!/bin/bash

if [ $# -ne 1 ]; then
  echo "usage: ./enum.sh DOMAIN"
  exit 1
fi

echo "Enumerating $1 .. "
if [ ! -f "./resolvers.txt" ]; then
    echo "This script requires a list of valid dns servers in ./resolvers.txt"
    exit 1
fi

echo "Running amass .. "
amass enum -ip -src -rf ./resolvers.txt -exclude alterations -d $1 > $1.amass
echo "" > permuted-subdomains.txt
cat $1.amass | awk '{print $2}' >> permuted-subdomains.txt

if [ ! -f "./dns-permute.py" ]; then
    echo "This script requires ./dns-permute.py"
    exit 1
fi
wget https://gist.githubusercontent.com/jhaddix/86a06c5dc309d08580a018c66354a056/raw/96f4e51d96b2203f19f6381c8c545b278eaa0837/all.txt
mv all.txt subdomain-list.txt
if [ ! -f "./subdomain-list.txt" ]; then
    echo "This script requires ./subdomain-list.txt"
    exit 1
fi
echo "Creating subdomain wordlist .."
python3 dns-permute.py $1 >> permuted-subdomains.txt

echo "Verifying valid domains .."
massdns -r ./resolvers.txt -t A -o S permuted-subdomains.txt -w live-domains.txt
cat live-domains.txt | awk '{print $3}' > ip_addr_list.txt
cat ip_addr_list.txt | sort -u  > unique-live-hosts.txt
rm permuted-subdomains.txt
rm subdomain-list.txt
echo "List of valid hosts in ./unique-live-hosts.txt"

if [ ! -f "./multithread-nmap.py" ]; then
    echo "This script requires ./multithread-nmap.py"
    exit 1
fi
echo "Running nmap on all ports .."
mkdir -p nmap
python3 multithread-nmap.py

echo "Using httprobe to find web servers .."
cat unique-live-hosts.txt | httprobe -c 10 -t 5000 > httprobed_domains.txt

echo "Running aquatone .."
cat httprobed_domains.txt | aquatone

if [ ! -f "./multithread-pathbrute.py" ]; then
    echo "This script requires ./multithread-pathbrute.py"
    exit 1
fi
mkdir -p pathbrute
python3 multithread-pathbrute.py default
rm defaultPaths.txt

echo "Grabbing urls from wayback machine .."
mkdir -p wayback
echo "$1" | waybackurls > waybackurls.txt

exit 0






