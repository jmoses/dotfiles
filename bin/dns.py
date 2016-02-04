#!/usr/bin/env python

import sys, re, collections

raw = [
    '192.168.1.117', 'jon', 	#vpn
    '192.168.1.108', 'jon', 	#emu
    '192.168.1.130', 'julie', 	#Julies-iPhone
    '192.168.1.131', 'kaylee', 	#Kaylees-iPad
    '192.168.1.150', 'device', 	#BRN001BA950537B
    '192.168.1.111', 'unknown', 	#android-87ff6738539157a5
    '192.168.1.151', 'jon', 	#giant
    '192.168.1.152', 'shared', 	#thenewthing
    '192.168.1.153', 'jon', 	#nexus
    '192.168.1.154', 'jon', 	#raspberrypi
    '192.168.1.155', 'tyler', 	#Tylers-HP
    '192.168.1.156', 'julie', 	#julie-laptop
    '192.168.1.157', 'kaylee' 	#kaylees-ipad
    '192.168.1.158', 'jon', 	#ps-vita
    '192.168.1.159', 'device', 	#livingroom-roku2
    '192.168.1.160', 'julie', 	#julies-ipod
    '192.168.1.161', 'nikki', 	#Nicoles-iPhone
    '192.168.1.162', 'tyler', 	#Tylers-HP2
    '192.168.1.163', 'tyler', 	#tylers-roku
    '192.168.1.164', 'shared', 	#julies-roku
    '192.168.1.165', 'device', 	#twine
    '192.168.1.166', 'device', 	#livingroom-fire
    '192.168.1.167', 'tyler', 	#tylers-xbox
    '192.168.1.168', 'tyler', 	#tylers-iphone
    '192.168.1.169', 'nikki', 	#jons-ipad 
    '192.168.1.170', 'nikki', 	#nikkis-laptop
    '192.168.1.171', 'jon', 	#jmoses-rmbp
    '192.168.1.172', 'jon' 	#jons-nexus7
]



domains = collections.defaultdict(list)
with open(sys.argv[1], 'r') as log:
    for record in log:
        host = re.search('(192\.168\.1\.\d{1,3})\.\d+? >', record)
        if host:
            name = re.search('A\? (.*)\. ', record)
            if name:
                domains[host.groups()[0]].append(name.groups()[0])


for host, domains in domains.iteritems():
    bases = []
    for d in domains:
        bases.append('.'.join(d.split('.')[-2:]))

    if host in owners.keys():
        print owners[host]
    else:
        print host
    print set(bases)

print owners.keys()
