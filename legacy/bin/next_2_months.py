#!/usr/bin/env python

import subprocess, datetime, re

today = datetime.datetime.today()

d, m, y = today.day, today.month, today.year

if m == 12:
    m = 1
    y = y + 1
else:
    m = m + 1

current_month = subprocess.check_output(["cal"])
next_month = subprocess.check_output(["cal", str(m), str(y)])

def fix(s, w=20, l=False):
    if len(s) < w:
        s = (s + (" " * 20))[:20]

    if l:
        # Find today and highlight it
        s = re.sub(r"\b%s\b" % d, '\\033[1;31m%s\\033[0m' % d, s)

    return s

def dim(l):
    return '\033[94m' + l + '\033[0m'

current = current_month.split("\n")[:-2]
future = next_month.split("\n")[2:4]
for l in current[:-1]:
    print fix(l, l=True)

print current[-1] + dim(future[0][len(current[-1]):])
print dim(future[1])




