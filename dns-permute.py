import argparse
parser = argparse.ArgumentParser()
parser.add_argument("domain", help="the domain to permute")
args = parser.parse_args()
print(args.domain)

scope = args.domain
wordlist = open('./subdomain-list.txt').read().split('\n')

for word in wordlist:
    if not word.strip(): 
        continue
    print('{}.{}'.format(word.strip(), scope))
