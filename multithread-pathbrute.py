import threading
import os
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("wordlist", help="the pathbrute wordlist to use")
args = parser.parse_args()

threadCounter = threading.BoundedSemaphore(20)

def pathbrute(domain):
    filename = domain.strip()
    filename = filename.replace(':','')
    filename = filename.replace('/','')
    filename = 'pathbrute/' + filename + '.pathbrute'
    cmd = 'pathbrute -s ' + args.wordlist + ' -u ' + domain.strip() + ' -v -i -n 1 > ' + filename
    print(cmd)
    os.system(cmd)
    threadCounter.release()

domain_file = open('./httprobed_domains.txt', 'r')

for domain in domain_file:
    threadCounter.acquire()
    t = threading.Thread(target=pathbrute, args=(domain,))
    t.start()
