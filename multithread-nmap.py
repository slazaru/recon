import threading
import os

threadCounter = threading.BoundedSemaphore(10)

def nmap(host):
    cmd = 'nmap -p- -r --min-rate 50 -sC -sV -oN nmap/' + host.strip() + '.nmap --max-retries 3 ' + host.strip()
    print(cmd)
    os.system(cmd)
    threadCounter.release()

host_file = open('./unique-live-hosts.txt', 'r')

for host in host_file:
    threadCounter.acquire()
    t = threading.Thread(target=nmap, args=(host,))
    t.start()

