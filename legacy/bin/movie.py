#!/usr/bin/env python

import os, os.path, sys, re, shutil
from functools import partial

VALID = ['mp4', 'm4v', 'mkv', 'avi']
TARGET = "/Volumes/Sneezy/movies"

source = sys.argv[1]
target = sys.argv[2] if len(sys.argv) > 2 else None

def get_file_in_dir(directory, video=True):
    mapper = partial(os.path.join, directory)
    files = map(mapper, os.listdir(directory))
    ext = VALID if video else ['srt']

    possible = []
    for f in filter(os.path.isfile, files):
        if os.path.splitext(f)[1][1:] in ext:
            possible.append(f)

    if len(possible) == 1:
        return possible[0]
    elif len(filter(lambda f: 'sample' not in f.lower(), possible)) == 1:
        return filter(lambda f: 'sample' not in f.lower(), possible)[0]
    else:
        print "Can't determine source file in dir."
        print possible
        sys.exit(1)

def get_name_from_file(name):
    parts = os.path.basename(name).split('.')[:-1]

    year = None
    pretty = []
    for part in parts:
        if re.match("\d[4]$", part):
            year = part
            break
        else:
            pretty.append(part)

    return "{} ({})".format(pretty.join(' '), year)

def subtitle(source):
    d = os.path.dirname(source)

    return get_file_in_dir(d, video=False)

def proceed(message):
    print message
    print "Continue (y/n): "
    entry = raw_input().strip()

    return entry and entry[0].lower() == 'y'

def move(source, target):
    if not proceed("Moving {} )) {}".format(source, target)):
        return

    if os.path.isfile(target):
        if not proceed("{} already exists.".format(target)):
            return

    shutil.copy(source, target)


if os.path.isdir(source):
    movie = get_file_in_dir(source)
    if not movie:
        print "Can't find movie in {}".format(source)
        sys.exit(1)

    move(source, os.path.join(TARGET, movie))

    sub = subtitle(movie)
    if sub:
        move(sub, os.path.join(TARGET, os.path.splitext(movie)[0] + '.en.srt'))

elif os.path.isfile(source):
    move(source, os.path.join(TARGET, get_name_from_file(source)))
else:
    print "What is the source?"
    sys.exit(1)
