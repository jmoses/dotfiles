#!/bin/bash

## Enable is mode 3, nvc=true

pmset -a hibernatemode 0
nvram "use-nvramrc?"=false
rm /var/vm/sleepimage
