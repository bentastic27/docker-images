#!/usr/bin/python

from time import sleep
from datetime import datetime
import signal
import sys

def sigterm_handler(_signo, _stack_frame):
    print(datetime.now())
    print("SIGTERM'd")
    if len(sys.argv) > 1:
        print("waiting %i seconds\n" % int(sys.argv[1]))
        sleep(int(sys.argv[1]))
        sys.exit(0)
    else:
      print("waiting forever\n")

signal.signal(signal.SIGTERM, sigterm_handler)

try:
    print("Hello, waiting for the signal")
    print("Add an arg to wait X number of seconds after sigterm to exit")
    print("ex: script.py 3\n")
    
    print(datetime.now())
    print("started")
    if len(sys.argv) > 1:
        print("will wait %i seconds after sigterm" % int(sys.argv[1]))
    print()
    
    while True:
        sleep(1)
finally:
    print(datetime.now())
    print("Goodbye")
