#!/usr/bin/env python

import os, os.path, shutil
from toolz.itertoolz import partition_all

prefix = "sub"
size = 5
for idx, part in enumerate(partition_all(size, filter(os.path.isfile, os.listdir('.')))):
    target = "sub-%03d" % idx
    os.mkdir(target)
    for f in part:
        shutil.move(f, os.path.join(target, f))

